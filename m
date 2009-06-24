Return-Path: <linux-kernel-owner+w=401wt.eu-S1760280AbZFXAEf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760280AbZFXAEf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jun 2009 20:04:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760083AbZFXAEV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jun 2009 20:04:21 -0400
Received: from hera.kernel.org ([140.211.167.34]:36852 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760123AbZFXAEU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jun 2009 20:04:20 -0400
Message-ID: <4A416D7B.4060804@kernel.org>
Date: Wed, 24 Jun 2009 09:04:11 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Miklos Szeredi <miklos@szeredi.hu>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/4] FUSE: make request_wait_answer() wait for ->end()
 completion
References: <1245317073-24000-1-git-send-email-tj@kernel.org>	<1245317073-24000-3-git-send-email-tj@kernel.org> <20090623165354.073a61fe.akpm@linux-foundation.org>
In-Reply-To: <20090623165354.073a61fe.akpm@linux-foundation.org>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 24 Jun 2009 00:04:13 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(restoring cc list)

Andrew Morton wrote:
> On Thu, 18 Jun 2009 18:24:31 +0900
> Tejun Heo <tj@kernel.org> wrote:
> 
>> -	/** Request completion callback */
>> +	/** Request completion callback.  This function is called from
>> +	    the kernel context of the FUSE server if the request isn't
>> +	    being aborted.  If the request is being aborted, it's
>> +	    called from the kernel context of the aborting process. */
> 
> The comment pretends to be kerneldoc but isn't.
> 
> Like this:
> 
> 	/*
> 	 * Request completion callback.  This function is called from
> 	 * the kernel context of the FUSE server if the request isn't
> 	 * being aborted.  If the request is being aborted, it's
> 	 * called from the kernel context of the aborting process.
> 	 */
> 
> please.

All the sorrounding comments were formatted in false-kerneldoc format,
so it will look a bit weird that way.  Hmm... I'll add a patch to
change the surrounding comments too.

Thanks.

-- 
tejun
