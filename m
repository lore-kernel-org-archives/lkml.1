Return-Path: <linux-kernel-owner+w=401wt.eu-S1752786AbYCODXU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752786AbYCODXU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Mar 2008 23:23:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751335AbYCODXL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Mar 2008 23:23:11 -0400
Received: from scrub.xs4all.nl ([194.109.195.176]:54425 "EHLO scrub.xs4all.nl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751008AbYCODXK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Mar 2008 23:23:10 -0400
Date: Sat, 15 Mar 2008 04:21:34 +0100 (CET)
From: Roman Zippel <zippel@linux-m68k.org>
X-X-Sender: roman@scrub.home
To: john stultz <johnstul@us.ibm.com>
cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH 1/8] cleanup ntp.c
In-Reply-To: <1205526659.6122.11.camel@localhost.localdomain>
Message-ID: <Pine.LNX.4.64.0803150418560.1791@scrub.home>
References: <20080314184001.695807682@linux-m68k.org> 
 <20080314195736.792798828@linux-m68k.org> <1205526659.6122.11.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Fri, 14 Mar 2008, john stultz wrote:

> Ah crud. Ingo sent very similar changes to me a few weeks ago, and I've
> been too pinched for time to test and send them out. 
> 
> I'll spend some time today to layer his fixes as well as my own cleanups
> on top. 

What fixes?

> > +static void ntp_update_offset(long offset)
> > +{
> > +	long mtemp;
> 
> Could we change this to a more descriptive name?
> 
> Maybe last_update_interval?

It's a local variable, so IMO temp works just fine, it's not that 
difficult to figure out how it's used (e.g. it's like using loop_index 
instead of i).

bye, Roman
