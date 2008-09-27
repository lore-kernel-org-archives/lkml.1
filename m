Return-Path: <linux-kernel-owner+w=401wt.eu-S1757227AbYI0RxY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757227AbYI0RxY (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Sep 2008 13:53:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756853AbYI0RvA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 27 Sep 2008 13:51:00 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:36323 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756847AbYI0Ru7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Sep 2008 13:50:59 -0400
Date: Sat, 27 Sep 2008 19:50:46 +0200
From: Ingo Molnar <mingo@elte.hu>
To: =?iso-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>
Cc: Pekka Paalanen <pq@iki.fi>, Steven Rostedt <rostedt@goodmis.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [Patch -tip 1/3] Tracing/ftrace: Relay unhandled entry output
Message-ID: <20080927175046.GG26047@elte.hu>
References: <48DB81BA.2050204@gmail.com> <20080925123802.GA6900@elte.hu> <48DBA683.8000708@gmail.com> <20080925180916.75d3c9ec@daedalus.pq.iki.fi> <c62985530809250833x2468f07an547a82eaa1329d9@mail.gmail.com> <20080925184919.016d8957@daedalus.pq.iki.fi> <c62985530809250856l2c4e827cv2123b6c3c21210d7@mail.gmail.com> <20080925190149.208ee3a4@daedalus.pq.iki.fi> <c62985530809250940s1cdab6dau87bee24b6bc6c089@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <c62985530809250940s1cdab6dau87bee24b6bc6c089@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.1
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.1 required=5.9 tests=BAYES_05 autolearn=no SpamAssassin version=3.2.3
	-1.1 BAYES_05               BODY: Bayesian spam probability is 1 to 5%
	[score: 0.0279]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Frédéric Weisbecker <fweisbec@gmail.com> wrote:

> 2008/9/25 Pekka Paalanen <pq@iki.fi>:
> > Oh cool, sounds like I should try linux-next when I can.
> 
> 
> It is on -tip if you want :)
> 
> So, unless someone is opposed to. I will send a patch which define
> three possible values
> for the print_line callback. I will define these values on trace.h
> Why not:
> 
> #define TRACE_TYPE_PARTIAL_LINE 0
> #define TRACE_TYPE_HANDLED 1
> #define TRACE_TYPE_UNHANDLED 2   => will relay on default functions
> 
> Hmm I'm questionning about the relevance of this kind of patch since 
> the tracing API is in refactoring...

dont worry about that aspect too much, the ring buffer API will be a 
transparent replacement, so try to iterate whatever is there at the 
moment towards perfection :)

	Ingo
