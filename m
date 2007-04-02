Return-Path: <linux-kernel-owner+w=401wt.eu-S933877AbXDBRRn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933877AbXDBRRn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Apr 2007 13:17:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933875AbXDBRRm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Apr 2007 13:17:42 -0400
Received: from rwcrmhc15.comcast.net ([204.127.192.85]:41506 "EHLO
	rwcrmhc15.comcast.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933648AbXDBRRl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Apr 2007 13:17:41 -0400
From: dasperry@comcast.net (dave_sperry@ieee.org)
To: Ingo Molnar <mingo@elte.hu>
Cc: Dave Sperry <dave_sperry@ieee.org>, linux-rt-users@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: Poor UDP performance using 2.6.21-rc5-rt5
Date: Mon, 02 Apr 2007 17:17:38 +0000
Message-Id: <040220071717.18767.46113AB20004ED5D0000494F2200745672979D9D0A9F9C0E0B@comcast.net>
X-Mailer: AT&T Message Center Version 1 (Oct  4 2006)
X-Authenticated-Sender: ZGFzcGVycnlAY29tY2FzdC5uZXQ=
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


 -------------- Original message ----------------------
From: Ingo Molnar <mingo@elte.hu>
> 
> * dave_sperry@ieee.org <dasperry@comcast.net> wrote:
> 
> > Thanks for all the input Ingo, Here's a list of all the permutations 
> > I've tried:
> 
> one thing i noticed is that cyclesoak interferes with the netperf 
> workload. This is quite surprising. 'top' and 'vmstat' output is 
> reliable on -rt, and the overhead goes down if i stop cyclesoak.
> 
> 	Ingo

I see the same effect 

setup                    Thruput      CPU% 
cyclesoak on
2.6.21-rc5-rt8           937          74%
   netperf @51
   hardirq @50
   softirq @50

cyclesoak off
2.6.21-rc5-rt8           938          65%
   netperf @51
   hardirq @50
   softirq @50


Dave
