Return-Path: <linux-kernel-owner+w=401wt.eu-S1752880AbXCaLCM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752880AbXCaLCM (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Mar 2007 07:02:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752881AbXCaLCM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 31 Mar 2007 07:02:12 -0400
Received: from e31.co.us.ibm.com ([32.97.110.149]:34416 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752879AbXCaLCL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Mar 2007 07:02:11 -0400
Date: Sat, 31 Mar 2007 16:39:35 +0530
From: Bharata B Rao <bharata@linux.vnet.ibm.com>
To: Jan Engelhardt <jengelh@linux01.gwdg.de>
Cc: linux-kernel@vger.kernel.org, jblunck@suse.de
Subject: Re: Heads up on VFS based union mount
Message-ID: <20070331110935.GA5831@in.ibm.com>
Reply-To: bharata@linux.vnet.ibm.com
References: <20070330100854.GD16104@in.ibm.com> <Pine.LNX.4.61.0703302103110.31834@yvahk01.tjqt.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.61.0703302103110.31834@yvahk01.tjqt.qr>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 30, 2007 at 09:04:16PM +0200, Jan Engelhardt wrote:
> 
> On Mar 30 2007 15:38, Bharata B Rao wrote:
> >
> >In union mount approach we maintain this stacking information in the 
> >dentry structure. When a filesytem is union mounted on a mountpoint, 
> >the dentry of the mount root would hold a reference to the mountpoint 
> >dentry as an overlaid dentry and these two dentries together form a 
> >union stack. Any subsequent readdir operation on this union mounted 
> >dentry would work on the overlaid dentry also thereby providing the 
> >merged view of the two filesystems.
> 
> What about whiteouts? (I cannot remember whether Jan Blunk's paper 
> mentioned it at all.)

We do have whiteout support. And as I mentioned earlier, the underlying
filesystem needs to support the new 'whiteout' filetype. As of now it is
supported for ext2, ext3 and ramfs.

Regards,
Bharata.
