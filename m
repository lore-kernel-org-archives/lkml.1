Return-Path: <linux-kernel-owner+w=401wt.eu-S1754650AbZCWFHx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754650AbZCWFHx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Mar 2009 01:07:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753196AbZCWFHo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Mar 2009 01:07:44 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:39726 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750899AbZCWFHn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Mar 2009 01:07:43 -0400
Message-ID: <49C7190D.7080100@jp.fujitsu.com>
Date: Mon, 23 Mar 2009 14:07:25 +0900
From: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
User-Agent: Thunderbird 2.0.0.21 (Windows/20090302)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: linux-kernel@vger.kernel.org, stable@kernel.org,
       Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH] posixtimers: Fix posix clock monotonicity v2
References: <49BF3F73.5090007@jp.fujitsu.com> <49C0CFC2.7080604@jp.fujitsu.com> <20090318113430.GD32233@elte.hu>
In-Reply-To: <20090318113430.GD32233@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com> wrote:
> 
>> Impact: Regression fix (against clock_gettime() backwarding bug)
> 
> Looks good, thanks! Would you mind to post a version against -tip?
> 
>   http://people.redhat.com/mingo/tip.git/README
> 
> Which already has a __task_delta_exec() (different version).

Sorry, I was AFK last few days.

Well, I confirmed that the current version (v2) is good for Linus's
tree and 28-stable tree, but it troubles on -tip.
So I made patches for -tip.  It will follow to this post.

[PATCH 1/2] x86: Rename __task_delta_exec() to task_delta_exec_locked()
[PATCH 2/2] posixtimers: Fix posix clock monotonicity v2

The [2/2] is essentially no different from previous version, but
just have solved a fuzz against -tip.


Thanks,
H.Seto

