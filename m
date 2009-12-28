Return-Path: <linux-kernel-owner+w=401wt.eu-S1751840AbZL1Gtm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751840AbZL1Gtm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Dec 2009 01:49:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751604AbZL1Gtl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Dec 2009 01:49:41 -0500
Received: from www84.your-server.de ([213.133.104.84]:58362 "EHLO
	www84.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751198AbZL1Gtk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Dec 2009 01:49:40 -0500
Subject: Re: [PATCH] [0/6] kfifo fixes/improvements
From: Stefani Seibold <stefani@seibold.net>
To: Andi Kleen <andi@firstfloor.org>
Cc: linux-kernel@vger.kernel.org, akpm@osdl.org
In-Reply-To: <20091227233816.GC2399@basil.fritz.box>
References: <200912271003.631128760@firstfloor.org>
	 <1261949800.25298.18.camel@wall-e>  <20091227233816.GC2399@basil.fritz.box>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Mon, 28 Dec 2009 07:49:33 +0100
Message-ID: <1261982973.31031.1.camel@wall-e>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: stefani@seibold.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Montag, den 28.12.2009, 00:38 +0100 schrieb Andi Kleen:
> On Sun, Dec 27, 2009 at 10:36:40PM +0100, Stefani Seibold wrote:
> > Am Sonntag, den 27.12.2009, 22:03 +0100 schrieb Andi Kleen:
> > > While porting some of my code to kfifo I found some issues, which
> > > are addressed in the following patch series.
> > > 
> > > Some of the problems were serious, particularly the non atomic kfifo_in()
> > > problem. That's probably 2.6.33 material at least. 
> > > 
> > 
> > I am not happy to see you to take over my project. Especial as most of
> 
> I'm just trying to use kfifos and ran into lots of issues that
> I fixed. Especially the non atomic kfifo_in problem seemed pretty fatal
> BTW.
> 
> > your fixes are part of my new macro based implementation. Have a look at
> > http://patchwork.kernel.org/patch/69093/
> 
> Even if that was merged the older interfaces still need to be fixed.
> 
> Or are you saying the new interface would completely replace kfifos?
> 

Yes, the new macro based kfifos does completely replace the current
kfifos. It would be great if you can review the code. There is all in.

Stefani


