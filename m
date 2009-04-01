Return-Path: <linux-kernel-owner+w=401wt.eu-S1762953AbZDAMDn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762953AbZDAMDn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Apr 2009 08:03:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755959AbZDAMDe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Apr 2009 08:03:34 -0400
Received: from hera.kernel.org ([140.211.167.34]:55604 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754302AbZDAMDd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Apr 2009 08:03:33 -0400
Message-ID: <49D3580B.8040109@kernel.org>
Date: Wed, 01 Apr 2009 21:03:23 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
CC: axboe@kernel.dk, bharrosh@panasas.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 7/8] blk-map: let blk_rq_map_user_iov() support null mapping
References: <1238583884-13517-1-git-send-email-tj@kernel.org>	<1238583884-13517-8-git-send-email-tj@kernel.org> <20090401205232C.fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <20090401205232C.fujita.tomonori@lab.ntt.co.jp>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 01 Apr 2009 12:03:26 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

FUJITA Tomonori wrote:
> On Wed,  1 Apr 2009 20:04:43 +0900
> Tejun Heo <tj@kernel.org> wrote:
> 
>> Impact: API expansion
>>
>> Till now, only blk_rq_map() supported null mapping.  Add null mapping
>> support to blk_rq_map_user_iov() by moving BIO_NULL_MAPPED setting to
>> bio_copy_user_iov().
> 
> Why does blk_rq_map_user_iov() need to support the null mapping?

Because the next patch makes blk_rq_map_user() use it.

-- 
tejun
