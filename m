Return-Path: <linux-kernel-owner+w=401wt.eu-S1757957AbXERPmE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757957AbXERPmE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2007 11:42:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754443AbXERPlz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 May 2007 11:41:55 -0400
Received: from h155.mvista.com ([63.81.120.158]:46547 "EHLO
	gateway-1237.mvista.com" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1754356AbXERPly (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2007 11:41:54 -0400
Subject: Re: [PATCH 2.6.21-rt2] PowerPC: decrementer clockevent driver
From: Daniel Walker <dwalker@mvista.com>
To: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Cc: Kumar Gala <galak@kernel.crashing.org>, tglx@linutronix.de, mingo@elte.hu,
       linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org
In-Reply-To: <464DC0DC.7050809@ru.mvista.com>
References: <200705172142.26739.sshtylyov@ru.mvista.com>
	 <8E44DB06-767D-4864-8D2C-6132E4D4370B@kernel.crashing.org>
	 <464C99FF.8080404@ru.mvista.com>
	 <135307ED-7125-4859-8594-4B5B900D92D6@kernel.crashing.org>
	 <1179500217.20519.53.camel@imap.mvista.com>
	 <464DC0DC.7050809@ru.mvista.com>
Content-Type: text/plain
Date: Fri, 18 May 2007 08:39:33 -0700
Message-Id: <1179502773.20519.56.camel@imap.mvista.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 (2.8.3-2.fc6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2007-05-18 at 19:06 +0400, Sergei Shtylyov wrote:
> Daniel Walker wrote:
> 
> >>I haven't looked at all the new clock/timer code, is there any  
> >>utility in having support for more than one clock source?
> 
> > There is if the main clocksource has some issues where it can't be used.
> 
>     You mean, having more than one clocksource is *useful* in this case?

Yes.

>     Well, the decrementer frequency may change, at least in theory (if the bus 
> clock changes).

Does that happen very often?

Daniel

