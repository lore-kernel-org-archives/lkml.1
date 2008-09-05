Return-Path: <linux-kernel-owner+w=401wt.eu-S1752957AbYIETPl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752957AbYIETPl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2008 15:15:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750857AbYIETPa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Sep 2008 15:15:30 -0400
Received: from fg-out-1718.google.com ([72.14.220.156]:35448 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751151AbYIETP3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2008 15:15:29 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=HOvRz3D/EsTiqBKIhsOJx9T9pnxOe4xAZQUcPZJV/unwkXvIzCIj84XimpytPn9qnB
         p8J4l/6sI9AWI1jh1EusuuvDBrV5qh0QtRvJLOPb7UDev6tQd+8RT7be/LCWuzmy4uhp
         FzuGw7H/LEkBgtiDGvIFZKgj3GQmR1MBMJ+A0=
Date: Fri, 5 Sep 2008 23:15:25 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: hpa@zytor.com, linux-kernel@vger.kernel.org, tglx@linutronix.de,
       yhlu.kernel@gmail.com, macro@linux-mips.org
Subject: Re: [patch 3/3] x86: io-apic - code style cleaning for
	setup_IO_APIC_irqs
Message-ID: <20080905191525.GC19334@lenovo>
References: <20080904183748.950151853@gmail.com>> <48c02b6a.0637560a.15e9.ffffa39d@mx.google.com> <20080905080447.GC12409@elte.hu> <20080905180126.GA19334@lenovo> <20080905181111.GG27395@elte.hu> <20080905183347.GB19334@lenovo> <20080905183835.GA19215@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080905183835.GA19215@elte.hu>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Ingo Molnar - Fri, Sep 05, 2008 at 08:38:35PM +0200]
| 
| * Cyrill Gorcunov <gorcunov@gmail.com> wrote:
| 
| > So as you see it's more then enough self-solid :) So I wouldn't break 
| > it 'cause of printing. If we have enough memory for bit field - we 
| > could just mark there if pin is connected to irq and print connection 
| > map after. Don't get me wrong please - I just don't want to overload 
| > this function with additional call.
| 
| the compiler will inline that single-called function just fine, as long 
| as you declare it static.
| 
| spreading printouts over several functions isnt all that bad i think. We 
| could even drop the 'not connected' complication - it's evident enough 
| from the fact that nothing gets printed.
| 
| 	Ingo
|

Ingo, lets leave it as is for now :)

(we cshouldn't drop these messages since they show us what
exactly is wrong with MP table)
 
		- Cyrill -
