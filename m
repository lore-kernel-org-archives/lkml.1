Return-Path: <linux-kernel-owner+w=401wt.eu-S1754900AbZFBAHJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754900AbZFBAHJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jun 2009 20:07:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754283AbZFBAG7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Jun 2009 20:06:59 -0400
Received: from mx2.redhat.com ([66.187.237.31]:55641 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754207AbZFBAG6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jun 2009 20:06:58 -0400
Message-ID: <4A246D0B.40204@redhat.com>
Date: Mon, 01 Jun 2009 20:06:35 -0400
From: Rik van Riel <riel@redhat.com>
Organization: Red Hat, Inc
User-Agent: Thunderbird 2.0.0.17 (X11/20080915)
MIME-Version: 1.0
To: John Stultz <johnstul@us.ibm.com>
CC: Ingo Molnar <mingo@elte.hu>, mingo@redhat.com, hpa@zytor.com,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       tglx@linutronix.de, linux-tip-commits@vger.kernel.org,
       Miroslav Lichvar <mlichvar@redhat.com>
Subject: Re: [tip:timers/ntp] ntp: adjust SHIFT_PLL to improve NTP convergence
References: <200905051956.n45JuVo9025575@imap1.linux-foundation.org>	 <tip-22cfbbfd9f67b67fe073010f51cb71d3632387d5@git.kernel.org>	 <1243542817.29511.523.camel@jstultz-laptop>  <20090601232223.GH749@elte.hu> <1243900716.11263.42.camel@jstultz-laptop>
In-Reply-To: <1243900716.11263.42.camel@jstultz-laptop>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

John Stultz wrote:
> On Tue, 2009-06-02 at 01:22 +0200, Ingo Molnar wrote:

>> I might be missing something here - but Linux converging faster 
>> seems like a genuinely good thing. What non-Linux problem could 
>> there be? Linux's convergence is really Linux's private issue. 
> 
> Yea. It does seem that way. Miroslav can likely expand on the issue to
> help clarify, but as I understand it, the example is if you have a
> number of systems that are peers in an NTP network. All of them are
> using the same userland NTP daemon. However, if the rate of change that
> corrections are applied is different in half of them, you will have
> problems getting all the systems to converge together. 

Would this not be true already, because the convergence
of Linux system suddenly became a lot slower in 2.6.19?

Damned if we do, damned if we don't - except the new
behaviour introduced by your patches is nicer.

-- 
All rights reversed.
