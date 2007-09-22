Return-Path: <linux-kernel-owner+w=401wt.eu-S1762353AbXIVJrw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762353AbXIVJrw (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Sep 2007 05:47:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753929AbXIVJrp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 22 Sep 2007 05:47:45 -0400
Received: from sovereign.computergmbh.de ([85.214.69.204]:46297 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751089AbXIVJro (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Sep 2007 05:47:44 -0400
Date: Sat, 22 Sep 2007 11:47:43 +0200 (CEST)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: Chuck Ebbert <cebbert@redhat.com>
cc: Andi Kleen <ak@suse.de>, xemul@openvz.org, patches@x86-64.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [6/50] i386: clean up oops/bug reports
In-Reply-To: <46F448B1.2020400@redhat.com>
Message-ID: <Pine.LNX.4.64.0709221147140.15712@fbirervta.pbzchgretzou.qr>
References: <200709221231.836138000@suse.de> <20070921223204.43B8413DCD@wotan.suse.de>
 <46F448B1.2020400@redhat.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Sep 21 2007 18:41, Chuck Ebbert wrote:
>On 09/21/2007 06:32 PM, Andi Kleen wrote:
>> From: Pavel Emelyanov <xemul@openvz.org>
>> 
>> Typically the oops first lines look like this:
>> 
>> BUG: unable to handle kernel NULL pointer dereference at virtual address 00000000
>>  printing eip:
>> c049dfbd
>> *pde = 00000000
>> Oops: 0002 [#1]
>> PREEMPT SMP
>> ...
>> 
>> Such output is gained with some ugly if (!nl) printk("\n"); code and
>> besides being a waste of lines, this is also annoying to read. The
>> following output looks better (and it is how it looks on x86_64):
>> 
>> BUG: unable to handle kernel NULL pointer dereference at virtual address 00000000
>> printing eip: c049dfbd *pde = 00000000
>> Oops: 0002 [#1] PREEMPT SMP

In fact, the EIP can be left out, because it is printed later
as part of the register dump anyway.
