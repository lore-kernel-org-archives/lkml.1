Return-Path: <linux-kernel-owner+w=401wt.eu-S1754484AbYKFJaL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754484AbYKFJaL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2008 04:30:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753304AbYKFJ36
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Nov 2008 04:29:58 -0500
Received: from terminus.zytor.com ([198.137.202.10]:34799 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753233AbYKFJ35 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2008 04:29:57 -0500
Message-ID: <4912B826.2090202@zytor.com>
Date: Thu, 06 Nov 2008 01:25:58 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.16 (X11/20080723)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Jeremy Fitzhardinge <jeremy@goop.org>, Andi Kleen <andi@firstfloor.org>,
       Alexander van Heukelum <heukelum@fastmail.fm>,
       Cyrill Gorcunov <gorcunov@gmail.com>,
       Alexander van Heukelum <heukelum@mailshack.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>, lguest@ozlabs.org,
       jeremy@xensource.com, Steven Rostedt <srostedt@redhat.com>,
       Mike Travis <travis@sgi.com>
Subject: Re: [PATCH RFC/RFB] x86_64, i386: interrupt dispatch changes
References: <20081104122839.GA22864@mailshack.com> <20081104150729.GC21470@localhost> <20081104170501.GE29626@one.firstfloor.org> <1225822006.21441.1282961299@webmail.messagingengine.com> <20081104204400.GC10825@elte.hu> <20081104210643.GH29626@one.firstfloor.org> <4910EBF5.7070506@goop.org> <20081106091548.GE4890@elte.hu>
In-Reply-To: <20081106091548.GE4890@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> 
> yes, the accessed bit in the segment descriptor has to be updated in 
> an atomic transaction: the CPU has to do a MESI coherent 
> read+compare+write transaction, without damaging other updates to the 
> 6 bytes segment descriptor.
> 

8 bytes, rather.
