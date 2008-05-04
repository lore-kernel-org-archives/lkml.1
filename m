Return-Path: <linux-kernel-owner+w=401wt.eu-S1758065AbYEDUZS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758065AbYEDUZS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 May 2008 16:25:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756346AbYEDUZG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 May 2008 16:25:06 -0400
Received: from mga10.intel.com ([192.55.52.92]:50813 "EHLO
	fmsmga102.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752679AbYEDUZE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 May 2008 16:25:04 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.27,435,1204531200"; 
   d="scan'208";a="324393440"
Message-ID: <481E1B89.8020708@linux.intel.com>
Date: Sun, 04 May 2008 22:24:41 +0200
From: Arjan van de Ven <arjan@linux.intel.com>
User-Agent: Thunderbird 2.0.0.12 (Windows/20080213)
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>
CC: "Maciej W. Rozycki" <macro@linux-mips.org>,
       Thomas Gleixner <tglx@linutronix.de>, jamal <hadi@cyberus.ca>,
       Suresh Siddha <suresh.b.siddha@intel.com>, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>, Jan Beulich <jbeulich@novell.com>
Subject: Re: i387/FPU init issues...
References: <1209810775.6972.37.camel@localhost> <alpine.LFD.1.10.0805031650120.6003@apollo.tec.linutronix.de> <481CA40A.7040906@zytor.com> <Pine.LNX.4.55.0805032016560.20206@cliff.in.clinika.pl> <481CC5CD.8060205@zytor.com>
In-Reply-To: <481CC5CD.8060205@zytor.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

H. Peter Anvin wrote:
> Maciej W. Rozycki wrote:
>> On Sat, 3 May 2008, H. Peter Anvin wrote:
>>
>>> Intel explicitly documents "all processors with family 6 or F."
>>
>>  It depends (as usually with Intel) on what document you are looking 
>> at.  Based on my short research, the instruction has been 
>> retroactively added
>> to the list of supported opcodes.  Even my somewhat dated P4 manual does
>> not list it, never mind its predecessors.  It could have been 
>> accidentally
>> omitted or even buggy in some early members of the P6 family and this
>> could have been the reason for not documenting it from the beginning (the
>> case of FFREEP comes to mind).
>>
> 
> It has retroactively been added to the documented list for all P6 core 
> chips - that should mean it works on all of them.  The most common 
> reason for not documenting something (other than various Pure Evil NDA 
> schemes) is that it hasn't been properly verified.  However, 
> verification can be done a posteori.

the other reason is that certain groups of "unknown" opcodes will act as NOP.
Which for this purpose is .. exactly the right thing retroactive

> 
>     -hpa

