Return-Path: <linux-kernel-owner+w=401wt.eu-S1751319AbZHLVYT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751319AbZHLVYT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Aug 2009 17:24:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751060AbZHLVYS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Aug 2009 17:24:18 -0400
Received: from mail-fx0-f228.google.com ([209.85.220.228]:40266 "EHLO
	mail-fx0-f228.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751012AbZHLVYR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Aug 2009 17:24:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=jbRLdpde6oIRWEy13Sv+taQl9hgt/OSmlBHg09k5nEe3eiI7mYrqYrnWezM8D1a9hk
         aK8hXZ0zonrg39JWk9fC6lJSOy/M4yvNVvQD2oYQOwkNJ7VjoRHdEDKEqv07Ru0ZQvEE
         G9zWBuzd0qsJ1JA4Np1nWutjCNuPIr+uMFHp0=
MIME-Version: 1.0
In-Reply-To: <loom.20090812T194647-427@post.gmane.org>
References: <loom.20090812T194647-427@post.gmane.org>
Date: Wed, 12 Aug 2009 22:24:16 +0100
Message-ID: <9b2b86520908121424qff7443fn84d07fb8dff7c863@mail.gmail.com>
Subject: Re: Can initramfs be mounted read-only?
From: Alan Jenkins <sourcejedi.lkml@googlemail.com>
To: David Wuertele <dave+gmane@wuertele.com>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 8/12/09, David Wuertele <dave+gmane@wuertele.com> wrote:
> I've been trying to create a system with a read-only rootfs using initramfs,
> but I'm not having any luck.  I've included "ro" on my command line and when
> I cat /proc/cmdline it reports "ro" like I expect.  But when I type "mount",
> I see this:
>
>   rootfs on / type rootfs (rw)

Changing this could potentially break a lot of systems.  At least
Debian has "ro" as a default boot option, and it uses an initramfs by
default.

> And I can create new files and write to them just fine.  Is it possible to
> mount an initramfs read-only?
>
> The documentation for early userspace and initramfs does not talk about
> read/write permissions.

Have you tried running "mount / -oremount,ro" in an init script?

Regards
Alan
