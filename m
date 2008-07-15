Return-Path: <linux-kernel-owner+w=401wt.eu-S1759323AbYGONLX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759323AbYGONLX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2008 09:11:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755172AbYGONLP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jul 2008 09:11:15 -0400
Received: from g5t0006.atlanta.hp.com ([15.192.0.43]:36478 "EHLO
	g5t0006.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753003AbYGONLP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2008 09:11:15 -0400
Message-ID: <487CA199.8010207@hp.com>
Date: Tue, 15 Jul 2008 09:09:45 -0400
From: "Alan D. Brunelle" <Alan.Brunelle@hp.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080505)
MIME-Version: 1.0
To: Roland Dreier <rdreier@cisco.com>
CC: Nigel Cunningham <ncunningham@crca.org.au>,
       LKML <linux-kernel@vger.kernel.org>, torvalds@linux-foundation.org,
       Glauber Costa <gcosta@redhat.com>, Ingo Molnar <mingo@elte.hu>
Subject: Re: Current head x86_64 breakage - csum-copy_64.S
References: <1216082378.25534.43.camel@nigel-laptop> <adafxqchryc.fsf@cisco.com>
In-Reply-To: <adafxqchryc.fsf@cisco.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Roland Dreier wrote:
>  >   AS      arch/x86/lib/csum-copy_64.o
>  > arch/x86/lib/csum-copy_64.S: Assembler messages:
>  > arch/x86/lib/csum-copy_64.S:48: Error: Macro `ignore' was already defined
> 
> Yes, the culprit seems to be 70f1bba4 ("x86: use ignore macro instead of
> hash comment"), which introduces the ignore macro in dwarf2.h, which
> collides with the macro already in csum-copy_64.S.
> 
> Perhaps something like the patch below?

This fixed the problem for me - compiled, linked & booted just fine.

Thanks!
Alan D. Brunelle
