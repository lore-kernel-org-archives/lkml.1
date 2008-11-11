Return-Path: <linux-kernel-owner+w=401wt.eu-S1754099AbYKKRde@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754099AbYKKRde (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2008 12:33:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751594AbYKKRd0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Nov 2008 12:33:26 -0500
Received: from vms173003pub.verizon.net ([206.46.173.3]:46834 "EHLO
	vms173003pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751144AbYKKRdZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2008 12:33:25 -0500
Date: Tue, 11 Nov 2008 12:33:06 -0500 (EST)
From: Len Brown <lenb@kernel.org>
Subject: Re: Bootup time regression from 2.6.27 to 2.6.28-rc3+
In-reply-to: <1226324750.4212.2.camel@hidalgo>
X-X-Sender: lenb@localhost.localdomain
To: Yves-Alexis Perez <corsac@debian.org>
Cc: Arjan van de Ven <arjan@infradead.org>,
       Lukas Hejtmanek <xhejtman@ics.muni.cz>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Marcin Slusarz <marcin.slusarz@gmail.com>, linux-kernel@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>, torvalds@linux-foundation.org,
       elendil@planet.nl
Message-id: <alpine.LFD.2.00.0811111230270.4480@localhost.localdomain>
MIME-version: 1.0
Content-type: TEXT/PLAIN; charset=US-ASCII
References: <20081104173300.GF6134@ics.muni.cz> <20081109105159.GA5867@joi>
 <20081109113304.GE4353@ics.muni.cz> <200811091424.10943.rjw@sisk.pl>
 <20081109200918.GA4361@ics.muni.cz> <20081109122835.10f410fa@infradead.org>
 <20081109203432.GB4361@ics.muni.cz> <20081109132438.5d81cd74@infradead.org>
 <1226324750.4212.2.camel@hidalgo>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> Under 2.6.28-rc4 the bootime seems ok, but I have way too much powertop
> wakups:

I see the same on a T61.
There was a boot-stall in -rc3, now gone in rc4. 
(as of today's top of tree: 3ad4f597058301c97f362e500a32f63f5c950a45)

However, I'm seeing over 800 "extra timer interrupt" per second when idle

-Len
