Return-Path: <linux-kernel-owner+w=401wt.eu-S1761504AbXH3AM7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761504AbXH3AM7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Aug 2007 20:12:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754488AbXH3AMu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Aug 2007 20:12:50 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:40045 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753655AbXH3AMt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Aug 2007 20:12:49 -0400
Date: Wed, 29 Aug 2007 17:12:48 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Mingming Cao <cmm@us.ibm.com>
cc: torvalds@linux-foundation.org, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
       Mel Gorman <mel@skynet.ie>, William Lee Irwin III <wli@holomorphy.com>,
       David Chinner <dgc@sgi.com>, Jens Axboe <jens.axboe@oracle.com>,
       Badari Pulavarty <pbadari@gmail.com>,
       Maxim Levitsky <maximlevitsky@gmail.com>,
       Fengguang Wu <fengguang.wu@gmail.com>, swin wang <wangswin@gmail.com>,
       totty.lu@gmail.com, "H. Peter Anvin" <hpa@zytor.com>,
       joern@lazybastard.org, "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: [31/36] Large Blocksize: Core piece
In-Reply-To: <1188432669.3799.35.camel@localhost.localdomain>
Message-ID: <Pine.LNX.4.64.0708291712020.4336@schroedinger.engr.sgi.com>
References: <20070828190551.415127746@sgi.com>  <20070828190735.292638294@sgi.com>
 <1188432669.3799.35.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 29 Aug 2007, Mingming Cao wrote:

> > Known internal limitations:
> > 
> > Ext2            64k
> > XFS             64k
> > Reiserfs        8k
> > Ext3            4k (rumor has it that changing a constant can remove the limit)
> > Ext4            4k
> > 
> 
> There are patches original worked by Takashi Sato to support large block
> size (up to 64k) in ext2/3/4, which addressed the directory issue as
> well. I just forward ported. Will posted it in a separate thread.
> Haven't get a chance to integrated with your patch yet (next step).

Ahh. Great. Keep me posted.

