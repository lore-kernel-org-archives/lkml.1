Return-Path: <linux-kernel-owner+w=401wt.eu-S1755305AbZCVRRW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755305AbZCVRRW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Mar 2009 13:17:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752430AbZCVRRM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Mar 2009 13:17:12 -0400
Received: from rv-out-0506.google.com ([209.85.198.225]:57222 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750879AbZCVRRL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Mar 2009 13:17:11 -0400
MIME-Version: 1.0
In-Reply-To: <18885.29855.433194.463455@cargo.ozlabs.ibm.com>
References: <18884.55232.197620.696687@cargo.ozlabs.ibm.com> 
	<20090321055252.eb0673ea.akpm@linux-foundation.org> <18885.29855.433194.463455@cargo.ozlabs.ibm.com>
Date: Sun, 22 Mar 2009 10:16:53 -0700
Message-ID: <2c0942db0903221016y45c21dbeu699f666b8e3431ee@mail.gmail.com>
Subject: Re: [PATCH v2] perfcounters: record time running and time enabled for 
	each counter
From: Ray Lee <ray-lk@madrabbit.org>
To: Paul Mackerras <paulus@samba.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 21, 2009 at 4:13 PM, Paul Mackerras <paulus@samba.org> wrote:
> Andrew Morton writes:
>
>> Perhaps one of the reasons why this code is confusing is the blurring
>> between the "time" at which an event occured and the "time" between the
>> occurrence of two events.  A weakness in English, I guess.  Using the term
>> "interval" in the latter case will help a lot.
>
> Except that we aren't measuring an "interval", we're measuring the
> combined length of a whole series of intervals.  What's a good word
> for that?

As Ingo pointed out, 'runtime' is a decent choice for that.
