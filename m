Return-Path: <linux-kernel-owner+w=401wt.eu-S1757946AbYEDVLM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757946AbYEDVLM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 May 2008 17:11:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753313AbYEDVK6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 May 2008 17:10:58 -0400
Received: from terminus.zytor.com ([198.137.202.10]:33248 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753162AbYEDVK6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 May 2008 17:10:58 -0400
Message-ID: <481E258C.20003@zytor.com>
Date: Sun, 04 May 2008 14:07:24 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: Arjan van de Ven <arjan@linux.intel.com>
CC: "Maciej W. Rozycki" <macro@linux-mips.org>,
       Thomas Gleixner <tglx@linutronix.de>, jamal <hadi@cyberus.ca>,
       Suresh Siddha <suresh.b.siddha@intel.com>, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>, Jan Beulich <jbeulich@novell.com>
Subject: Re: i387/FPU init issues...
References: <1209810775.6972.37.camel@localhost> <alpine.LFD.1.10.0805031650120.6003@apollo.tec.linutronix.de> <481CA40A.7040906@zytor.com> <Pine.LNX.4.55.0805032016560.20206@cliff.in.clinika.pl> <481CC5CD.8060205@zytor.com> <481E1B89.8020708@linux.intel.com>
In-Reply-To: <481E1B89.8020708@linux.intel.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arjan van de Ven wrote:
>>
>> It has retroactively been added to the documented list for all P6 core 
>> chips - that should mean it works on all of them.  The most common 
>> reason for not documenting something (other than various Pure Evil NDA 
>> schemes) is that it hasn't been properly verified.  However, 
>> verification can be done a posteori.
> 
> the other reason is that certain groups of "unknown" opcodes will act as 
> NOP.
> Which for this purpose is .. exactly the right thing retroactive
> 

Specifically, I believe the P6 added a whole class of instructions which 
would act as NOP's if used on older chips.  It has been used for 
prefetch instructions, etc.  At some point, the 0F 1F /0 group was 
declared to be NOP, and nothing else, for all future.

	-hpa

