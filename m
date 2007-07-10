Return-Path: <linux-kernel-owner+w=401wt.eu-S1763623AbXGJLge@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763623AbXGJLge (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jul 2007 07:36:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755204AbXGJLg1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Jul 2007 07:36:27 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:37641 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751597AbXGJLg1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jul 2007 07:36:27 -0400
Date: Tue, 10 Jul 2007 12:36:26 +0100
From: Christoph Hellwig <hch@infradead.org>
To: Steven Whitehouse <swhiteho@redhat.com>
Cc: linux-kernel@vger.kernel.org, cluster-devel@redhat.com,
       Wendy Cheng <wcheng@redhat.com>
Subject: Re: [PATCH] [GFS2] Remove i_mode passing from NFS File Handle
Message-ID: <20070710113626.GA1191@infradead.org>
Mail-Followup-To: Christoph Hellwig <hch@infradead.org>,
	Steven Whitehouse <swhiteho@redhat.com>,
	linux-kernel@vger.kernel.org, cluster-devel@redhat.com,
	Wendy Cheng <wcheng@redhat.com>
References: <11839970832750-git-send-email-swhiteho@redhat.com> <11839970852076-git-send-email-swhiteho@redhat.com> <11839970871671-git-send-email-swhiteho@redhat.com> <1183997089710-git-send-email-swhiteho@redhat.com> <11839970914023-git-send-email-swhiteho@redhat.com> <11839970921764-git-send-email-swhiteho@redhat.com> <11839970941232-git-send-email-swhiteho@redhat.com> <11839970963525-git-send-email-swhiteho@redhat.com> <20070710090639.GA28029@infradead.org> <1184061715.8765.194.camel@quoit>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1184061715.8765.194.camel@quoit>
User-Agent: Mutt/1.4.2.3i
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 10, 2007 at 11:01:55AM +0100, Steven Whitehouse wrote:
> > Because gfs2_decode_fh only accepts file handles with GFS2_LARGE_FH_SIZE
> > or GFS2_LARGE_FH_SIZE you don't accept filehandles sent out by and older
> > gfs version anymore.  Stale filehandles because of a new kernel version
> > are a big no-no, so please add back code to handle the old filehandles
> > on the decode side.
> > 
> 
> This should fix that problem I think since its only relating to end of
> the fh we can just ignore that field in order to accept the older
> format,

Yes, I guess this should do it.
