Return-Path: <linux-kernel-owner+w=401wt.eu-S1763884AbXGXBpZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763884AbXGXBpZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jul 2007 21:45:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759023AbXGXBpP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jul 2007 21:45:15 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:52860 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757746AbXGXBpO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jul 2007 21:45:14 -0400
Date: Tue, 24 Jul 2007 02:45:12 +0100
From: Al Viro <viro@ftp.linux.org.uk>
To: Jeff Garzik <jeff@garzik.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.23-rc1: i386 section mismatch warnings
Message-ID: <20070724014512.GO21668@ftp.linux.org.uk>
References: <46A5536E.6010606@garzik.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46A5536E.6010606@garzik.org>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 23, 2007 at 09:18:38PM -0400, Jeff Garzik wrote:
> make allmodconfig on i386:
> 
> WARNING: vmlinux(.text+0xc0101183): Section mismatch: reference to 

Ignore.  vmlinux.o ones are interesting; so are ones in modules.
vmlinux ones are either duplicates of vmlinux.o or false positives.
