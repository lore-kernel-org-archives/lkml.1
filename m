Return-Path: <linux-kernel-owner+w=401wt.eu-S1754036AbZBNWy7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754036AbZBNWy7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Feb 2009 17:54:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752668AbZBNWyu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Feb 2009 17:54:50 -0500
Received: from mx0.towertech.it ([213.215.222.73]:51438 "HELO mx0.towertech.it"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752231AbZBNWyt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Feb 2009 17:54:49 -0500
Date: Sat, 14 Feb 2009 23:54:46 +0100
From: Alessandro Zummo <azummo-lists@towertech.it>
To: Andres Salomon <dilinger@queued.net>
Cc: jordan@cosmicpenguin.net, "David Brownell" <david-b@pacbell.net>,
       linux-geode@lists.infradead.org, dsaxena@laptop.org,
       "=?ISO-8859-1?Q?Mart?= =?ISO-8859-1?Q?in-=C9ric?= Racine" 
	<q-funk@iki.fi>,
       lkml <linux-kernel@vger.kernel.org>, rpurdie@rpsys.net,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH] AMD Geode CS5535/5536 GPIO driver
Message-ID: <20090214235446.2d46bc4a@i1501.lan.towertech.it>
In-Reply-To: <20090214173811.4d9a0957@ephemeral>
References: <20090205161007.4d121cbf@i1501.lan.towertech.it>
	<20090214152719.1baf52cc@ephemeral>
	<20090214230235.5a29487f@i1501.lan.towertech.it>
	<20090214173811.4d9a0957@ephemeral>
Organization: Tower Technologies
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.11; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 14 Feb 2009 17:38:11 -0500
Andres Salomon <dilinger@queued.net> wrote:

> >  I've been suggested to move it within geode_32. the driver is
> > probably pretty geode specific anyhow.
> > 
> 
> 
> If the whole point is to make the cs553x GPIO stuff portable (and to use
> the portable API), then what's the point if we know that it can/will
> be used by non-x86 platforms?
> 
> We already have a cs553x GPIO char device, a geode GPIO lib that
> works (but has flaws).. I'm all for creating The One True CS553x GPIO
> API, but I'd consider something that's geode (and x86)-specific to be
> a waste of time.

 GPIO lib is generic enough for most archs to use it and my driver uses it
 Anyway I did my homework.. I will submit a revision with the latest suggested
 changes... if accepted I will be happy to maintain it.
 


-- 

 Best regards,

 Alessandro Zummo,
  Tower Technologies - Torino, Italy

  http://www.towertech.it

