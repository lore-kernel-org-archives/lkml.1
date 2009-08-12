Return-Path: <linux-kernel-owner+w=401wt.eu-S1752255AbZHLWKi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752255AbZHLWKi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Aug 2009 18:10:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752200AbZHLWKi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Aug 2009 18:10:38 -0400
Received: from main.gmane.org ([80.91.229.2]:49850 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752061AbZHLWKh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Aug 2009 18:10:37 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: David Wuertele <dave+gmane@wuertele.com>
Subject: Re: Can initramfs be mounted read-only?
Date: Wed, 12 Aug 2009 22:10:21 +0000 (UTC)
Message-ID: <loom.20090812T220624-312@post.gmane.org>
References: <loom.20090812T194647-427@post.gmane.org> <9b2b86520908121424qff7443fn84d07fb8dff7c863@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Complaints-To: usenet@ger.gmane.org
X-Gmane-NNTP-Posting-Host: main.gmane.org
User-Agent: Loom/3.14 (http://gmane.org/)
X-Loom-IP: 136.182.2.26 (Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.0.13) Gecko/2009073021 Firefox/3.0.13)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Jenkins <sourcejedi.lkml <at> googlemail.com> writes:

>> I've been trying to create a system with a read-only rootfs using initramfs,
> 
> Changing this could potentially break a lot of systems.  At least
> Debian has "ro" as a default boot option, and it uses an initramfs by
> default.

I don't want to change it for everybody, just my own system.  Since I'm not
using Debian, or any other distribution, I can handle the consequences.

>> Is it possible to
>> mount an initramfs read-only?
>
> Have you tried running "mount / -oremount,ro" in an init script?

Yes, and it works (the rootfs appears read-only after doing this).
I was hoping to get it to be read-only before init gets run.

Dave


