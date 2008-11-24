Return-Path: <linux-kernel-owner+w=401wt.eu-S1752892AbYKXMLl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752892AbYKXMLl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2008 07:11:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750892AbYKXMLd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Nov 2008 07:11:33 -0500
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:55296 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751191AbYKXMLc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2008 07:11:32 -0500
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Subject: Re: [ltt-dev] [RFC PATCH] Poll : add poll_wait_set_exclusive (fixing thundering herd problem in LTTng)
Cc: kosaki.motohiro@jp.fujitsu.com, ltt-dev@lists.casi.polymtl.ca,
       Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       William Lee Irwin III <wli@holomorphy.com>
In-Reply-To: <20081124115134.GA17972@Krystal>
References: <20081124203932.26BE.KOSAKI.MOTOHIRO@jp.fujitsu.com> <20081124115134.GA17972@Krystal>
Message-Id: <20081124205512.26C1.KOSAKI.MOTOHIRO@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.42 [ja]
Date: Mon, 24 Nov 2008 21:11:28 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > I fully agreed this feature is needed.
> > Actually, I've made similar patch at one years ago.
> > 
> > http://marc.info/?l=linux-kernel&m=120257050719087&w=2
> > 
> > 
> > but, I have one question.
> > My version have epoll support, but yours donesn't have.
> > Is it intensionally?
> > 
> > this is just dumb question, it doesn't mean any objection.
> 
> Hrm, actually, your patch seems cleaner than mine, but it adds a branch
> in the standard hotpath, which mine does not do (but I am not sure it is
> such an important optimization...). 

Why do you think poll_wait() is hotpath?
I think sysm_poll() isn't hotpath because it often cause task sleeping.


> Is there any reason why your patch
> did not get merged ?

my patch was developed for a part of mem_notify patch series.
but the mem_notify was naked by akpm.
therefore it lost merging motivation ;-)

Ingo, I'll rebase and post my patch for -tip tommorow.
Could you please review it?


> The only reason I did not make a epoll version is simply because LTTng
> currently does not support it. :)

thanks.
I understand your original intension.



