Return-Path: <linux-kernel-owner+w=401wt.eu-S1757555AbXIRWhK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757555AbXIRWhK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Sep 2007 18:37:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751774AbXIRWg6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Sep 2007 18:36:58 -0400
Received: from terminus.zytor.com ([198.137.202.10]:58993 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751163AbXIRWg5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Sep 2007 18:36:57 -0400
Message-ID: <46F0521F.10302@zytor.com>
Date: Tue, 18 Sep 2007 15:33:03 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: Jeremy Fitzhardinge <jeremy@goop.org>
CC: Andi Kleen <andi@firstfloor.org>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       Chuck Ebbert <cebbert@redhat.com>,
       Christoph Hellwig <hch@infradead.org>
Subject: Re: [patch 4/7] Immediate Values - i386 Optimization
References: <20070918210747.828804366@polymtl.ca>	<20070918210853.588573678@polymtl.ca> <46F04856.3010808@goop.org> <p73myvjwri3.fsf@bingen.suse.de> <46F0515E.2010608@goop.org>
In-Reply-To: <46F0515E.2010608@goop.org>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jeremy Fitzhardinge wrote:
> Andi Kleen wrote:
>> Jeremy Fitzhardinge <jeremy@goop.org> writes:
>>   
>>> It's a pity that gas seems to generate plain 0x90 nops rather than
>>> long-nop forms here.  I thought it could do that.
>>>     
>> .p2align does it
> 
> Just .p2align?  Not align, balign, org or skip?  Seems... strange.
> 

Probably it works for .align and .balign too, but not .org.

	-hpa
