Return-Path: <linux-kernel-owner+w=401wt.eu-S1761776AbYA2Bf2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761776AbYA2Bf2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2008 20:35:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752695AbYA2BfU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jan 2008 20:35:20 -0500
Received: from gateway-1237.mvista.com ([63.81.120.158]:2121 "EHLO
	gateway-1237.mvista.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752330AbYA2BfT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2008 20:35:19 -0500
Subject: Re: [CPUISOL] CPU isolation extensions
From: Daniel Walker <dwalker@mvista.com>
To: Max Krasnyanskiy <maxk@qualcomm.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>, Steven Rostedt <srostedt@redhat.com>,
       Gregory Haskins <ghaskins@novell.com>, Paul Jackson <pj@sgi.com>
In-Reply-To: <479E6F71.4040906@qualcomm.com>
References: <1201493382-29804-1-git-send-email-maxk@qualcomm.com>
	 <1201511305.6149.30.camel@lappy>  <479E1FD4.5040606@qualcomm.com>
	 <1201563706.2826.34.camel@imap.mvista.com>  <479E6F71.4040906@qualcomm.com>
Content-Type: text/plain
Date: Mon, 28 Jan 2008 17:33:32 -0800
Message-Id: <1201570413.2826.73.camel@imap.mvista.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-1.fc8) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Mon, 2008-01-28 at 16:12 -0800, Max Krasnyanskiy wrote:

> Not accurate enough and way too much overhead for what I need. I know at this point it probably 
> sounds like I'm talking BS :). I wish I've released the engine and examples by now. Anyway let 
> me just say that SW MAC has crazy tight deadlines with lots of small tasks. Using nanosleep() & 
> gettimeofday() is simply not practical. So it's all TSC based with clever time sync logic between
> HW and SW.

I don't know if it's BS or not, you clearly fixed your own problem which
is good .. Although when you say "RT patches cannot achieve what I
needed. Even RTAI/Xenomai can't do that." , and HRT is "Not accurate
enough and way too much overhead" .. Given the hardware your using,
that's all difficult to believe.. You also said this code has been
running on production systems for two year, which means it's at least
two years old .. There's been some good sized leaps in real time linux
in the past two years ..

Daniel

