Return-Path: <linux-kernel-owner+w=401wt.eu-S1755495AbYE2AOS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755495AbYE2AOS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2008 20:14:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752241AbYE2AOK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 May 2008 20:14:10 -0400
Received: from terminus.zytor.com ([198.137.202.10]:35766 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752146AbYE2AOJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2008 20:14:09 -0400
Message-ID: <483DF520.6010602@zytor.com>
Date: Wed, 28 May 2008 17:13:20 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: "Maciej W. Rozycki" <macro@linux-mips.org>
CC: Jan Engelhardt <jengelh@medozas.de>, Dave Jones <davej@redhat.com>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [X86] Fix up silly i1586 boot message.
References: <20080528165713.GA412@redhat.com> <alpine.LNX.1.10.0805281943330.19264@fbirervta.pbzchgretzou.qr> <Pine.LNX.4.55.0805281850540.29522@cliff.in.clinika.pl> <alpine.LNX.1.10.0805282001180.19264@fbirervta.pbzchgretzou.qr> <Pine.LNX.4.55.0805281916480.29522@cliff.in.clinika.pl> <483DB2D5.8050502@zytor.com> <Pine.LNX.4.55.0805290102340.29522@cliff.in.clinika.pl>
In-Reply-To: <Pine.LNX.4.55.0805290102340.29522@cliff.in.clinika.pl>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Maciej W. Rozycki wrote:
>> uname reports i686 on these chips.  The rest is ridiculous.
> 
>  Intel started it first with picking up a ridiculous number for the family
> ID for the P4 line.  There is no technical justification for not keeping
> these numbers consecutive.  Or keeping it at 6 actually if the P4 is meant
> to be seen by software as the Pentium Pro and the rest of the P6 gang.

Yes, this is what we eventually ended up doing as causing fewest 
compatibility problems.  For the message in question, it's better to be 
consistent with uname.

	-hpa
