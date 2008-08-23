Return-Path: <linux-kernel-owner+w=401wt.eu-S1755177AbYHWUSj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755177AbYHWUSj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Aug 2008 16:18:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755662AbYHWUSY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 Aug 2008 16:18:24 -0400
Received: from qb-out-0506.google.com ([72.14.204.239]:57581 "EHLO
	qb-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756407AbYHWUSX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Aug 2008 16:18:23 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=CIM4ngYHNyNZwPjMcH2VhdOccBxZ2v64Sbt+YEXq9BGamFZ+Pp0j0MGgciWx3zbWIv
         21qEQpnISHLCpSUCZ0mZNl7XS0EfHhDAYK6uE7omyq6deEbEioICcIUakb/inZ4Ex6Lt
         i4iPHnjam5BPVTFcT3cO8867BM3yBAkwiF8cs=
Date: Sun, 24 Aug 2008 00:18:55 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Yinghai Lu <yhlu.kernel@gmail.com>, mingo@elte.hu, macro@linux-mips.org,
       hpa@zytor.com, tglx@linutronix.de, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 5/8] x86: apic - unify hard_smp_processor_id
Message-ID: <20080823201855.GA30913@lenovo>
References: <a02f3dc9088b9b6c0d22fa77839fdd9d5309ec97.1219491572.git.gorcunov@gmail.com> <ad4298d4a7d4eb0bf4611765df4481ac129b5db6.1219491572.git.gorcunov@gmail.com> <86802c440808231213j9a2ffdem548ca91570c981b1@mail.gmail.com> <20080823194541.GC22089@lenovo>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080823194541.GC22089@lenovo>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Cyrill Gorcunov - Sat, Aug 23, 2008 at 11:45:41PM +0400]
...
| | 
| | this one seems have some problem with 32bit with genericarch
| | 
| | because we have
| | 
| | int hard_smp_processor_id(void)
| | {
| |         return genapic->get_apic_id(*(unsigned long *)(APIC_BASE+APIC_ID));
| | }
| | 
| | arch/x86/mach-generic/probe.c
| | 
| | updated 64 bit to have MACRO.
| | 
| | YH
| | 
| 
| thanks Yinghai, but isn't it called _after_ x86 apic chip
| initialized?
| 
| 		- Cyrill -

it's not related to initializaton - ignore my prev mail please.
(just a notice: If you've 64bit version updated to MACRO dont
forget you will need read_apic_id as well).

		- Cyrill -
