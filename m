Return-Path: <linux-kernel-owner+w=401wt.eu-S1762528AbYAQWxk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762528AbYAQWxk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2008 17:53:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760979AbYAQWmw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jan 2008 17:42:52 -0500
Received: from homer.mvista.com ([63.81.120.158]:3199 "EHLO
	gateway-1237.mvista.com" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1760858AbYAQWmv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2008 17:42:51 -0500
Subject: Re: setting jiffies as the clocksource stops time
From: Daniel Walker <dwalker@mvista.com>
To: Jan Engelhardt <jengelh@computergmbh.de>
Cc: Balaji Rao <balajirrao@gmail.com>, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>
In-Reply-To: <Pine.LNX.4.64.0801172333130.18447@fbirervta.pbzchgretzou.qr>
References: <200801170209.42138.balajirrao@gmail.com>
	 <1200518450.18731.129.camel@imap.mvista.com>
	 <Pine.LNX.4.64.0801172333130.18447@fbirervta.pbzchgretzou.qr>
Content-Type: text/plain
Date: Thu, 17 Jan 2008 14:39:40 -0800
Message-Id: <1200609581.18731.152.camel@imap.mvista.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.2 (2.12.2-2.fc8) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Thu, 2008-01-17 at 23:34 +0100, Jan Engelhardt wrote:
> On Jan 16 2008 13:20, Daniel Walker wrote:
> >On Thu, 2008-01-17 at 02:09 +0530, Balaji Rao wrote:
> >> Hi,
> >> 
> >> When i set jiffies as the current_clocksource, date(1) tells me
> >> that wallclock time has stopped, and soon after that, the system
> >> becomes unresponsive. This is not seen with CONFIG_NO_HZ disabled.
> >> 
> >> I wonder how can jiffies be used as a clocksource.. Its value
> >> depends on the tick and when we turn off ticks, we would stop
> >> incrementing jiffies and when we come come out of idle, we update
> >> the jiffies by reading the current_clocksource which now is
> >> 'jiffies', and hence jiffies wouldn't get updated. Could this be
> >> the explanation ?
> >
> >Your right, It can't be used as a clocksource with nohz , and the system
> >will refuse to automatically switch to it ..
> 
> I think that manually changing to jiffies by echoing into sysfs
> should also be prohibited.

Yeah, I wasn't suggesting we shouldn't prevent it .. However, there are
tons of way to kill your system by manual changing things ..

Daniel

