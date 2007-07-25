Return-Path: <linux-kernel-owner+w=401wt.eu-S1763709AbXGYIJb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763709AbXGYIJb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jul 2007 04:09:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751966AbXGYIJR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Jul 2007 04:09:17 -0400
Received: from dsl081-033-126.lax1.dsl.speakeasy.net ([64.81.33.126]:46126
	"EHLO bifrost.lang.hm" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751803AbXGYIJP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jul 2007 04:09:15 -0400
Date: Wed, 25 Jul 2007 01:07:25 -0700 (PDT)
From: david@lang.hm
X-X-Sender: dlang@asgard.lang.hm
To: Rene Herman <rene.herman@gmail.com>
cc: Ray Lee <ray-lk@madrabbit.org>, Nick Piggin <nickpiggin@yahoo.com.au>,
       Jesper Juhl <jesper.juhl@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>, ck list <ck@vds.kolivas.org>,
       Ingo Molnar <mingo@elte.hu>, Paul Jackson <pj@sgi.com>,
       linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: -mm merge plans for 2.6.23
In-Reply-To: <46A7031D.5080300@gmail.com>
Message-ID: <Pine.LNX.4.64.0707250104180.2229@asgard.lang.hm>
References: <20070710013152.ef2cd200.akpm@linux-foundation.org> 
 <200707102015.44004.kernel@kolivas.org>  <9a8748490707231608h453eefffx68b9c391897aba70@mail.gmail.com>
  <46A57068.3070701@yahoo.com.au>  <2c0942db0707232153j3670ef31kae3907dff1a24cb7@mail.gmail.com>
  <46A58B49.3050508@yahoo.com.au> <2c0942db0707240915h56e007e3l9110e24a065f2e73@mail.gmail.com>
 <Pine.LNX.4.64.0707242130470.2229@asgard.lang.hm> <46A7031D.5080300@gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=US-ASCII; FORMAT=flowed
Content-ID: <Pine.LNX.4.64.0707250104182.2229@asgard.lang.hm>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 25 Jul 2007, Rene Herman wrote:

> On 07/25/2007 06:46 AM, david@lang.hm wrote:
>
>>  you could make a synthetic test by writing a memory hog that allocates 3/4
>>  of your ram then pauses waiting for input and then randomly accesses the
>>  memory for a while (say randomly accessing 2x # of pages allocated) and
>>  then pausing again before repeating
>
> Something like this?
>
>>  run two of these, alternating which one is running at any one time. time
>>  how long it takes to do the random accesses.
>>
>>  the difference in this time should be a fair example of how much it would
>>  impact the user.
>
> Notenotenote, not sure what you're going to show with it (times are simply as 
> horrendous as I'd expect) but thought I'd try to inject something other than 
> steaming cups of 4-letter beverages.

when the swap readahead is enabled does it make a significant difference 
in the time to do the random access?

if it does that should show a direct benifit of the patch in a simulation 
of a relativly common workflow (startup a memory hog like openoffice then 
try and go back to your prior work)

David Lang

