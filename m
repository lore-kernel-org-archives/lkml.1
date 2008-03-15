Return-Path: <linux-kernel-owner+w=401wt.eu-S1752476AbYCODci@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752476AbYCODci (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Mar 2008 23:32:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751640AbYCODca
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Mar 2008 23:32:30 -0400
Received: from scrub.xs4all.nl ([194.109.195.176]:42508 "EHLO scrub.xs4all.nl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751508AbYCODca (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Mar 2008 23:32:30 -0400
Date: Sat, 15 Mar 2008 04:32:27 +0100 (CET)
From: Roman Zippel <zippel@linux-m68k.org>
X-X-Sender: roman@scrub.home
To: john stultz <johnstul@us.ibm.com>
cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Subject: Re: [PATCH 7/8] Remove current_tick_length()
In-Reply-To: <1205548860.6122.55.camel@localhost.localdomain>
Message-ID: <Pine.LNX.4.64.0803150429500.1791@scrub.home>
References: <20080314184001.695807682@linux-m68k.org> 
 <20080314195737.153531685@linux-m68k.org> <1205548860.6122.55.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Fri, 14 Mar 2008, john stultz wrote:

> On Fri, 2008-03-14 at 19:40 +0100, zippel@linux-m68k.org wrote:
> > plain text document attachment (tick_length)
> > current_tick_length used to do a little more, but now it just returns
> > tick_length, which we can also access directly at the few places, where
> > it's needed.
> > 
> > Signed-off-by: Roman Zippel <zippel@linux-m68k.org>
> 
> Hrm. I'm not sure I like using a global variable instead of using an
> accessor function. At least with the accessor function folks couldn't
> just tweak the value outside ntp as easily.

Why would someone do something silly like this?

> Is there any additional rational for this change?

Useless bloat?

bye, Roman
