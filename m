Return-Path: <linux-kernel-owner+w=401wt.eu-S1765001AbZAQXzZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765001AbZAQXzZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Jan 2009 18:55:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752683AbZAQXzJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Jan 2009 18:55:09 -0500
Received: from mail-ew0-f12.google.com ([209.85.219.12]:63028 "EHLO
	mail-ew0-f12.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751184AbZAQXzI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Jan 2009 18:55:08 -0500
X-Greylist: delayed 432 seconds by postgrey-1.27 at vger.kernel.org; Sat, 17 Jan 2009 18:55:07 EST
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=g3Bmtz4kGeAl/yG2d6wOISzYh0DG2A3/xlNFvn0K5Dx9KMfcPVwG59AZb+y0d7Iz1X
         d94WP08mr3ZWv9gg3fhZAZ1Eq7LRcwAQ0rjg+aF5L+jLjGFa1gq92LQjYsbv7mkCaTGr
         v16TT6EzDKhiC6bmI9zwV9ohWju3g2qJb9Ytw=
MIME-Version: 1.0
In-Reply-To: <200901172226.n0HMQEEJ024690@taverner.cs.berkeley.edu>
References: <200901172226.n0HMQEEJ024690@taverner.cs.berkeley.edu>
Date: Sun, 18 Jan 2009 02:47:53 +0300
Message-ID: <b6fcc0a0901171547o26a2cd1l86dc09fcb28a667@mail.gmail.com>
Subject: Re: Checking module parameters
From: Alexey Dobriyan <adobriyan@gmail.com>
To: David Wagner <daw@cs.berkeley.edu>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 18, 2009 at 1:26 AM, David Wagner <daw@cs.berkeley.edu> wrote:
> Is there a way to tell what options have been applied to a currently
> loaded kernel module?

/sys/module/[module name]/parameters/ (if i remember correctly)

> I'm trying to force libata to use 1.5Gbps rather than 3Gbps, so I created
> a file /etc/modprobe.d/local containing:
>  options libata force=1.5Gbps
> However my SATA drive gets loaded at 3Gbps.  I'm trying to figure out how
> to debug this so that I can tell whether the option got correctly applied
> to the libata module, and if not, how to force the SATA link to 1.5Gbps.
> Any suggestions or ideas?
>
> (I can't set libata.force=1.5Gbps as a kernel argument because on my
> Fedora kernel, libata is loaded as a module rather than built into the
> kernel.  I can't run "modprobe libata force=1.5Gbps" by hand because
> I've got SATA drives, so the libata module is automatically loaded before
> I get shell access.)

This may not work if libata module is loaded from initrd.
