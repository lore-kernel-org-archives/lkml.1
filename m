Return-Path: <linux-kernel-owner+w=401wt.eu-S1752364AbZL1KRq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752364AbZL1KRq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Dec 2009 05:17:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751788AbZL1KRp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Dec 2009 05:17:45 -0500
Received: from casper.infradead.org ([85.118.1.10]:45790 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750988AbZL1KRo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Dec 2009 05:17:44 -0500
Subject: Re: [PATCH] perf lock: Implement basic sorting function of perf
 lock
From: Peter Zijlstra <peterz@infradead.org>
To: Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Paul Mackerras <paulus@samba.org>,
       Frederic Weisbecker <fweisbec@gmail.com>
In-Reply-To: <1261277805-27023-1-git-send-email-mitake@dcl.info.waseda.ac.jp>
References: <1261277805-27023-1-git-send-email-mitake@dcl.info.waseda.ac.jp>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 28 Dec 2009 11:17:17 +0100
Message-ID: <1261995437.7135.54.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2009-12-20 at 11:56 +0900, Hitoshi Mitake wrote:
> +/* based on kernel/lockdep.c */
> +#define MAX_LOCKDEP_KEYS_BITS  13
> +#define LOCKHASH_BITS          (MAX_LOCKDEP_KEYS_BITS - 1)
> +#define LOCKHASH_SIZE          (1UL << LOCKHASH_BITS)

Since you're hashing something fundamentally different than lockdep does
I don't think it makes sense to carry either the name or the size along.

