Return-Path: <linux-kernel-owner+w=401wt.eu-S1757861AbZHQU1J@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757861AbZHQU1J (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Aug 2009 16:27:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752598AbZHQU1I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Aug 2009 16:27:08 -0400
Received: from mail.vyatta.com ([76.74.103.46]:47814 "EHLO mail.vyatta.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752363AbZHQU1H (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Aug 2009 16:27:07 -0400
Date: Mon, 17 Aug 2009 13:27:03 -0700
From: Stephen Hemminger <shemminger@vyatta.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: john stultz <johnstul@us.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: clocksource changes in 2.6.31 - possible regression
Message-ID: <20090817132703.2db7b0c9@nehalam>
In-Reply-To: <alpine.LFD.2.00.0908172202430.2782@localhost.localdomain>
References: <20090817090319.20979986@nehalam>
	<1250531337.26171.12.camel@work-vm>
	<20090817110127.40ee5c29@nehalam>
	<1250532954.26171.35.camel@work-vm>
	<20090817112704.2b4b2987@nehalam>
	<alpine.LFD.2.00.0908172032500.2782@localhost.localdomain>
	<20090817125406.03e26060@nehalam>
	<alpine.LFD.2.00.0908172202430.2782@localhost.localdomain>
Organization: Vyatta
X-Mailer: Claws Mail 3.6.1 (GTK+ 2.16.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 17 Aug 2009 22:04:39 +0200 (CEST)
Thomas Gleixner <tglx@linutronix.de> wrote:

> On Mon, 17 Aug 2009, Stephen Hemminger wrote:
> > On Mon, 17 Aug 2009 20:34:02 +0200 (CEST)
> > Thomas Gleixner <tglx@linutronix.de> wrote:
> > > 
> > > Can you please provide a full dmesg of pre 31 and the output of
> 
> Thanks for the dmesg. Can you please send the output of 
> 
> > > /sys/.../available_clocksources before you switch to TSC ?
> 
> as well ? While at it please add the output of
> /sys/.../current_clocksource
> 
> Thanks,
> 
> 	tglx
> 
> 
cat /sys/devices/system/clocksource/clocksource0/available_clocksource

acpi_pm jiffies tsc 


-- 
