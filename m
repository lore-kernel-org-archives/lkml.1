Return-Path: <linux-kernel-owner+w=401wt.eu-S1754565AbYE2JfY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754565AbYE2JfY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2008 05:35:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752128AbYE2JfL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 May 2008 05:35:11 -0400
Received: from sovereign.computergmbh.de ([85.214.69.204]:35190 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751565AbYE2JfK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2008 05:35:10 -0400
Date: Thu, 29 May 2008 11:35:08 +0200 (CEST)
From: Jan Engelhardt <jengelh@medozas.de>
To: "H. Peter Anvin" <hpa@zytor.com>
cc: "Maciej W. Rozycki" <macro@linux-mips.org>, Dave Jones <davej@redhat.com>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [X86] Fix up silly i1586 boot message.
In-Reply-To: <483DF520.6010602@zytor.com>
Message-ID: <alpine.LNX.1.10.0805291131450.19264@fbirervta.pbzchgretzou.qr>
References: <20080528165713.GA412@redhat.com> <alpine.LNX.1.10.0805281943330.19264@fbirervta.pbzchgretzou.qr> <Pine.LNX.4.55.0805281850540.29522@cliff.in.clinika.pl> <alpine.LNX.1.10.0805282001180.19264@fbirervta.pbzchgretzou.qr>
 <Pine.LNX.4.55.0805281916480.29522@cliff.in.clinika.pl> <483DB2D5.8050502@zytor.com> <Pine.LNX.4.55.0805290102340.29522@cliff.in.clinika.pl> <483DF520.6010602@zytor.com>
User-Agent: Alpine 1.10 (LNX 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Thursday 2008-05-29 02:13, H. Peter Anvin wrote:

> Maciej W. Rozycki wrote:
>> > uname reports i686 on these chips.  The rest is ridiculous.
>> 
>> Intel started it first with picking up a ridiculous number for the family
>> ID for the P4 line.  There is no technical justification for not keeping
>> these numbers consecutive.  Or keeping it at 6 actually if the P4 is meant
>> to be seen by software as the Pentium Pro and the rest of the P6 gang.
>
> Yes, this is what we eventually ended up doing as causing fewest compatibility
> problems.  For the message in question, it's better to be consistent with
> uname.

Then again, should not all of the i?86 names be collapsed,
much like there is only "sparc" and "sparc64" for
the actual sparcv7, sparcv8, sparcv9, sparcv9a pseudo-arches
used in, for example rpm, etc.
