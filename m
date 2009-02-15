Return-Path: <linux-kernel-owner+w=401wt.eu-S1754634AbZBOW4X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754634AbZBOW4X (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Feb 2009 17:56:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753251AbZBOW4K
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Feb 2009 17:56:10 -0500
Received: from www.crouse-house.com ([199.45.160.146]:43303 "EHLO
	mail.crouse-house.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752960AbZBOW4J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Feb 2009 17:56:09 -0500
X-Greylist: delayed 498 seconds by postgrey-1.27 at vger.kernel.org; Sun, 15 Feb 2009 17:56:09 EST
Message-ID: <49989B96.7010604@cosmicpenguin.net>
Date: Sun, 15 Feb 2009 15:47:50 -0700
From: Jordan Crouse <jordan@cosmicpenguin.net>
Reply-To: jordan@cosmicpenguin.net
User-Agent: Thunderbird 2.0.0.18 (X11/20081125)
MIME-Version: 1.0
To: Alessandro Zummo <azummo-lists@towertech.it>
CC: David Brownell <david-b@pacbell.net>, linux-geode@lists.infradead.org,
       dilinger@queued.net, dsaxena@laptop.org,
       =?ISO-8859-1?Q?Martin-=C9ric_Racine?= <q-funk@iki.fi>,
       lkml <linux-kernel@vger.kernel.org>, rpurdie@rpsys.net,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH] AMD Geode CS5535/5536 GPIO driver
References: <20090205161007.4d121cbf@i1501.lan.towertech.it>	<200902051612.20475.david-b@pacbell.net> <20090206101618.7102e46b@i1501.lan.towertech.it>
In-Reply-To: <20090206101618.7102e46b@i1501.lan.towertech.it>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alessandro Zummo wrote:
> On Thu, 5 Feb 2009 16:12:20 -0800
> David Brownell <david-b@pacbell.net> wrote:
> 
>> Unless this hardware misbehaves when both output and input
>> modes are enabled (e.g. in the window between those two calls),
>> I'd suggest just not clearing INPUT_ENABLE.  It's legit to
>> ask for the *actual* value of an output line, e.g. for when
>> it uses open drain mode.  (And didn't this hardware have an
>> option for open drain GPIO signaling?)
> 
>  seems reasonable,
>  I'll let the Geode people decide what to do here... 

Sorry, I'm just getting around to answering this. I don't recall any 
situation where the hardware would mis-behave, but you never know with 
this bit of silicon.

I say leave them both on, and revisit it if you get flamed.

Jordan




