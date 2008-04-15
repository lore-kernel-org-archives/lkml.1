Return-Path: <linux-kernel-owner+w=401wt.eu-S1765250AbYDOUg1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765250AbYDOUg1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2008 16:36:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756645AbYDOUgT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Apr 2008 16:36:19 -0400
Received: from courier.cs.helsinki.fi ([128.214.9.1]:53845 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756481AbYDOUgS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2008 16:36:18 -0400
Message-ID: <4805115D.5030703@cs.helsinki.fi>
Date: Tue, 15 Apr 2008 23:34:37 +0300
From: Pekka Enberg <penberg@cs.helsinki.fi>
User-Agent: Thunderbird 2.0.0.12 (Macintosh/20080213)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Christoph Lameter <clameter@sgi.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, Mel Gorman <mel@csn.ul.ie>,
       Nick Piggin <npiggin@suse.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, Yinghai.Lu@sun.com, apw@shadowen.org,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Subject: Re: [bug] SLUB + mm/slab.c boot crash in -rc9
References: <84144f020804110205u3d073e76lbcdd36ec293a169b@mail.gmail.com> <84144f020804110208m41414c0h2ed71b85efbb426c@mail.gmail.com> <84144f020804110211w4ae41414od24cf2de72453e13@mail.gmail.com> <20080415062534.GA9172@elte.hu> <alpine.LFD.1.00.0804150838161.2879@woody.linux-foundation.org> <20080415161532.GA15088@elte.hu> <alpine.LFD.1.00.0804151010500.2879@woody.linux-foundation.org> <Pine.LNX.4.64.0804151232080.1785@schroedinger.engr.sgi.com> <20080415195430.GA23015@elte.hu> <Pine.LNX.4.64.0804151255390.1785@schroedinger.engr.sgi.com> <20080415201734.GA25628@elte.hu>
In-Reply-To: <20080415201734.GA25628@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> my current guess would have been some bootmem regression/interaction 
> that messes up the buddy bitmaps - but i just reverted to the v2.6.24 
> version of bootmem.c and that crashes too ...

I know this is bit of hand-waving but have you noticed how all the 
interesting sparsemem changes that one would expect to have caused the 
breakage happened _before_ v2.6.24? So sorry for asking this again but 
are we 110% sure the problem does not trigger with any of the 
v2.6.24-rcN kernels?

			Pekka
