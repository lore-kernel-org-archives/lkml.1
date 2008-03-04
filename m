Return-Path: <linux-kernel-owner+w=401wt.eu-S1765484AbYCDSN7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765484AbYCDSN7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2008 13:13:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758094AbYCDSNg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Mar 2008 13:13:36 -0500
Received: from terminus.zytor.com ([198.137.202.10]:37367 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756234AbYCDSNe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2008 13:13:34 -0500
Message-ID: <47CD9060.9000708@zytor.com>
Date: Tue, 04 Mar 2008 10:09:36 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: Harvey Harrison <harvey.harrison@gmail.com>
CC: Ingo Molnar <mingo@elte.hu>, Sam Ravnborg <sam@ravnborg.org>,
       Adrian Bunk <bunk@kernel.org>, Alexey Starikovskiy <aystarik@gmail.com>,
       lenb@kernel.org, astarikovskiy@suse.de, linux-acpi@vger.kernel.org,
       linux-kernel@vger.kernel.org, Arjan van de Ven <arjan@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [patch] x86: phase out forced inlining
References: <20080301183550.GC25835@cs181133002.pp.htv.fi>	 <20080303085720.GD15943@elte.hu>	 <20080303091314.GC4457@cs181133002.pp.htv.fi>	 <20080303091714.GA18250@elte.hu>	 <20080303093103.GA23651@uranus.ravnborg.org>	 <20080303103933.GC21190@elte.hu>	 <20080303113451.GF4457@cs181133002.pp.htv.fi>	 <20080303114533.GA4183@elte.hu> <20080303121335.GA15381@elte.hu>	 <20080303145623.GA25697@uranus.ravnborg.org>	 <20080304164605.GA16379@elte.hu> <1204654039.5698.13.camel@brick>
In-Reply-To: <1204654039.5698.13.camel@brick>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Harvey Harrison wrote:
> On Tue, 2008-03-04 at 17:46 +0100, Ingo Molnar wrote:
>> * Sam Ravnborg <sam@ravnborg.org> wrote:
> 
>> i dont know why they there are so many variants, but all of them seem to 
>> be used throughout the kernel:
>>
>>    inline    : 25648
> 
> I'll assume this is the preferred way of saying it.
> 
>>  __inline__  : 1380
> 
> Lots of them in include/asm-*...not sure if there is a reason for this.
> 

Preferred form for code that's exported to userspace (since gcc 
complains with -ansi -pedantic otherwise.)

	-hpa
