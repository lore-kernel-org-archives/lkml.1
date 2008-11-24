Return-Path: <linux-kernel-owner+w=401wt.eu-S1752890AbYKXMRR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752890AbYKXMRR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2008 07:17:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752107AbYKXMRE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Nov 2008 07:17:04 -0500
Received: from tomts25.bellnexxia.net ([209.226.175.188]:35333 "EHLO
	tomts25-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751939AbYKXMRD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2008 07:17:03 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AlMFAAAnKklMROB9/2dsb2JhbACBbYEwzHyCfA
Date: Mon, 24 Nov 2008 07:16:59 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: ltt-dev@lists.casi.polymtl.ca, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org,
       William Lee Irwin III <wli@holomorphy.com>
Subject: Re: [ltt-dev] [RFC PATCH] Poll : add poll_wait_set_exclusive
	(fixing thundering herd problem in LTTng)
Message-ID: <20081124121659.GA18987@Krystal>
References: <20081124203932.26BE.KOSAKI.MOTOHIRO@jp.fujitsu.com> <20081124115134.GA17972@Krystal> <20081124205512.26C1.KOSAKI.MOTOHIRO@jp.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <20081124205512.26C1.KOSAKI.MOTOHIRO@jp.fujitsu.com>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 07:16:35 up 7 days, 12:57,  4 users,  load average: 0.69, 0.67,
	0.64
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* KOSAKI Motohiro (kosaki.motohiro@jp.fujitsu.com) wrote:
> > > I fully agreed this feature is needed.
> > > Actually, I've made similar patch at one years ago.
> > > 
> > > http://marc.info/?l=linux-kernel&m=120257050719087&w=2
> > > 
> > > 
> > > but, I have one question.
> > > My version have epoll support, but yours donesn't have.
> > > Is it intensionally?
> > > 
> > > this is just dumb question, it doesn't mean any objection.
> > 
> > Hrm, actually, your patch seems cleaner than mine, but it adds a branch
> > in the standard hotpath, which mine does not do (but I am not sure it is
> > such an important optimization...). 
> 
> Why do you think poll_wait() is hotpath?
> I think sysm_poll() isn't hotpath because it often cause task sleeping.
> 
> 
> > Is there any reason why your patch
> > did not get merged ?
> 
> my patch was developed for a part of mem_notify patch series.
> but the mem_notify was naked by akpm.
> therefore it lost merging motivation ;-)
> 
> Ingo, I'll rebase and post my patch for -tip tommorow.
> Could you please review it?
> 
> 
> > The only reason I did not make a epoll version is simply because LTTng
> > currently does not support it. :)
> 
> thanks.
> I understand your original intension.
> 

Great, please CC me on this one so I can integrate it to the LTTng tree.

Mathieu


-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
