Return-Path: <linux-kernel-owner+w=401wt.eu-S1757067AbXGPIER@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757067AbXGPIER (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jul 2007 04:04:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752889AbXGPIEF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Jul 2007 04:04:05 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:56172 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752004AbXGPIED (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jul 2007 04:04:03 -0400
Date: Mon, 16 Jul 2007 09:04:02 +0100
From: Al Viro <viro@ftp.linux.org.uk>
To: Jan Engelhardt <jengelh@computergmbh.de>
Cc: Nicholas Miell <nmiell@comcast.net>, linux-fsdevel@vger.kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: *at syscalls for xattrs?
Message-ID: <20070716080401.GI21668@ftp.linux.org.uk>
References: <Pine.LNX.4.64.0707132228460.25352@fbirervta.pbzchgretzou.qr> <20070715205313.GE21668@ftp.linux.org.uk> <1184534001.2765.5.camel@entropy> <20070715222323.GG21668@ftp.linux.org.uk> <Pine.LNX.4.64.0707160954160.25352@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0707160954160.25352@fbirervta.pbzchgretzou.qr>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 16, 2007 at 09:56:10AM +0200, Jan Engelhardt wrote:
> >Just one question: what the bleeding hell for?  Not that the rest of
> >..at() family made any damn sense as an interface...
> 
> fd1 = open("dir1", O_DIRECTORY):
> fd2 = open("dir2", O_DIRECTORY);
> system("mount -t tmpfs none dir1");
> system("mount -t tmpfs none dir2");
> openat(fd1, "file1", O_RDWR | O_CREAT);
> openat(fd2, "file2", O_RDWR | O_CREAT);
> 
> If you have a better way to accomplish this, let me know. :)

To accomplish what, exactly?  Access to overmounted directory?
So bind it elsewhere and use that.  I still don't see the point -
neither of the interface nor of your example...
