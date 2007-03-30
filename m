Return-Path: <linux-kernel-owner+w=401wt.eu-S1752135AbXC3TKm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752135AbXC3TKm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2007 15:10:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752103AbXC3TKl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Mar 2007 15:10:41 -0400
Received: from tmailer.gwdg.de ([134.76.10.23]:49098 "EHLO tmailer.gwdg.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752135AbXC3TKk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2007 15:10:40 -0400
Date: Fri, 30 Mar 2007 21:04:16 +0200 (MEST)
From: Jan Engelhardt <jengelh@linux01.gwdg.de>
To: Bharata B Rao <bharata@linux.vnet.ibm.com>
cc: linux-kernel@vger.kernel.org, jblunck@suse.de
Subject: Re: Heads up on VFS based union mount
In-Reply-To: <20070330100854.GD16104@in.ibm.com>
Message-ID: <Pine.LNX.4.61.0703302103110.31834@yvahk01.tjqt.qr>
References: <20070330100854.GD16104@in.ibm.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Spam-Report: Content analysis: 0.0 points, 6.0 required
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Mar 30 2007 15:38, Bharata B Rao wrote:
>
>In union mount approach we maintain this stacking information in the 
>dentry structure. When a filesytem is union mounted on a mountpoint, 
>the dentry of the mount root would hold a reference to the mountpoint 
>dentry as an overlaid dentry and these two dentries together form a 
>union stack. Any subsequent readdir operation on this union mounted 
>dentry would work on the overlaid dentry also thereby providing the 
>merged view of the two filesystems.

What about whiteouts? (I cannot remember whether Jan Blunk's paper 
mentioned it at all.)



Jan
-- 
