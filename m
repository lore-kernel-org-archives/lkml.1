Return-Path: <linux-kernel-owner+w=401wt.eu-S937723AbYCSVer@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937723AbYCSVer (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2008 17:34:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763324AbYCSUG3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Mar 2008 16:06:29 -0400
Received: from gw.goop.org ([64.81.55.164]:51281 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763349AbYCSUG2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2008 16:06:28 -0400
Message-ID: <47E17171.9090108@goop.org>
Date: Wed, 19 Mar 2008 13:02:57 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: LKML <linux-kernel@vger.kernel.org>, Ian Campbell <ijc@hellion.org.uk>
Subject: Re: [PATCH 00 of 31] x86: unification and xen updates
References: <patchbomb.1205797011@localhost> <20080319190536.GA11432@elte.hu> <20080319194648.GA20088@elte.hu>
In-Reply-To: <20080319194648.GA20088@elte.hu>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * Ingo Molnar <mingo@elte.hu> wrote:
>
>   
>> thanks Jeremy, i've queued them all up and the current x86/latest 
>> branch should have them. They looked robust so far in my testing.
>>     
>
> found a build bug on 32-bit & PAE - pud_populate() assumed too much 
> about types:
>
> In file included from arch/x86/mm/pgtable.c:3:
> include/asm/pgalloc.h: In function 'pud_populate':
> include/asm/pgalloc.h:93: error: dereferencing pointer to incomplete type
>
> i've uninlined it and has trickled that through your series.
>   

I build 32-bit PAE all the time.  I guess the difference is your build 
is !PARAVIRT?

    J
> 	Ingo
>   

