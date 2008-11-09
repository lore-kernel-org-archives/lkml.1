Return-Path: <linux-kernel-owner+w=401wt.eu-S1755140AbYKILFX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755140AbYKILFX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Nov 2008 06:05:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754333AbYKILFJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Nov 2008 06:05:09 -0500
Received: from fg-out-1718.google.com ([72.14.220.159]:53436 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753498AbYKILFH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Nov 2008 06:05:07 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=nC17IvvN/MGcGkhA73LGxTRw3lEzTirVVnX4h+pkz18QfrcXSTfJO4GYKQLO1xZ1Kx
         d/5ZYj0H1GfzWJnKJVq9X8TPA2XYYvYUQflAl+/4OkyFxclyLzR8XrrrSF4jdEs6cd/S
         E/uvuKnu6qtMdYOKec/Qj7MqNtW0Spm4JF4Wk=
Date: Sun, 9 Nov 2008 14:05:03 +0300
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Ingo Molnar <mingo@elte.hu>, "Maciej W. Rozycki" <macro@linux-mips.org>,
       "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       Yinghai Lu <yhlu.kernel@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: [patch 1/2] x86: apic - calibrate_APIC_clock remove redundant
	irq-enable-disable
Message-ID: <20081109110503.GC12238@localhost>
References: <20081109105709.222708517@gmail.com>> <4916c290.0437560a.270e.0940@mx.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4916c290.0437560a.270e.0940@mx.google.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Cyrill Gorcunov - Thu, Jan 01, 1970 at 03:00:01AM +0300]
| Impact: cleanup
| 
| lapic_timer_setup is self-protected with local_irq_save/restore
| no need to use them in caller and levt is the per-cpu variable so
| no concurrent access from another cpu.
| 
| Signed-off-by: Cyrill Gorcunov <gorcunov@gmail.com>
| ---
|  arch/x86/kernel/apic.c |    4 ----
|  1 file changed, 4 deletions(-)
|
...

Oh... it happend again -- 'Jan 01, 1970' dated message gone out.
Sorry for that! Seems sendmail does screw somehow quilt passed args...

		- Cyrill -
