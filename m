Return-Path: <linux-kernel-owner+w=401wt.eu-S1754895AbZCUTQp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754895AbZCUTQp (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Mar 2009 15:16:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752531AbZCUTQe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Mar 2009 15:16:34 -0400
Received: from terminus.zytor.com ([198.137.202.10]:52443 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752167AbZCUTQd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Mar 2009 15:16:33 -0400
Message-ID: <49C53D00.9060008@zytor.com>
Date: Sat, 21 Mar 2009 12:16:16 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Ilya Yanok <yanok@emcraft.com>
CC: "H. Peter Anvin" <h.peter.anvin@intel.com>,
       "Williams, Dan J" <dan.j.williams@intel.com>,
       "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "neilb@suse.de" <neilb@suse.de>,
       "Sosnowski, Maciej" <maciej.sosnowski@intel.com>,
       Yuri Tikhonov <yur@emcraft.com>
Subject: Re: [PATCH 06/13] async_tx: add support for asynchronous GF 	multiplication
References: <20090318191248.20375.40560.stgit@dwillia2-linux.ch.intel.com>	 <20090318192046.20375.89854.stgit@dwillia2-linux.ch.intel.com>	 <49C26D91.10804@intel.com> <e9c3a7c20903191020k4d0169e3oc9749103a711f3e3@mail.gmail.com> <49C41C1E.4060401@zytor.com> <49C4201A.5060905@emcraft.com> <49C425F5.8060309@intel.com> <49C42F99.5010700@emcraft.com> <49C45159.8020503@zytor.com> <49C4BF15.5050502@emcraft.com>
In-Reply-To: <49C4BF15.5050502@emcraft.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ilya Yanok wrote:
>>>     
>> For any n (which would mean any GF field)?  In that case, that is
>> generic scalar-vector multiplication...
>>   
> 
> Ok. I think I got it. Vectors are things that depend on position inside
> buffer and scalars are things that don't, am I right? In that sense we
> don't have any vector-vector multiplication. Both async_gen_syndrome()
> and async_pq() use constant coefficients. So I don't really understand
> the problem here.
> 

Perhaps the interface is just too confusing (in which case it needs to
at least be better documented), but at least the synchronous simulation
code looked like it was doing a vector-vector multiply.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

