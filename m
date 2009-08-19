Return-Path: <linux-kernel-owner+w=401wt.eu-S1751636AbZHSJXp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751636AbZHSJXp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Aug 2009 05:23:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751494AbZHSJXo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Aug 2009 05:23:44 -0400
Received: from vpn.id2.novell.com ([195.33.99.129]:19551 "EHLO
	vpn.id2.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751617AbZHSJXn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Aug 2009 05:23:43 -0400
Message-Id: <4A8BE0BE0200007800010890@vpn.id2.novell.com>
X-Mailer: Novell GroupWise Internet Agent 8.0.0 
Date: Wed, 19 Aug 2009 10:23:42 +0100
From: "Jan Beulich" <JBeulich@novell.com>
To: "Thomas Gleixner" <tglx@linutronix.de>
Cc: <mingo@elte.hu>, "Peter Zijlstra" <peterz@infradead.org>,
       <linux-kernel@vger.kernel.org>, <hpa@zytor.com>
Subject: Re: [PATCH] x86: make use of inc/dec conditional
References: <4A8BCA850200007800010836@vpn.id2.novell.com>
 <1250668860.7583.327.camel@twins>
 <4A8BDB51020000780001086E@vpn.id2.novell.com>
 <alpine.LFD.2.00.0908191105260.3361@localhost.localdomain>
In-Reply-To: <alpine.LFD.2.00.0908191105260.3361@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> Thomas Gleixner <tglx@linutronix.de> 19.08.09 11:06 >>>
>You still do not tell on which machines the INC/DEC instructions
>should be avoided and why. GCC avoiding it is not a convincing
>argument.

On Pentium4 (Prescott/Nocona) inc/dec not modifying the carry flag cause
an extra instruction dependency on EFLAGS, and hence extra latency in
when the instruction can be scheduled for execution.

Jan

