Return-Path: <linux-kernel-owner+w=401wt.eu-S1759515AbZBLPb6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759515AbZBLPb6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Feb 2009 10:31:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757951AbZBLPbt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Feb 2009 10:31:49 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:33347 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757742AbZBLPbs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Feb 2009 10:31:48 -0500
Date: Thu, 12 Feb 2009 15:31:46 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Jan Engelhardt <jengelh@medozas.de>
Cc: John Ogness <dazukocode@ogness.net>, linux-kernel@vger.kernel.org,
       malware-list@lists.printk.net, eparis@redhat.com, hch@infradead.org,
       alan@lxorguk.ukuu.org.uk
Subject: Re: [PATCHv2 1/5] VFS: DazukoFS, stackable-fs, file access control
Message-ID: <20090212153146.GG28946@ZenIV.linux.org.uk>
References: <8663jrgwo4.fsf@johno.fn.ogness.net> <861vufgwlt.fsf@johno.fn.ogness.net> <alpine.LSU.2.00.0902121618500.5658@fbirervta.pbzchgretzou.qr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LSU.2.00.0902121618500.5658@fbirervta.pbzchgretzou.qr>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 12, 2009 at 04:27:14PM +0100, Jan Engelhardt wrote:

> This ought to be done better in light of the problem that one
> could issue `mount -t dazukofs /mnt /opt`
> In kernel code, I'm thinking something like
> 
> static int foofs_dothis(...)
> {
> 	buf = call d_path on sb->s_root

Call what on what?  There is no such thing as the mountpoint of superblock.
