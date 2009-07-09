Return-Path: <linux-kernel-owner+w=401wt.eu-S1755434AbZGISac@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755434AbZGISac (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jul 2009 14:30:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753854AbZGISaY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Jul 2009 14:30:24 -0400
Received: from moutng.kundenserver.de ([212.227.17.9]:55457 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753148AbZGISaX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jul 2009 14:30:23 -0400
Message-ID: <4A56373C.4050409@vlnb.net>
Date: Thu, 09 Jul 2009 22:30:20 +0400
From: Vladislav Bolkhovitin <vst@vlnb.net>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Jens Axboe <jens.axboe@oracle.com>
CC: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
       scst-devel@lists.sourceforge.net, Tejun Heo <tj@kernel.org>,
       Boaz Harrosh <bharrosh@panasas.com>,
       James Bottomley <James.Bottomley@HansenPartnership.com>,
       FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: [PATCH]: Rename REQ_COPY_USER to more descriptive	REQ_HAS_TAIL_SPACE_FOR_PADDING
References: <4A563259.5000601@vlnb.net> <20090709181713.GQ23611@kernel.dk>
In-Reply-To: <20090709181713.GQ23611@kernel.dk>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
X-Provags-ID: V01U2FsdGVkX19vCI5+CrL1VrrGFadAaosZpLPG9RxP23tC5oL
 cIGGP/CqqofswKPzlLrpaDIGtor8S8HcJCcibgtjsIowNt+1uz
 QnNZugjEys/uz7dT9Vnfg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jens Axboe, on 07/09/2009 10:17 PM wrote:
> On Thu, Jul 09 2009, Vladislav Bolkhovitin wrote:
>> Currently names of REQ_COPY_USER and __REQ_COPY_USER constants are confusing,
>> because they actually mean that the buffer for the corresponding requests
>> has space in the tail for padding in case of DMA padding restrictions.
> 
> No, that's not what it means, the fact that there's padding room is a
> side effect of the map type. So I'd suggest adding a comment above that
> if {} in blk_rq_map_sg(), something that should have been there from the
> beginning.

Can you elaborate a bit more about what REQ_COPY_USER should mean, please?

As far as I can see from the sources, currently it's used to only to 
determine if there is the padding space. Maybe, the original meaning 
doesn't make sense anymore?

Thanks,
Vlad



