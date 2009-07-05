Return-Path: <linux-kernel-owner+w=401wt.eu-S1753701AbZGEQ7z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753701AbZGEQ7z (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Jul 2009 12:59:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752191AbZGEQ7q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 5 Jul 2009 12:59:46 -0400
Received: from mail-fx0-f218.google.com ([209.85.220.218]:50073 "EHLO
	mail-fx0-f218.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751992AbZGEQ7q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Jul 2009 12:59:46 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=gOuj37T8TEjowSBL1Zhty2zxlQkzd77o5k7fQX39wI5fQ5a2x3eTjslObDqc7pe9Q/
         qZZwwuV5XTwzNSbppbjo/M6618Jct2ZYuq3GzrRQ0y18EZVz908EiGYuph104gfMC+Fr
         j13UXHIy131fTZ3zYC3sKhsJbtVG74mC14bbc=
Date: Sun, 5 Jul 2009 20:59:47 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: "Maciej W. Rozycki" <macro@linux-mips.org>
Cc: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>, Yinghai Lu <yinghai@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [RFC -tip] x86,apic -- reduce disable_apic usage
Message-ID: <20090705165947.GD4791@lenovo>
References: <20090705162044.GC4791@lenovo> <alpine.LFD.2.00.0907051737100.13862@eddie.linux-mips.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.0907051737100.13862@eddie.linux-mips.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Maciej W. Rozycki - Sun, Jul 05, 2009 at 05:38:52PM +0100]
| On Sun, 5 Jul 2009, Cyrill Gorcunov wrote:
| 
| > Here is an attempt to bring more consistency for apic
| > presence check. I hope I covered all the code flows.
| > Though it's RFC. Please review and test if possible.
| > 
| > 	-- Cyrill
| > ---
| > Instead of messing with (cpu_has_apic|disable_apic)
| > to check if we have apic functional, better to distinguish
| > them by logical kind. cpu_has_apic -- to check if we may
| > use apic functionality, disable_apic -- to note that
| > apic was disabled via command line.
| 
|  How do you set cpu_has_apic for systems with discrete local APICs?  The 
| CPUID flag is not set in this case.
| 
|   Maciej
| --
| 

Well, indeed, somehow forgot about this case. Thanks Maciej!
The patch should be dropped.

	-- Cyrill
