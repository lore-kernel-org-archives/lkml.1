Return-Path: <linux-kernel-owner+w=401wt.eu-S1752616AbZLIFkF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752616AbZLIFkF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Dec 2009 00:40:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751583AbZLIFj6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Dec 2009 00:39:58 -0500
Received: from mx1.redhat.com ([209.132.183.28]:18788 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751375AbZLIFj5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Dec 2009 00:39:57 -0500
Subject: Re: [BISECTED] drm: random hang since 620f378 "drm: prune modes
 when ..."
From: Dave Airlie <airlied@redhat.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Adam Jackson <ajax@redhat.com>, linux-kernel@vger.kernel.org,
       dri-devel@lists.sourceforge.net, keithp@keithp.com, eric@anholt.net,
       jbarnes@virtuousgeek.org
In-Reply-To: <200912090007.45545.arnd@arndb.de>
References: <200912071830.14697.arnd@arndb.de>
	 <200912082259.48715.arnd@arndb.de> <1260310432.12969.0.camel@t60prh>
	 <200912090007.45545.arnd@arndb.de>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 09 Dec 2009 15:38:07 +1000
Message-Id: <1260337087.3658.1.camel@t60prh>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-12-09 at 00:07 +0100, Arnd Bergmann wrote:
> On Tuesday 08 December 2009, Dave Airlie wrote:
> > > 
> > > Sorry for blaming the wrong patch, especially if it already caused a lot 
> > > of work. I'll try blaming ec2a4c3fdc8 "drm/i915: get the bridge device
> > > once" now, that is the next-best candidate that my bisection pointed to,
> > > but I'll do more rigorous testing.
> 
> It just crashed again with both 620f378 and ec2a4c3fdc8 reverted as well, 
> after about an hour of uptime.
> 
> > Btw is this just a laptop with no monitor plugged in?
> > 
> > just want to rule out the patch you mentioned for any sort of memory
> > corruption.
> 
> It's a desktop machine with three outputs, Asus P5Q-EM mainboard.
> VGA is not connected at all, DVI has an open-ended cable on it, i.e. no
> screen on it. HDMI is connected through a cheap passive HDMI multiswitch
> to the DVI-D input of a Lenovo screen.


CC'ed the Intel ppl,

regression since 2.6.31 by the looks of it, bisection has found two
false positives so far.

Dave.

