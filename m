Return-Path: <linux-kernel-owner+w=401wt.eu-S1754830AbZA0CAh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754830AbZA0CAh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2009 21:00:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752128AbZA0CA3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Jan 2009 21:00:29 -0500
Received: from hera.kernel.org ([140.211.167.34]:36112 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751959AbZA0CA2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2009 21:00:28 -0500
Message-ID: <497E6A4C.8050605@kernel.org>
Date: Tue, 27 Jan 2009 10:58:36 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Rusty Russell <rusty@rustcorp.com.au>
CC: Takashi Iwai <tiwai@suse.de>, Ingo Molnar <mingo@redhat.com>,
       Kyle McMartin <kyle@infradead.org>, linux-kernel@vger.kernel.org,
       Eric Dumazet <dada1@cosmosbay.com>
Subject: Re: [PATCH] module: kzalloc mod->ref
References: <20090114033533.GL25103@bombadil.infradead.org> <200901151521.47326.rusty@rustcorp.com.au> <200901261751.21817.rusty@rustcorp.com.au> <200901271206.51248.rusty@rustcorp.com.au>
In-Reply-To: <200901271206.51248.rusty@rustcorp.com.au>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Tue, 27 Jan 2009 01:58:32 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rusty Russell wrote:
> On Monday 26 January 2009 17:51:21 Rusty Russell wrote:
>> On Thursday 15 January 2009 15:21:46 Rusty Russell wrote:
>>> In fact, I've decided to go back and add Eric's patch.  Since
>>> alloc_percpu isn't going to be fixed this merge window, we'll do this
>>> now, then simply use alloc_percpu once that is merged.
>> And with the following fixes, it's in linux-next for tomorrow.
> 
> Ingo, can I push this via your tree?  I don't expect any problems, but I
> hate breaking modules and it'd be nice to have indep testing and get this in
> soon; linux-next is off this week.
> 
> (The percpu alloc patchset I promised Tejun also depends trivially on this
> so getting it upstream will forward that handoff).

FWIW, the patch looks good to me and I'll be happy to forward it
through core/percpu.

Thanks.

-- 
tejun
