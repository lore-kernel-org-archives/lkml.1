Return-Path: <linux-kernel-owner+w=401wt.eu-S1765403AbZFQJUR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765403AbZFQJUR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jun 2009 05:20:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755888AbZFQJUE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Jun 2009 05:20:04 -0400
Received: from hera.kernel.org ([140.211.167.34]:40702 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758092AbZFQJUD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jun 2009 05:20:03 -0400
Message-ID: <4A38B52A.5040304@kernel.org>
Date: Wed, 17 Jun 2009 18:19:38 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Boaz Harrosh <bharrosh@panasas.com>
CC: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>, Jens Axboe <jens.axboe@oracle.com>,
       linux-kernel@vger.kernel.org,
       device-mapper development <dm-devel@redhat.com>,
       "Jun'ichi Nomura" <j-nomura@ce.jp.nec.com>
Subject: Re: [PATCH block#for-2.6.31] block: add request clone interface
References: <4A2E1490.7060902@ct.jp.nec.com> <20090609180344.GQ11363@kernel.dk> <4A2F1741.8090100@ct.jp.nec.com> <4A2F66ED.80206@panasas.com>
In-Reply-To: <4A2F66ED.80206@panasas.com>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 17 Jun 2009 09:19:42 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Boaz.

Boaz Harrosh wrote:
> dst->buffer is always NULL in my path so I don't know
> what that is. Tejun?

Sorry about late reply.

It points to the head of the data buffer (bio) if the address is in
addressable range (actually gets bogus value if not) and is used
mostly by PIO-only drivers.  It's set in blk_rq_bio_prep(), gets
updated on merge and partial request completion.

Thanks.

-- 
tejun
