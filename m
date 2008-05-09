Return-Path: <linux-kernel-owner+w=401wt.eu-S1758736AbYEIEXD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758736AbYEIEXD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 May 2008 00:23:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756730AbYEIEWs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 May 2008 00:22:48 -0400
Received: from mail.fieldses.org ([66.93.2.214]:50819 "EHLO fieldses.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756672AbYEIEWr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 May 2008 00:22:47 -0400
Date: Fri, 9 May 2008 00:22:38 -0400
To: "P.V.Anthony" <pvantony@singnet.com.sg>
Cc: linux-kernel@vger.kernel.org
Subject: Re: How to change the FSINFO for nfsd?
Message-ID: <20080509042238.GC21408@fieldses.org>
References: <482332CD.4010706@singnet.com.sg>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <482332CD.4010706@singnet.com.sg>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
From: "J. Bruce Fields" <bfields@fieldses.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 09, 2008 at 01:05:17AM +0800, P.V.Anthony wrote:
> Hi,
> 
> Currently a gentoo linux server is used as a nfs server for some Mac OS
> X clients. These Mac OS X clients are doing video editing.
> 
> Currently the video are captured directly to the NFS mounts.
> 
> Here is the problem. The video files are broken into 2GB files. This
> because the video editing software(Final Cut Pro) breaks the files into
> 2GB sizes. It does not seem that the Mac OS X is not doing the breaking
> up of files. It is the video editing software.
> 
> Some commercial company found an interesting behaviour. All the Mac OS X
> NFS server FSINFO response in which the max file size is set to 'FFFF
> FFFF FFFF FFFF' (all '1's).
> 
> The link about the above information can be found at this link below.
> Read towards the bottom of the link.
> http://forums.creativecow.net/thread/8/975362
> 
> I really would like to know where to change in the NFS source code so
> that the FSINFO response from the server in which the max file size is
> set to 'FFFF FFFF FFFF FFFF' (all '1's).

I think you're probably barking up the wrong tree, but the max file size
as returned by fsinfo is set in fs/nfsd/nfs3proc.c:nfsd3_proc_fsinfo().

--b.
