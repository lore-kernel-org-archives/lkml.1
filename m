Return-Path: <linux-kernel-owner+w=401wt.eu-S1762281AbZDQXY3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762281AbZDQXY3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Apr 2009 19:24:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755761AbZDQXYV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Apr 2009 19:24:21 -0400
Received: from zcars04e.nortel.com ([47.129.242.56]:43766 "EHLO
	zcars04e.nortel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755455AbZDQXYU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Apr 2009 19:24:20 -0400
Message-ID: <49E90F9D.5010308@nortel.com>
Date: Fri, 17 Apr 2009 17:24:13 -0600
From: "Chris Friesen" <cfriesen@nortel.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090302)
MIME-Version: 1.0
To: Christoph Lameter <cl@linux.com>
CC: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org
Subject: Re: Scheduler regression: Too frequent timer interrupts(?)
References: <alpine.DEB.1.10.0904161539130.23632@qirst.com>  <1239951613.23397.4107.camel@laptop>  <alpine.DEB.1.10.0904170941020.11877@qirst.com>  <1239977776.23397.4590.camel@laptop>  <alpine.DEB.1.10.0904171021360.20239@qirst.com>  <1239979901.23397.4638.camel@laptop>  <alpine.DEB.1.10.0904171100510.21575@qirst.com>  <20090417153520.GA29968@elte.hu>  <alpine.DEB.1.10.0904171142050.13734@qirst.com>  <1239985426.23397.4757.camel@laptop> <20090417164918.GK8253@elte.hu>  <alpine.DEB.1.10.0904171335490.28603@qirst.com> <1239991892.23397.4905.camel@laptop> <alpine.DEB.1.10.0904171410540.28536@qirst.com>
In-Reply-To: <alpine.DEB.1.10.0904171410540.28536@qirst.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 17 Apr 2009 23:24:16.0298 (UTC) FILETIME=[A01B88A0:01C9BFB3]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Christoph Lameter wrote:

> The latencytest code simulates a busy processor (no system calls, all
> memory is prefaulted). For some reasons Linux is increasingly taking time
> away from such processes (that intentionally run uncontended on a
> dedicated processor). This causes regressions so that current upstream is
> not usable for these applications.
> 
> It would be best for these applications if the processor would be left
> undisturbed. There is likely not much that the OS needs to do on a busy
> processor if there are no competing threads and if there is no I/O taking
> place.

Peter/Ingo, could ftrace be used to determine where time is being spent 
in the kernel with suitable accuracy?   (This may be a dumb question, I 
haven't played with ftrace much.)

Given that we're talking about tens of usecs of duration, statistical 
sampling may not work all that well.

Chris
