Return-Path: <linux-kernel-owner+w=401wt.eu-S1761409AbZAPIWY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761409AbZAPIWY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jan 2009 03:22:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755971AbZAPIWL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Jan 2009 03:22:11 -0500
Received: from vpn.id2.novell.com ([195.33.99.129]:37738 "EHLO
	vpn.id2.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756015AbZAPIWK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jan 2009 03:22:10 -0500
Message-Id: <497051E7.76E4.0078.0@novell.com>
X-Mailer: Novell GroupWise Internet Agent 8.0.0 
Date: Fri, 16 Jan 2009 08:22:47 +0000
From: "Jan Beulich" <jbeulich@novell.com>
To: "Ingo Molnar" <mingo@elte.hu>
Cc: <tglx@linutronix.de>, <linux-kernel@vger.kernel.org>, <hpa@zytor.com>
Subject: Re: [PATCH] x86: avoid early crash in disable_local_APIC()
References: <496DE893.76E4.0078.0@novell.com>
 <20090115110528.GE16253@elte.hu> <20090115224710.GA1327@elte.hu>
 <20090115224751.GA1625@elte.hu>
In-Reply-To: <20090115224751.GA1625@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> Ingo Molnar <mingo@elte.hu> 15.01.09 23:47 >>>
>
>* Ingo Molnar <mingo@elte.hu> wrote:
>
>> hm, this gives a build failure on latest -tip:
>> 
>> arch/x86/kernel/apic.c: In function 'setup_local_APIC':
>> arch/x86/kernel/apic.c:1135: error: implicit declaration of function 'disable_ioapic_setup'

Is this with a config that has X86_IO_APIC off (i.e. one the practical use of
which I never understood, and hence easily forget to consider)? Otherwise
I can't see how that could happen.

Jan

