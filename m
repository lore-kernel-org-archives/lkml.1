Return-Path: <linux-kernel-owner+w=401wt.eu-S1755534AbXGOUxZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755534AbXGOUxZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Jul 2007 16:53:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751827AbXGOUxP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Jul 2007 16:53:15 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:44687 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751507AbXGOUxO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Jul 2007 16:53:14 -0400
Date: Sun, 15 Jul 2007 21:53:13 +0100
From: Al Viro <viro@ftp.linux.org.uk>
To: Jan Engelhardt <jengelh@computergmbh.de>
Cc: linux-fsdevel@vger.kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: *at syscalls for xattrs?
Message-ID: <20070715205313.GE21668@ftp.linux.org.uk>
References: <Pine.LNX.4.64.0707132228460.25352@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0707132228460.25352@fbirervta.pbzchgretzou.qr>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jul 15, 2007 at 09:46:27PM +0200, Jan Engelhardt wrote:
> Hi,
> 
> 
> recently, the family of *at() syscalls and functions (openat, fstatat, 
> etc.) have been added to Linux and Glibc, respectively.
> In short: I am missing xattr at functions :)

No.  They are not fscking forks.  They are almost as revolting, but
not quite on the same level.

> BTW, why is fstatat called fstatat and not statat? (Same goes for 
> futimesat.) It does not take a file descriptor for the file argument. 
> Otherwise we'd also need fopenat/funlinkat, etc. Any reasons?

Ulrich having an odd taste?
