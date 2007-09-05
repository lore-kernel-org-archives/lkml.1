Return-Path: <linux-kernel-owner+w=401wt.eu-S1757924AbXIEXCc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757924AbXIEXCc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Sep 2007 19:02:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757786AbXIEXAR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Sep 2007 19:00:17 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:33149 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758207AbXIEXAO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Sep 2007 19:00:14 -0400
Date: Thu, 6 Sep 2007 00:00:47 +0100
From: Stephen Hemminger <shemminger@linux-foundation.org>
To: Kyle Rose <krose@krose.org>
Cc: James Corey <ploversegg@yahoo.com>, Rob Sims <lkml-z@robsims.com>,
       Adrian Bunk <bunk@stusta.de>, linux-kernel@vger.kernel.org
Subject: Re: sk98lin for 2.6.23-rc1
Message-ID: <20070906000047.5c4f7d11@oldman>
In-Reply-To: <46DF19FB.3020702@krose.org>
References: <782111.42803.qm@web90413.mail.mud.yahoo.com>
	<46DF19FB.3020702@krose.org>
X-Mailer: Sylpheed-Claws 2.6.0 (GTK+ 2.10.11; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 05 Sep 2007 17:04:59 -0400
Kyle Rose <krose@krose.org> wrote:

> 
> > However, it really DOES lock up under load. I even 
> > tried 2.6.23-rc4 and the absolute latest version of
> > the
> > driver and it still locks up, as in
> >   
> Yich.  I'm glad I'm still using sk98lin on my unmanned colo box.
> 
> Kyle
> 

Great for you, when I was testing sk98lin crashed my machine on
overnight stress run. My intuition is that there is a bug in sk98lin
on Yukon EC-U chips (those without ram buffer) and a hardware
problem on Yukon XL chips (those with ram buffer) and the sky2
driver doesn't have workaround for getting the ram buffer stuck (yet).

I don't like putting workarounds in for problems I can't reproduce.
After KS, I'll rerun more stress tests on all the chip flavors
and see if the hang is reproducible.
