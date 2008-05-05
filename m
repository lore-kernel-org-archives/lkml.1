Return-Path: <linux-kernel-owner+w=401wt.eu-S1762637AbYEEVlU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762637AbYEEVlU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2008 17:41:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759996AbYEEVkw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 May 2008 17:40:52 -0400
Received: from wr-out-0506.google.com ([64.233.184.234]:57431 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758250AbYEEVkv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2008 17:40:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=PozXF2DLcKHPBon0rl1skXtWm/GjJn/EPjp2dgxdDx2a3I2pdbFiXPIOmqq147RH2PGreCqGptccRqrgaKUNl/n9XNKGFwDju9nCHqQ1Eo/g16puJqWUz51fWbcvt3WWnJid11410LvsL3dvQ/6hNUgkA7u+zAaecqzioVjdzcA=
Message-ID: <82e4877d0805051440o273b6a6dge7f0af310c266fb7@mail.gmail.com>
Date: Mon, 5 May 2008 17:40:49 -0400
From: "Parag Warudkar" <parag.warudkar@gmail.com>
To: "Ingo Molnar" <mingo@elte.hu>
Subject: Re: [PATCH] default to n for GROUP_SCHED and FAIR_GROUP_SCHED
Cc: "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Arjan van de Ven" <arjan@infradead.org>,
       "Sam Ravnborg" <sam@ravnborg.org>, LKML <linux-kernel@vger.kernel.org>,
       "akpm@osdl.org" <akpm@linux-foundation.org>,
       "Peter Zijlstra" <peterz@infradead.org>,
       "Dave Jones" <davej@redhat.com>
In-Reply-To: <20080505210526.GA1702@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <82e4877d0805031742o464dd581wd93173d79705ce0d@mail.gmail.com>
	 <20080504092417.GA3425@elte.hu>
	 <82e4877d0805050814j721ae522k84384df48c9f4336@mail.gmail.com>
	 <20080505171501.GA22332@elte.hu>
	 <20080505182427.GA2025@uranus.ravnborg.org>
	 <20080505184235.GD22332@elte.hu>
	 <20080505125620.219c4bb6@infradead.org>
	 <20080505202729.GA1199@elte.hu>
	 <alpine.LFD.1.10.0805051337530.32269@woody.linux-foundation.org>
	 <20080505210526.GA1702@elte.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 5, 2008 at 5:05 PM, Ingo Molnar <mingo@elte.hu> wrote:
>

>  This is now believed to be fixed in sched-devel.git, via the "single
>  runqueue" and deadline-scheduling patches from Peter that flattens the
>  hierarchy of the group scheduler.
>
>  Another latency source was the skew of sched_clock() running too slow -
>  that way if the clock runs at 10% of its intended speed the scheduler
>  will turn a 40msec intended latency target into a 400 msec latency
>  target!
>
>  This bug too is now believed to be fixed via Peter's new sched_clock
>  code in sched-devel.git.

Ok, but the latency problems are not fixed with sched-devel as of
today. I still get unusable audio if I enable GROUP_SCHED stuff on
sched-devel and run make -j8 .

Parag
