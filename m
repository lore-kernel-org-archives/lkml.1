Return-Path: <linux-kernel-owner+w=401wt.eu-S965172AbXCAPY7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965172AbXCAPY7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Mar 2007 10:24:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965277AbXCAPY7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Mar 2007 10:24:59 -0500
Received: from lmv.inov.pt ([146.193.64.2]:55434 "EHLO lmv.inov.pt"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965172AbXCAPY6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Mar 2007 10:24:58 -0500
Message-ID: <45E6F032.2050501@inov.pt>
Date: Thu, 01 Mar 2007 15:24:34 +0000
From: Jose Goncalves <jose.goncalves@inov.pt>
User-Agent: Thunderbird 1.5.0.9 (X11/20070111)
MIME-Version: 1.0
To: Jose Goncalves <jose.goncalves@inov.pt>,
       Frederik Deweerdt <deweerdt@free.fr>, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org
Subject: Re: Serial related oops
References: <20070219150508.GD27370@flint.arm.linux.org.uk> <45D9D073.7020701@inov.pt> <20070219164200.GF27370@flint.arm.linux.org.uk> <45D9E46C.4030408@inov.pt> <20070219212347.GA4258@flint.arm.linux.org.uk> <45DC537B.6020108@inov.pt> <20070221230503.GA28156@flint.arm.linux.org.uk> <45DDB096.2020807@inov.pt> <20070222170354.GB633@flint.arm.linux.org.uk> <45E6D628.90800@inov.pt> <20070301151022.GA15447@flint.arm.linux.org.uk>
In-Reply-To: <20070301151022.GA15447@flint.arm.linux.org.uk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
X-INOV-EmailServer-Information: Please contact the Email service provider for more information
X-INOV-EmailServer: Found to be clean
X-INOV-EmailServer-From: jose.goncalves@inov.pt
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Russell King wrote:
> On Thu, Mar 01, 2007 at 01:33:28PM +0000, Jose Goncalves wrote:
>   
>> I've also done your suggestion and I've inserted "msleep(10);" just
>> before the "And clear the interrupt registers again for luck." and my
>> application is now running without problems fore more than 24H! So,
>> inserting a delay in this point definitely makes some difference (has
>> was with adding some extra printk() in several points of
>> serial8250_startup()).
>>
>> This said, for me, this is definitely a software problem. The question
>> is were?
>>     
>
> I'm personally convinced it's hardware because according to my analysis
> your CPU behaving in a way that the code is not asking it to do so.
>   

It's not possible that a interrupt is hitting just after enabling
interrupts with "serial_outp(up, UART_IER, up->ier);" which triggers the
execution of some code that is not reported by the Oops dump (at least
with my current configuration) ?

José Gonçalves

