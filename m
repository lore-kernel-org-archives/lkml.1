Return-Path: <linux-kernel-owner+w=401wt.eu-S1758089AbYASWSa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758089AbYASWSa (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Jan 2008 17:18:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751222AbYASWSX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Jan 2008 17:18:23 -0500
Received: from relay1.sgi.com ([192.48.171.29]:50958 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751043AbYASWSW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Jan 2008 17:18:22 -0500
Message-ID: <4792772C.6040201@sgi.com>
Date: Sat, 19 Jan 2008 14:18:20 -0800
From: Mike Travis <travis@sgi.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Andi Kleen <andi@firstfloor.org>, tglx@linutronix.de,
       linux-kernel@vger.kernel.org, dada1@cosmosbay.com, clameter@sgi.com
Subject: Re: " Change size of node ids from u8 to u16 fixup" causes early
 panic in __build_all_zonelists
References: <20080119062912.GA15850@basil.nowhere.org> <20080119081941.GC12995@elte.hu>
In-Reply-To: <20080119081941.GC12995@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * Andi Kleen <andi@firstfloor.org> wrote:
> 
>> One of my test systems didn't boot with latest git-x86. I bisected it 
>> down to f1321f875910172bcc3e1f302fe145a9e4d3bdf7
>>
>> With later patches the fault seemed to happen even earlier before 
>> other initialization messages.
>>
>> Config is available at http://halobates.de/config
> 
> i've reverted that patch for now, but we need to figure this crash out - 
> the patch looks a trivial extension so it's probably some bad assumption 
> elsewhere, which we want to fix.
> 
> 	Ingo

I'm testing the new version of the patch using:


git://git.kernel.org/pub/scm/linux/kernel/git/x86/linux-2.6-x86.git mm


The straight mm version doesn't like your .config file.
