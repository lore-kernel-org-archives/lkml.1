Return-Path: <linux-kernel-owner+w=401wt.eu-S1757760AbYILUSx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757760AbYILUSx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Sep 2008 16:18:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753124AbYILUSp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Sep 2008 16:18:45 -0400
Received: from rn-out-0910.google.com ([64.233.170.185]:40649 "EHLO
	rn-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755395AbYILUSo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Sep 2008 16:18:44 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=i27vtzbsRmhI2oQtkXmw3akuuSsmCNDLMSn8Uyj2WJ4ssJcORWdxz3zVrqQZ/waK7N
         lI4Vq4CoTch6Zklh2mFOT2ot+qKGv0oEkWIQ/MEsX6MKxlR8iH0LccXhcI485SPBqEgO
         lkiKZ7Ubhjc0aFdkLdLqUpuZtKl85+eCt2MUw=
Date: Sat, 13 Sep 2008 00:18:48 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Yinghai Lu <yhlu.kernel@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       "Maciej W. Rozycki" <macro@linux-mips.org>
Subject: Re: [PATCH] x86: io-apic - do not use KERN_DEBUG marker too much
Message-ID: <20080912201848.GB8410@lenovo>
References: <20080908153806.GB7278@lenovo> <86802c440809121255k1af2881dwb00ebb6f4a58057b@mail.gmail.com> <86802c440809121257s23e5193aqb7939fdc94473c9d@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <86802c440809121257s23e5193aqb7939fdc94473c9d@mail.gmail.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Yinghai Lu - Fri, Sep 12, 2008 at 12:57:21PM -0700]
...
| > IOAPIC[0]: Set routing entry (8-14 -> 0x3e -> IRQ 14 Mode:0 Active:0)
| >  0 add_pin_to_irq: irq 15 --> apic 0 pin 15
| > IOAPIC[0]: Set routing entry (8-15 -> 0x3f -> IRQ 15 Mode:0 Active:0)
| >  8-16 8-17 8-18 8-19 8-20 8-21 8-22 8-23 (apicid-pin) not connected
| >  9-0 9-1 9-2 9-3 9-4 9-5 9-6 9-7 9-8 9-9 9-10 9-11 9-12 9-13 9-14 9-15
| > 9-16 9-17 9-18 9-19 9-20 9-21 9-22 9-23 (apicid-pin) not connected
| >
| 
| only first one not connected at first, and ...
| 
| why not just revert those two patches?
| 
| YH
| 

ok, convinced - Ingo, could you drop them please?

(yes, I've missed one new-line printing, sorry -
 but quite frankly - it reveals another problem -
 printing between other printing - which means
 ideally it would be to _have_ temporary buffer apart
 from printk buffer. So we have - either adding additional
 new line printout 'cause of printing inbetween or our
 own buffer to be able to print in nice-fasion. Anyway
 I'm fine to just revert these attempts made. And thanks
 Yinghai for comments and testing!)

		- Cyrill -
