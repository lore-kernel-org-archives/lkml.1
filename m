Return-Path: <linux-kernel-owner+w=401wt.eu-S1755530AbZGNQfs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755530AbZGNQfs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jul 2009 12:35:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755515AbZGNQfs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Jul 2009 12:35:48 -0400
Received: from moutng.kundenserver.de ([212.227.17.10]:52617 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754906AbZGNQfr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jul 2009 12:35:47 -0400
Message-ID: <4A5CB3A3.6000407@vlnb.net>
Date: Tue, 14 Jul 2009 20:34:43 +0400
From: Vladislav Bolkhovitin <vst@vlnb.net>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Jens Axboe <jens.axboe@oracle.com>
CC: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
       scst-devel@lists.sourceforge.net, Tejun Heo <tj@kernel.org>,
       Boaz Harrosh <bharrosh@panasas.com>,
       James Bottomley <James.Bottomley@HansenPartnership.com>,
       FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: [PATCH]: Rename REQ_COPY_USER to more descriptive REQ_HAS_TAIL_SPACE_FOR_PADDING
References: <4A563259.5000601@vlnb.net> <20090709181713.GQ23611@kernel.dk> <4A56373C.4050409@vlnb.net>
In-Reply-To: <4A56373C.4050409@vlnb.net>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
X-Provags-ID: V01U2FsdGVkX1/ObjGN1UPknJ3TrFQf26v5UrOVBxKpo930JUG
 SWY8ZDgWKUPnA5HmdJqHe8OFQPdCgngSBdPVY3rzLVqWiaAq1q
 elNXLLOWkmSKZ+dp1q5dg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Vladislav Bolkhovitin, on 07/09/2009 10:30 PM wrote:
> Jens Axboe, on 07/09/2009 10:17 PM wrote:
>> On Thu, Jul 09 2009, Vladislav Bolkhovitin wrote:
>>> Currently names of REQ_COPY_USER and __REQ_COPY_USER constants are confusing,
>>> because they actually mean that the buffer for the corresponding requests
>>> has space in the tail for padding in case of DMA padding restrictions.
>> No, that's not what it means, the fact that there's padding room is a
>> side effect of the map type. So I'd suggest adding a comment above that
>> if {} in blk_rq_map_sg(), something that should have been there from the
>> beginning.
> 
> Can you elaborate a bit more about what REQ_COPY_USER should mean, please?
> 
> As far as I can see from the sources, currently it's used to only to 
> determine if there is the padding space. Maybe, the original meaning 
> doesn't make sense anymore?

Jens,

Sorry for bothering you, but with use of the kernel-generated buffers, 
like in the patch I sent in 
http://groups.google.com/group/linux.kernel/browse_thread/thread/b5127eeadbef934e/5da7ec7b424d2f36?lnk=raot 
name REQ_COPY_USER becomes quite misleading.

For instance, for blk_rq_map_kern_sg() usage of REQ_COPY_USER the 
buffers neither copied, nor from user. Plus, as I wrote above, in 2.6.30 
REQ_COPY_USER used only to determine if there is the padding space in 
the end. Hence, I suggested the rename.

Thanks,
Vlad
