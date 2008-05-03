Return-Path: <linux-kernel-owner+w=401wt.eu-S1753848AbYECUHd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753848AbYECUHd (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 May 2008 16:07:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752470AbYECUH0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 May 2008 16:07:26 -0400
Received: from terminus.zytor.com ([198.137.202.10]:55702 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752344AbYECUHZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 May 2008 16:07:25 -0400
Message-ID: <481CC5CD.8060205@zytor.com>
Date: Sat, 03 May 2008 13:06:37 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: "Maciej W. Rozycki" <macro@linux-mips.org>
CC: Thomas Gleixner <tglx@linutronix.de>, jamal <hadi@cyberus.ca>,
       Suresh Siddha <suresh.b.siddha@intel.com>,
       Arjan van de Ven <arjan@linux.intel.com>, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>, Jan Beulich <jbeulich@novell.com>
Subject: Re: i387/FPU init issues...
References: <1209810775.6972.37.camel@localhost> <alpine.LFD.1.10.0805031650120.6003@apollo.tec.linutronix.de> <481CA40A.7040906@zytor.com> <Pine.LNX.4.55.0805032016560.20206@cliff.in.clinika.pl>
In-Reply-To: <Pine.LNX.4.55.0805032016560.20206@cliff.in.clinika.pl>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Maciej W. Rozycki wrote:
> On Sat, 3 May 2008, H. Peter Anvin wrote:
> 
>> Intel explicitly documents "all processors with family 6 or F."
> 
>  It depends (as usually with Intel) on what document you are looking at.  
> Based on my short research, the instruction has been retroactively added
> to the list of supported opcodes.  Even my somewhat dated P4 manual does
> not list it, never mind its predecessors.  It could have been accidentally
> omitted or even buggy in some early members of the P6 family and this
> could have been the reason for not documenting it from the beginning (the
> case of FFREEP comes to mind).
> 

It has retroactively been added to the documented list for all P6 core 
chips - that should mean it works on all of them.  The most common 
reason for not documenting something (other than various Pure Evil NDA 
schemes) is that it hasn't been properly verified.  However, 
verification can be done a posteori.

	-hpa
