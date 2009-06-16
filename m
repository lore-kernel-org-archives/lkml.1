Return-Path: <linux-kernel-owner+w=401wt.eu-S1751767AbZFPIDQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751767AbZFPIDQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jun 2009 04:03:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751211AbZFPIC4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Jun 2009 04:02:56 -0400
Received: from ip67-152-220-66.z220-152-67.customer.algx.net ([67.152.220.66]:14559
	"EHLO daytona.int.panasas.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751022AbZFPICz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jun 2009 04:02:55 -0400
Message-ID: <4A3751A9.8070601@panasas.com>
Date: Tue, 16 Jun 2009 11:02:49 +0300
From: Boaz Harrosh <bharrosh@panasas.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1b3pre) Gecko/20090315 Remi/3.0-0.b2.fc10.remi Thunderbird/3.0b2
MIME-Version: 1.0
To: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
CC: Jeff Moyer <jmoyer@redhat.com>, Jens Axboe <jens.axboe@oracle.com>,
       linux-kernel@vger.kernel.org,
       device-mapper development <dm-devel@redhat.com>,
       "Jun'ichi Nomura" <j-nomura@ce.jp.nec.com>
Subject: Re: [PATCH block#for-2.6.31] block: add request clone interface (v2)
References: <4A3075B2.9040208@ct.jp.nec.com>	<20090611110903.GO11363@kernel.dk>	<x49vdn3lynd.fsf@segfault.boston.devel.redhat.com>	<20090612133014.GK11363@kernel.dk> <x49ski5v7vs.fsf@segfault.boston.devel.redhat.com> <4A35C0A4.20707@ct.jp.nec.com> <4A3614D1.20403@panasas.com> <4A370B3D.4050108@ct.jp.nec.com>
In-Reply-To: <4A370B3D.4050108@ct.jp.nec.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 16 Jun 2009 08:02:51.0962 (UTC) FILETIME=[D8DC51A0:01C9EE58]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/16/2009 06:02 AM, Kiyoshi Ueda wrote:
> Hi Boaz, Jeff, Jens,
>>> Perhaps
>>> blk_rq_{clone,declone} or blk_rq_{clone,declone}_bios
>>>
>>> (Both unclone and declone are found on the net but are not
>>>  found in the free dictionary)
> 
> I had a feeling that blk_rq_{clone,declone} allocates/frees
> the clone request inside the interfaces like bio_clone(), so
> I didn't take such namings.
> And, the clone setup interface may not only make bio clones
> but also do something else (for other request members), so
> I didn't add any 'bio' namings to the interfaces.
> 

I'm convinced blk_rq_prep_clone is good for what it actually does

> Jens, what do you prefer?
> 
> Thanks,
> Kiyoshi Ueda

Thanks
Boaz
