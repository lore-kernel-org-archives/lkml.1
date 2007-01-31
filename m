Return-Path: <linux-kernel-owner+w=401wt.eu-S1030247AbXAaR2i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030247AbXAaR2i (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Jan 2007 12:28:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030340AbXAaR2i
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Jan 2007 12:28:38 -0500
Received: from www.osadl.org ([213.239.205.134]:51588 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1030247AbXAaR2h (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Jan 2007 12:28:37 -0500
Subject: Re: [PATCH 14/23] clocksource: increase initcall priority
From: Thomas Gleixner <tglx@linutronix.de>
Reply-To: tglx@linutronix.de
To: Daniel Walker <dwalker@mvista.com>
Cc: Ingo Molnar <mingo@elte.hu>, akpm@osdl.org, linux-kernel@vger.kernel.org,
       johnstul@us.ibm.com
In-Reply-To: <1170264052.9781.130.camel@imap.mvista.com>
References: <20070131033710.420168478@mvista.com>
	 <20070131033807.427331295@mvista.com> <20070131115055.GD1847@elte.hu>
	 <1170261775.9781.100.camel@imap.mvista.com> <20070131171042.GB4468@elte.hu>
	 <1170264052.9781.130.camel@imap.mvista.com>
Content-Type: text/plain
Date: Wed, 31 Jan 2007 18:29:26 +0100
Message-Id: <1170264566.29240.191.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-01-31 at 09:20 -0800, Daniel Walker wrote:
> The purpose of clocksource_initcall is so the initcall can be increased
> without changing all the individual clocksources .. So I have to
> disconnect that from the acpi_pm because it can't tolerate it.

Each clocksource has to decide on its own, when the registration is
done. ARM clocksources register in the timer init, pm timer needs to
wait. 

So what exactly is solved by an extra initcall ?

	tglx


