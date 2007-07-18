Return-Path: <linux-kernel-owner+w=401wt.eu-S932545AbXGRLdd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932545AbXGRLdd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2007 07:33:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757760AbXGRLdU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Jul 2007 07:33:20 -0400
Received: from py-out-1112.google.com ([64.233.166.178]:46501 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752230AbXGRLdR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2007 07:33:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=oIamXdN+hPpb2//etl34EQtwBr+D3s31RCh7ZcKag6o9DFuNcL5DvpDzX165ufQWcD29qCRmlRKKdTmjXxLYCEu8bsUah4x7ONnhyXC4U9TTYN1VVuY/F8QfUVl+qaQEA/MLGYKOZR7w1MVr1S2CfYydC28Iv3U5ZZc75Nairsk=
Message-ID: <469DFA75.6070205@gmail.com>
Date: Wed, 18 Jul 2007 20:33:09 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Icedove 1.5.0.10 (X11/20070307)
MIME-Version: 1.0
To: Jens Axboe <jens.axboe@oracle.com>
CC: Neil Brown <neilb@suse.de>, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org, dm-devel@redhat.com,
       linux-raid@vger.kernel.org, David Chinner <dgc@sgi.com>,
       Phillip Susi <psusi@cfl.rr.com>, Stefan Bader <Stefan.Bader@de.ibm.com>,
       Andreas Dilger <adilger@clusterfs.com>
Subject: Re: [PATCH] block: factor out bio_check_eod()
References: <18006.38689.818186.221707@notabene.brown> <18010.12472.209452.148229@notabene.brown> <20070530093503.GA15559@kernel.dk> <20070718105655.GB22374@htj.dyndns.org> <20070718105946.GC22374@htj.dyndns.org> <20070718110619.GM11657@kernel.dk> <469DF700.4030806@gmail.com> <20070718113103.GO11657@kernel.dk>
In-Reply-To: <20070718113103.GO11657@kernel.dk>
X-Enigmail-Version: 0.94.2.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jens Axboe wrote:
> On Wed, Jul 18 2007, Tejun Heo wrote:
>> Jens Axboe wrote:
>>> On Wed, Jul 18 2007, Tejun Heo wrote:
>>>> End of device check is done twice in __generic_make_request() and it's
>>>> fully inlined each time.  Factor out bio_check_eod().
>>> Tejun, yeah I should seperate the cleanups and put them in the upstream
>>> branch. Will do so and add your signed-off to both of them.
>>>
>> Would they be different from the one I just posted?  No big deal either
>> way.  I'm just basing the zero-length barrier on top of these patches.
>> Oh well, the changes are trivial anyway.
> 
> This one ended up being the same, but in the first one you missed some
> of the cleanups. I ended up splitting the patch some more though, see
> the series:
> 
> http://git.kernel.dk/?p=linux-2.6-block.git;a=shortlog;h=barrier

Alright, will base on 662d5c5e6afb79d05db5563205b809c0de530286.  Thanks.

-- 
tejun
