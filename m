Return-Path: <linux-kernel-owner+w=401wt.eu-S1757544AbXERO70@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757544AbXERO70 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2007 10:59:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754504AbXERO7U
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 May 2007 10:59:20 -0400
Received: from h155.mvista.com ([63.81.120.158]:37860 "EHLO
	gateway-1237.mvista.com" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1752992AbXERO7T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2007 10:59:19 -0400
Subject: Re: [PATCH 2.6.21-rt2] PowerPC: decrementer clockevent driver
From: Daniel Walker <dwalker@mvista.com>
To: Kumar Gala <galak@kernel.crashing.org>
Cc: Sergei Shtylyov <sshtylyov@ru.mvista.com>, tglx@linutronix.de,
       mingo@elte.hu, linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org
In-Reply-To: <135307ED-7125-4859-8594-4B5B900D92D6@kernel.crashing.org>
References: <200705172142.26739.sshtylyov@ru.mvista.com>
	 <8E44DB06-767D-4864-8D2C-6132E4D4370B@kernel.crashing.org>
	 <464C99FF.8080404@ru.mvista.com>
	 <135307ED-7125-4859-8594-4B5B900D92D6@kernel.crashing.org>
Content-Type: text/plain
Date: Fri, 18 May 2007 07:56:57 -0700
Message-Id: <1179500217.20519.53.camel@imap.mvista.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 (2.8.3-2.fc6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2007-05-17 at 13:17 -0500, Kumar Gala wrote:

> 
> I haven't looked at all the new clock/timer code, is there any  
> utility in having support for more than one clock source?

There is if the main clocksource has some issues where it can't be used.
On x86 there are lots of different issues with the clocks, so they have
to get switches once in a while. For instance, if the TSC changes
frequencies then it can't be used, or if the TSC stops in different
power states , it can't be used.. 

Anything like that on PowerPC?

Daniel

