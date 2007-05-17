Return-Path: <linux-kernel-owner+w=401wt.eu-S1758266AbXEQRa1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758266AbXEQRa1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2007 13:30:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756247AbXEQRaR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 May 2007 13:30:17 -0400
Received: from il.qumranet.com ([82.166.9.18]:60524 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754649AbXEQRaP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2007 13:30:15 -0400
Message-ID: <464C9126.3090907@qumranet.com>
Date: Thu, 17 May 2007 20:30:14 +0300
From: Avi Kivity <avi@qumranet.com>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Jeremy Fitzhardinge <jeremy@goop.org>
CC: Andi Kleen <ak@suse.de>, Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.22-rc1-mm1: strange GPF when panicing under kvm
References: <464B9E19.6050902@goop.org> <464C574C.5020201@qumranet.com> <464C8DBA.80506@goop.org>
In-Reply-To: <464C8DBA.80506@goop.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jeremy Fitzhardinge wrote:
> Avi Kivity wrote:
>   
>> (that msr can force trapping of the pause instruction, even though
>> there's no good reason to do it, and kvm wouldn't inject a gp if it
>> did anyway).
>>     
>
> Hm, yeah, its strange; clearly its running "pause" in normal use, so it
> can't be the instuction itself which is causing the problem.  The MSR is
> 7781fffe0401e172 btw.
>   

That means pause isn't set for interception.

I ran a small test program, and it liked pause as well.

Can you send me your vmlinuz?  I wasn't able top reproduce the problem 
with mine.

-- 
error compiling committee.c: too many arguments to function

