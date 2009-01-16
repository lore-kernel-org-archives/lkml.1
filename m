Return-Path: <linux-kernel-owner+w=401wt.eu-S934168AbZAPNRc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934168AbZAPNRc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jan 2009 08:17:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762615AbZAPNRM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Jan 2009 08:17:12 -0500
Received: from pfepb.post.tele.dk ([195.41.46.236]:55857 "EHLO
	pfepb.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762701AbZAPNRJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jan 2009 08:17:09 -0500
Date: Fri, 16 Jan 2009 14:18:50 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Jan Engelhardt <jengelh@medozas.de>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: include2/asm -> asm-x86 dangling link
Message-ID: <20090116131850.GA21531@uranus.ravnborg.org>
References: <alpine.LSU.2.00.0901161351110.2957@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LSU.2.00.0901161351110.2957@fbirervta.pbzchgretzou.qr>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 16, 2009 at 01:55:18PM +0100, Jan Engelhardt wrote:
> Hi,
> 
> 
> since the include/asm-x86 directory is gone, the include2/asm symlink 
> that is generated in O= builds points to a non-existing directory, which 
> the SUSE rpm scripts flagged up whilst trying to package it.
> This affects at least 2.6.29-rc1.
> 
> ~/Coding_nosov/linux > l ../linux-obj/include2/
> total 4
> drwxr-xr-x  2 jengelh users   16 Jan 12 01:08 .
> drwxr-xr-x 21 jengelh users 4096 Jan 16 13:47 ..
> lrwxrwxrwx  1 jengelh users   48 Jan 12 01:08 asm -> /home/jengelh/Coding_nosov/linux/include/asm-x86
> 
> I'd appreciate if this could be addressed in a future release.
As soon as all have moved over to arch/$ARCH/include I will kill include2 support.
We are not there yet - but approaching.

	Sam
