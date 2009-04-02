Return-Path: <linux-kernel-owner+w=401wt.eu-S933626AbZDBBif@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933626AbZDBBif (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Apr 2009 21:38:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757021AbZDBBiS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Apr 2009 21:38:18 -0400
Received: from hera.kernel.org ([140.211.167.34]:45158 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756310AbZDBBiQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Apr 2009 21:38:16 -0400
Message-ID: <49D41729.4030407@kernel.org>
Date: Thu, 02 Apr 2009 10:38:49 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Boaz Harrosh <bharrosh@panasas.com>
CC: axboe@kernel.dk, linux-kernel@vger.kernel.org,
       fujita.tomonori@lab.ntt.co.jp
Subject: Re: [PATCH 08/17] bio: reimplement bio_copy_user_iov()
References: <1238593472-30360-1-git-send-email-tj@kernel.org> <1238593472-30360-9-git-send-email-tj@kernel.org> <49D38D4B.7020701@panasas.com>
In-Reply-To: <49D38D4B.7020701@panasas.com>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Thu, 02 Apr 2009 01:38:09 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Boaz.

Boaz Harrosh wrote:
> Please consider that this code-path is used by me, in exofs and
> pNFS-objcets in a very very hot path, where memory pressure is a
> common scenario.

One quick question.  Don't the above paths map kernel pages to a
request?

Thanks.

-- 
tejun
