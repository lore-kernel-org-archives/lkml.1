Return-Path: <linux-kernel-owner+w=401wt.eu-S1761555AbXE2GqV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761555AbXE2GqV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 May 2007 02:46:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751698AbXE2GqI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 May 2007 02:46:08 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:46718 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751616AbXE2GqG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 May 2007 02:46:06 -0400
Date: Mon, 28 May 2007 23:45:59 -0700
From: Jeremy Higdon <jeremy@sgi.com>
To: Timothy Shimmin <tes@sgi.com>
Cc: David Chinner <dgc@sgi.com>, Neil Brown <neilb@suse.de>,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       dm-devel@redhat.com, linux-raid@vger.kernel.org,
       Jens Axboe <jens.axboe@oracle.com>, Phillip Susi <psusi@cfl.rr.com>,
       Stefan Bader <Stefan.Bader@de.ibm.com>,
       Andreas Dilger <adilger@clusterfs.com>, Tejun Heo <htejun@gmail.com>
Subject: Re: [RFD] BIO_RW_BARRIER - what it means for devices, filesystems, and dm/md.
Message-ID: <20070529064559.GB531679@sgi.com>
References: <18006.38689.818186.221707@notabene.brown> <18010.12472.209452.148229@notabene.brown> <20070528024559.GA85884050@sgi.com> <980E945058C35F7E3117FE88@timothy-shimmins-power-mac-g5.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <980E945058C35F7E3117FE88@timothy-shimmins-power-mac-g5.local>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 28, 2007 at 02:48:45PM +1000, Timothy Shimmin wrote:
> I'm taking it that the FUA write will just guarantee that that
> particular write has made it to disk on i/o completion
> (and no write cache flush is done).

Correct.  It only applies to that one write command.

jeremy
