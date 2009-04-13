Return-Path: <linux-kernel-owner+w=401wt.eu-S1755958AbZDMJiA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755958AbZDMJiA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Apr 2009 05:38:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754490AbZDMJht
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Apr 2009 05:37:49 -0400
Received: from hera.kernel.org ([140.211.167.34]:47691 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754131AbZDMJhs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Apr 2009 05:37:48 -0400
Message-ID: <49E3080F.7080206@kernel.org>
Date: Mon, 13 Apr 2009 18:38:23 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
CC: bharrosh@panasas.com, James.Bottomley@hansenpartnership.com,
       linux-scsi@vger.kernel.org, axboe@kernel.dk,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 14/17] scsi: replace custom rq mapping with blk_rq_map_kern_sgl()
References: <1238593472-30360-1-git-send-email-tj@kernel.org>	<1238593472-30360-15-git-send-email-tj@kernel.org>	<49D39DBC.3000206@panasas.com> <20090413164146J.fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <20090413164146J.fujita.tomonori@lab.ntt.co.jp>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Mon, 13 Apr 2009 09:37:41 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

FUJITA Tomonori wrote:
>> I thought that was agreed and done? What is left to do for that to go
>> in.
> 
> I've converted all the users (sg, st, osst). Nothing is left. So we
> don't need this.

Yeah, pulled it.  Okay, so we can postpone diddling with request
mapping for now.  I'll re-post fixes only from this and the previous
patchset and proceed with other patchsets.

Thanks.

-- 
tejun
