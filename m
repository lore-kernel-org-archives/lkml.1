Return-Path: <linux-kernel-owner+w=401wt.eu-S1753299Ab0AHICo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753299Ab0AHICo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jan 2010 03:02:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753266Ab0AHICk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Jan 2010 03:02:40 -0500
Received: from ns.dcl.info.waseda.ac.jp ([133.9.216.194]:62425 "EHLO
	ns.dcl.info.waseda.ac.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753171Ab0AHICj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jan 2010 03:02:39 -0500
Message-ID: <4B46E69D.9050800@dcl.info.waseda.ac.jp>
Date: Fri, 08 Jan 2010 17:02:37 +0900
From: Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091211 Shredder/3.0
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Paul Mackerras <paulus@samba.org>,
       Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: [PATCH] perf lock: Implement basic sorting function of perf lock
References: <1261277805-27023-1-git-send-email-mitake@dcl.info.waseda.ac.jp> <1261995437.7135.54.camel@laptop>
In-Reply-To: <1261995437.7135.54.camel@laptop>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2009年12月28日 19:17, Peter Zijlstra wrote:
> On Sun, 2009-12-20 at 11:56 +0900, Hitoshi Mitake wrote:
>> +/* based on kernel/lockdep.c */
>> +#define MAX_LOCKDEP_KEYS_BITS  13
>> +#define LOCKHASH_BITS          (MAX_LOCKDEP_KEYS_BITS - 1)
>> +#define LOCKHASH_SIZE          (1UL<<  LOCKHASH_BITS)
>
> Since you're hashing something fundamentally different than lockdep does
> I don't think it makes sense to carry either the name or the size along.
>
>

Do you mean that MAX_LOCKDEP_KEYS_BITS is needless?
# Sorry, I'm not good at English...

