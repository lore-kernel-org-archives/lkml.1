Return-Path: <linux-kernel-owner+w=401wt.eu-S1758940AbXJ2QDg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758940AbXJ2QDg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2007 12:03:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752855AbXJ2QD2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Oct 2007 12:03:28 -0400
Received: from saraswathi.solana.com ([198.99.130.12]:36390 "EHLO
	saraswathi.solana.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752577AbXJ2QD0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2007 12:03:26 -0400
Date: Mon, 29 Oct 2007 12:03:15 -0400
From: Jeff Dike <jdike@addtoit.com>
To: Roel Kluin <12o3l@tiscali.nl>
Cc: lkml <linux-kernel@vger.kernel.org>
Subject: Re: build failure, missing libvdeplug.h?
Message-ID: <20071029160315.GA7408@c2.user-mode-linux.org>
References: <4725FB46.70802@tiscali.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4725FB46.70802@tiscali.nl>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 29, 2007 at 04:24:54PM +0100, Roel Kluin wrote:
>   CC      arch/um/drivers/vde_user.o
> /home/roel/dnld/src/kernel/git/linux-2.6/arch/um/drivers/vde_user.c:8:24: error: libvdeplug.h: No such file or directory
> /home/roel/dnld/src/kernel/git/linux-2.6/arch/um/drivers/vde_user.c: In function 'vde_user_init':
> /home/roel/dnld/src/kernel/git/linux-2.6/arch/um/drivers/vde_user.c:18: error: 'VDECONN' undeclared (first use in this function)
> ...
> 
> the file libvdeplug.h is missing and I can't find it neither in the tree or on
> the net. 'git-grep VDECONN' shows that VDECONN isn't defined anywhere.

This is an option which requires support on the host (in the form of
vde being installed - pcap is another example of this).

				Jeff

-- 
Work email - jdike at linux dot intel dot com
