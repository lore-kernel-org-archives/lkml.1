Return-Path: <linux-kernel-owner+w=401wt.eu-S1761664AbYD0RpX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761664AbYD0RpX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Apr 2008 13:45:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756602AbYD0RpM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Apr 2008 13:45:12 -0400
Received: from fmmailgate05.web.de ([217.72.192.243]:39833 "EHLO
	fmmailgate05.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755770AbYD0RpK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Apr 2008 13:45:10 -0400
Date: Sun, 27 Apr 2008 19:45:07 +0200
Message-Id: <256077993@web.de>
MIME-Version: 1.0
From: devzero@web.de
To: linux-kernel@vger.kernel.org
Cc: jengelh@computergmbh.de, lkml@rtr.ca, tvrtko@ursulin.net
Subject: Re: Western Digital GreenPower drives and Linux
Organization: http://freemail.web.de/
X-Provags-Id: V01U2FsdGVkX1/g12gU8SPBcBg9Ab4srK5pHStHobzr7+pYHTvC5nozSYeFc
 Z/8vLNa4shoDUjrUqbgLdZTPBeKgrSoT3h9IG4j00eJO2I5HOQ=
Content-Type: text/plain; charset=iso-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

on a second system , my wd drive shows this values:

  9 Power_On_Hours          0x0032   099   099   000    Old_age   Always       -       853
193 Load_Cycle_Count        0x0032   170   170   000    Old_age   Always       -       90960

absolutely scary.....

meanwhile, i got wdidle3 from WD support and set it to 25secs (factory support seems to be at 8 secs) - but still waiting for an answer if this is a bug or not. 

i`m really wondering why support is so quiet here....
anybody got a response from support about this? 

will take a look how the drive behaves with windows......maybe things look different there.



List:       linux-kernel
Subject:    Re: Western Digital GreenPower drives and Linux
From:       "Tvrtko A. Ursulin" <tvrtko () ursulin ! net>
Date:       2008-04-16 19:46:33
Message-ID: 200804162046.33245.tvrtko () ursulin ! net
[Download message RAW]

On Wednesday 16 April 2008 12:40:14 Helge Hafting wrote:
> Tvrtko A. Ursulin wrote:
> > 9 Power_On_Hours       0x0032 100 100 000 Old_age Always  - 66
> > 193 Load_Cycle_Count 0x0032 197 197 000 Old_age  Always  - 10233
> >
> > At this rate the disk would reach it's design limit for load/unload
> > cycles in around 80 days. Not good - so I implemented a lame workaround
> > of keeping disk busy every couple of seconds - hopefully that won't kill
> > it sooner that unloads would..
>
> Yuck, how stupid!
> But the solution is simple. Make sure to get a warranty of much more
> than 80 days. Use RAID-1 (or backup often).
> Just let those disks destroy themselves (they _are_ faulty) and
> get new ones all the time.  As long as they make them this stupid, you
> won't have to buy new disks again. Free warranty replacements forever.

:) I am not so enthusiastic about fiddling with my NAS box every couple of 
months.

> To be a bit more constructive, tell them about this strategy. Perhaps
> they get
> busy fixing the firmware?

I have suggested exactly what you say - unfortunately the conversation has 
gone cold since. Maybe they are busy already. :)

Tvrtko

_________________________________________________________________________
In 5 Schritten zur eigenen Homepage. Jetzt Domain sichern und gestalten! 
Nur 3,99 EUR/Monat! http://www.maildomain.web.de/?mc=021114

