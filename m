Return-Path: <linux-kernel-owner+w=401wt.eu-S1755115AbZDWA4j@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755115AbZDWA4j (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Apr 2009 20:56:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751520AbZDWA43
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Apr 2009 20:56:29 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:63542 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751240AbZDWA42 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Apr 2009 20:56:28 -0400
Message-ID: <49EFBCE1.5030408@cn.fujitsu.com>
Date: Thu, 23 Apr 2009 08:57:05 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
CC: Ingo Molnar <mingo@elte.hu>, mingo@redhat.com, hpa@zytor.com,
       linux-kernel@vger.kernel.org, fweisbec@gmail.com, tzanussi@gmail.com,
       tglx@linutronix.de, linux-tip-commits@vger.kernel.org
Subject: Re: [tip:tracing/core] tracing/events: make struct trace_entry->type
 to be int type
References: <49EEDB0E.5070207@cn.fujitsu.com> <tip-7a4f453b6d7379a7c380825949977c5a838aa012@git.kernel.org> <alpine.DEB.2.00.0904220924000.24310@gandalf.stny.rr.com> <20090422135221.GB5249@elte.hu> <alpine.DEB.2.00.0904221006440.24310@gandalf.stny.rr.com>
In-Reply-To: <alpine.DEB.2.00.0904221006440.24310@gandalf.stny.rr.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Steven Rostedt wrote:
> On Wed, 22 Apr 2009, Ingo Molnar wrote:
> 
>> * Steven Rostedt <rostedt@goodmis.org> wrote:
>>
>>> Ingo,
>>>
>>> We need to make type 2 bytes not 4.
>> yeah, saw that - it's OK with 2 bytes too.
>>
>>> I sent out a patch to do this change last month
>>>
>>>  http://patchwork.kernel.org/patch/14573/
>> Mind resending it in your next batch of patches?
> 
> OK,
> 
> Will do ;-)
> 

Ah, I didn't notice that patch, and I thought ushort may be too
small for modular TRACE_EVENT.

