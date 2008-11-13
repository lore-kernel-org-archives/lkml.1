Return-Path: <linux-kernel-owner+w=401wt.eu-S1755273AbYKMT6Q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755273AbYKMT6Q (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2008 14:58:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752256AbYKMT55
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Nov 2008 14:57:57 -0500
Received: from one.firstfloor.org ([213.235.205.2]:58544 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751982AbYKMT5z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2008 14:57:55 -0500
To: Saikiran Madugula <hummerbliss@gmail.com>
Cc: Petr Tesarik <ptesarik@suse.cz>, netdev <netdev@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] remove an unnecessary field in struct tcp_skb_cb
From: Andi Kleen <andi@firstfloor.org>
References: <1226571707.18006.23.camel@nathan.suse.cz>
	<491C6DA6.8030200@gmail.com>
Date: Thu, 13 Nov 2008 20:57:53 +0100
In-Reply-To: <491C6DA6.8030200@gmail.com> (Saikiran Madugula's message of "Thu, 13 Nov 2008 18:10:46 +0000")
Message-ID: <87fxlvcsam.fsf@basil.nowhere.org>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/21.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Saikiran Madugula <hummerbliss@gmail.com> writes:

> Petr Tesarik wrote:
>> The urg_ptr field is not used anywhere and is merely confusing.
>> 
> grep -r "urg_ptr" on my linux tree says otherwise.

I think you're confusing it with tcphdr's field of the same name.
Petr's patch is correct as far as I can see.

-Andi
-- 
ak@linux.intel.com
