Return-Path: <linux-kernel-owner+w=401wt.eu-S1761427AbXGKJEz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761427AbXGKJEz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2007 05:04:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757704AbXGKJEp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jul 2007 05:04:45 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:48474 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757463AbXGKJEo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2007 05:04:44 -0400
Date: Wed, 11 Jul 2007 10:04:41 +0100
From: Christoph Hellwig <hch@infradead.org>
To: Timothy Shimmin <tes@sgi.com>
Cc: "Amit K. Arora" <aarora@linux.vnet.ibm.com>,
       Christoph Hellwig <hch@infradead.org>, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org,
       adilger@clusterfs.com, David Chinner <dgc@sgi.com>, suparna@in.ibm.com,
       cmm@us.ibm.com, xfs@oss.sgi.com
Subject: Re: [PATCH 4/7][TAKE5] support new modes in fallocate
Message-ID: <20070711090441.GB18301@infradead.org>
Mail-Followup-To: Christoph Hellwig <hch@infradead.org>,
	Timothy Shimmin <tes@sgi.com>,
	"Amit K. Arora" <aarora@linux.vnet.ibm.com>,
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-ext4@vger.kernel.org, adilger@clusterfs.com,
	David Chinner <dgc@sgi.com>, suparna@in.ibm.com, cmm@us.ibm.com,
	xfs@oss.sgi.com
References: <20070625134500.GE1951@amitarora.in.ibm.com> <20070625150320.GA8686@amitarora.in.ibm.com> <20070625214626.GJ5181@schatzie.adilger.int> <20070626103247.GA19870@amitarora.in.ibm.com> <20070630102111.GB23568@infradead.org> <20070630165246.GA5159@schatzie.adilger.int> <20070703100848.GA14936@amitarora.in.ibm.com> <20070703103107.GA29763@infradead.org> <20070703114650.GB14936@amitarora.in.ibm.com> <468B31FD.2020703@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <468B31FD.2020703@sgi.com>
User-Agent: Mutt/1.4.2.3i
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 04, 2007 at 03:37:01PM +1000, Timothy Shimmin wrote:
> We use this capability in XFS at the moment.
> I think this is mainly for DMF (HSM) but is done via the xfs handle 
> interface
> (xfs_open_by_handle) AFAICT.
> 

You're not :)  You're using an O_INVIBLE equivalent (as described below),
which would be a useful thing to have at the VFS level, but adding hacks
to some system calls only wouldn't help any HSM system.  It's just useless
API clutter.

