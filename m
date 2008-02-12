Return-Path: <linux-kernel-owner+w=401wt.eu-S1752842AbYBLV4z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752842AbYBLV4z (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2008 16:56:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753278AbYBLV4q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Feb 2008 16:56:46 -0500
Received: from mx1.redhat.com ([66.187.233.31]:39625 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752140AbYBLV4p (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2008 16:56:45 -0500
Message-ID: <47B2158F.2080305@sandeen.net>
Date: Tue, 12 Feb 2008 15:54:23 -0600
From: Eric Sandeen <sandeen@sandeen.net>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Linda Walsh <xfs@tlinx.org>
CC: David Chinner <dgc@sgi.com>, Linux-Xfs <linux-xfs@oss.sgi.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: xfs [_fsr] probs in 2.6.24.0
References: <47B0F00D.3060802@tlinx.org> <20080212085802.GA155407@sgi.com> <47B2094D.50406@tlinx.org> <47B20E84.6020707@sandeen.net> <47B21327.3080502@tlinx.org>
In-Reply-To: <47B21327.3080502@tlinx.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linda Walsh wrote:
> 
> Eric Sandeen wrote:
>> Linda Walsh wrote:
>>> David Chinner wrote:
>>>> Filesystem bugs rarely hang systems hard like that - more likely is
>>>> a hardware or driver problem. And neither of the lockdep reports
>>>> below are likely to be responsible for a system wide, no-response
>>>> hang.
>>> ---
>>> 	"Ish", the 32-bitter, has been the only hard-hanger.
>> 4k stacks?
> ----
> 	But but but...almost from the day they were introduced.  And
> these are more recent probs. Has stack usage increased for some reason,
> :-(.  I do have the option to detect stack-overflow turned on as well
> -- guess it doesn't work so well?

Resource requirements grow over time, film at 11? :)

the checker is a random thing, it checks only on interrupts; it won't
always hit.  you could try CONFIG_DEBUG_STACK_USAGE too, each thread
prints max stack used when it exits, to see if you're getting close on
normal usage.

Or just use 8k.

-Eric
