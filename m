Return-Path: <linux-kernel-owner+w=401wt.eu-S1757090AbYBMNsZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757090AbYBMNsZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2008 08:48:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753671AbYBMNsO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Feb 2008 08:48:14 -0500
Received: from cantor2.suse.de ([195.135.220.15]:41534 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753568AbYBMNsN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2008 08:48:13 -0500
Message-ID: <47B2F56D.1070004@suse.de>
Date: Wed, 13 Feb 2008 14:49:33 +0100
From: Andi Kleen <ak@suse.de>
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Andi Kleen <andi@firstfloor.org>, mingo@elte.hu,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [1/5] Only do century BCD conversion when we know the
 RTC is BCD
References: <20080209416.271135970@suse.de> <alpine.LFD.1.00.0802110924050.12988@apollo.tec.linutronix.de> <200802110956.16004.ak@suse.de> <alpine.LFD.1.00.0802112246590.12988@apollo.tec.linutronix.de> <20080211221514.GA12592@basil.nowhere.org> <alpine.LFD.1.00.0802122130280.12988@apollo.tec.linutronix.de>
In-Reply-To: <alpine.LFD.1.00.0802122130280.12988@apollo.tec.linutronix.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thomas Gleixner wrote:
> On Mon, 11 Feb 2008, Andi Kleen wrote:
> 
>>> So the warning comes a bit late :)
>> I suspect if this was wrong before it would not have been noticed
>> because user space hwclock would work around it. 
> 
> And how exaclty does it work aroalund ? By setting the binary cmos clock
> with BCD values ?

By reading the value directly from CMOS I suppose and checking
the BCD bit and then setting the clock to the correct value [all
theoretical; i have not checked the hwclock code if
it does that or not. It might be wrong. Just a hypothesis.]

-Andi

