Return-Path: <linux-kernel-owner+w=401wt.eu-S1754830AbXICQ03@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754830AbXICQ03 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Sep 2007 12:26:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752462AbXICQ0V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Sep 2007 12:26:21 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:53942 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752304AbXICQ0V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Sep 2007 12:26:21 -0400
Date: Mon, 3 Sep 2007 17:26:20 +0100
From: Al Viro <viro@ftp.linux.org.uk>
To: Jan Engelhardt <jengelh@computergmbh.de>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Mounts and namespaces
Message-ID: <20070903162620.GW21089@ftp.linux.org.uk>
References: <Pine.LNX.4.64.0709031821040.24179@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0709031821040.24179@fbirervta.pbzchgretzou.qr>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 03, 2007 at 06:23:18PM +0200, Jan Engelhardt wrote:
> Hi,
> 
> 
> what happens to mounts when the namespace they exist in, exits?
> In my concrete case:
> 
> 	./newns /bin/bash
> 	# clone(CLONE_NEWNS | CLONE_THREAD | CLONE_SIGHAND | CLONE_VM)
> 	# and exec to given program
> 	mount /dev/loop0 /mnt
> 	exit
> 
> Still mounted and unreachable forever? Forced unmount and fs corruption?

lazy umount.
