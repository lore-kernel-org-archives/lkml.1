Return-Path: <linux-kernel-owner+w=401wt.eu-S1765716AbXG0EgT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765716AbXG0EgT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jul 2007 00:36:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751805AbXG0EgF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Jul 2007 00:36:05 -0400
Received: from mx.c3sl.ufpr.br ([200.17.202.3]:44024 "EHLO
	urquell.c3sl.ufpr.br" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751643AbXG0EgE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jul 2007 00:36:04 -0400
Message-ID: <46A97630.9080506@c3sl.ufpr.br>
Date: Fri, 27 Jul 2007 01:36:00 -0300
From: Tiago Vignatti <vignatti@c3sl.ufpr.br>
User-Agent: Thunderbird 1.5.0.10 (X11/20070403)
MIME-Version: 1.0
To: Felipe Balbi <felipebalbi@users.sourceforge.net>
CC: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] exporting address to the page fault notifier
References: <46A95CFC.9050509@c3sl.ufpr.br> <31e679430707262025g5aa7c812s7522d2ff7fd2994c@mail.gmail.com>
In-Reply-To: <31e679430707262025g5aa7c812s7522d2ff7fd2994c@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Felipe Balbi escreveu:
> On 7/26/07, Tiago Vignatti <vignatti@c3sl.ufpr.br> wrote:
>> I made a module using the notifier scheme which already exists inside
>> the kernel. The problem is that the page fault notifier doesn't show the
>> address which happened the fault.
>>
>> This little patch increments this functionality. I chose to break the
>> ABI putting a new field in 'die_args' instead build a new struct only
>> for it. The patch and the module notifier comes attached.
> 
> don't send attachments... send the patch inline at the mail body this
> allows easier commenting on the code.
> 
> read Documentation/SubmittingPatches about how to send patches to lkml.

Okay. I sent another mail. Thanks for pointing this.

The page fault notifier can be seen here:
http://web.inf.ufpr.br/vignatti/code/page_fault_notifier.c


Cheers,

-- 
Tiago Vignatti
C3SL - Centro de Computação Científica e Software Livre
www.c3sl.ufpr.br
