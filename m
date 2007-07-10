Return-Path: <linux-kernel-owner+w=401wt.eu-S1763662AbXGJL4U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763662AbXGJL4U (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jul 2007 07:56:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756425AbXGJL4N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Jul 2007 07:56:13 -0400
Received: from mx1.redhat.com ([66.187.233.31]:34814 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751219AbXGJL4M (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jul 2007 07:56:12 -0400
Subject: Re: [PATCH] [GFS2] Remove i_mode passing from NFS File Handle
From: Steven Whitehouse <swhiteho@redhat.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-kernel@vger.kernel.org, cluster-devel@redhat.com,
       Wendy Cheng <wcheng@redhat.com>
In-Reply-To: <20070710113626.GA1191@infradead.org>
References: <11839970832750-git-send-email-swhiteho@redhat.com>
	 <11839970852076-git-send-email-swhiteho@redhat.com>
	 <11839970871671-git-send-email-swhiteho@redhat.com>
	 <1183997089710-git-send-email-swhiteho@redhat.com>
	 <11839970914023-git-send-email-swhiteho@redhat.com>
	 <11839970921764-git-send-email-swhiteho@redhat.com>
	 <11839970941232-git-send-email-swhiteho@redhat.com>
	 <11839970963525-git-send-email-swhiteho@redhat.com>
	 <20070710090639.GA28029@infradead.org> <1184061715.8765.194.camel@quoit>
	 <20070710113626.GA1191@infradead.org>
Content-Type: text/plain
Organization: Red Hat (UK) Ltd (Registered in England and Wales, No.
	3798903) Registered office: Red Hat UK Ltd, Amberley Place, 107-111 Peascod
	Street, Windsor, Berkshire, SL4 ITE
Date: Tue, 10 Jul 2007 12:47:52 +0100
Message-Id: <1184068072.8765.212.camel@quoit>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 (2.8.3-2.fc6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Tue, 2007-07-10 at 12:36 +0100, Christoph Hellwig wrote:
> On Tue, Jul 10, 2007 at 11:01:55AM +0100, Steven Whitehouse wrote:
> > > Because gfs2_decode_fh only accepts file handles with GFS2_LARGE_FH_SIZE
> > > or GFS2_LARGE_FH_SIZE you don't accept filehandles sent out by and older
> > > gfs version anymore.  Stale filehandles because of a new kernel version
> > > are a big no-no, so please add back code to handle the old filehandles
> > > on the decode side.
> > > 
> > 
> > This should fix that problem I think since its only relating to end of
> > the fh we can just ignore that field in order to accept the older
> > format,
> 
> Yes, I guess this should do it.

I've just added it, with a signed-off-by: into the -nmw git tree, so I
think the pull request can now continue to stand,

Steve.


