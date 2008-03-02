Return-Path: <linux-kernel-owner+w=401wt.eu-S1753613AbYCBEEG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753613AbYCBEEG (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Mar 2008 23:04:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751754AbYCBEDy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 1 Mar 2008 23:03:54 -0500
Received: from scrub.xs4all.nl ([194.109.195.176]:34705 "EHLO scrub.xs4all.nl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750797AbYCBEDx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Mar 2008 23:03:53 -0500
Date: Sun, 2 Mar 2008 05:03:51 +0100 (CET)
From: Roman Zippel <zippel@linux-m68k.org>
X-X-Sender: roman@scrub.home
To: john stultz <johnstul@us.ibm.com>
cc: lkml <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH] Remove obsolete CLOCK_TICK_ADJUST
In-Reply-To: <1204326690.6136.15.camel@localhost.localdomain>
Message-ID: <Pine.LNX.4.64.0803020420120.2723@scrub.home>
References: <1201142334.6383.40.camel@localhost.localdomain> 
 <Pine.LNX.4.64.0801251349120.17507@scrub.home>  <1201573686.6766.13.camel@localhost>
  <Pine.LNX.4.64.0801290439480.17507@scrub.home>  <1201659263.6766.40.camel@localhost>
  <Pine.LNX.4.64.0801310251090.17507@scrub.home>  <1201745776.6195.14.camel@localhost.localdomain>
  <Pine.LNX.4.64.0801310404480.17507@scrub.home>  <1201914175.6216.46.camel@jstultz-laptop>
  <Pine.LNX.4.64.0802081718040.3378@scrub.home>  <1202523452.6174.45.camel@localhost.localdomain>
  <Pine.LNX.4.64.0802101917030.3378@scrub.home>  <1202774999.5984.106.camel@localhost>
  <Pine.LNX.4.64.0802120335170.3378@scrub.home>  <1202963796.6195.141.camel@localhost.localdomain>
  <Pine.LNX.4.64.0802150436300.1822@scrub.home>  <1203382940.5984.242.camel@localhost>
  <Pine.LNX.4.64.0802190219360.2723@scrub.home>  <1203472250.6123.98.camel@localhost>
  <Pine.LNX.4.64.0802200348230.2723@scrub.home>  <1203647951.6150.80.camel@localhost.localdomain>
  <Pine.LNX.4.64.0802290547320.2723@scrub.home> <1204326690.6136.15.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Fri, 29 Feb 2008, john stultz wrote:

> I'm still not happy about the granularity issue (or non-issue in your
> mind),

It's an issue, but it's not as big as you seem to think.
The error drift should be small and 150ppm isn't too good, but it isn't an 
error to be too worried about.
As the alpha example shows, in the past we already tried to reduce this 
error anyway, in this case by choosing an appropriate HZ value.

> but both my version and your version of the solution are pretty
> close at this point and I can rework my difference on-top of this patch
> without much trouble.

Practically it should be enough to just check the base drift and print a 
warning message, as it suggest to be more likely a configuration error.

bye, Roman
