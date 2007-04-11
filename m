Return-Path: <linux-kernel-owner+w=401wt.eu-S1753186AbXDKRaF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753186AbXDKRaF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2007 13:30:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753214AbXDKRaF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Apr 2007 13:30:05 -0400
Received: from pasmtpb.tele.dk ([80.160.77.98]:42891 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753186AbXDKRaD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2007 13:30:03 -0400
Date: Wed, 11 Apr 2007 19:30:48 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: Jan Engelhardt <jengelh@linux01.gwdg.de>, Al Boldi <a1426z@gawab.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/30] Use menuconfig objects
Message-ID: <20070411173048.GA28211@uranus.ravnborg.org>
References: <200704110112.39425.a1426z@gawab.com> <Pine.LNX.4.61.0704110026250.32056@yvahk01.tjqt.qr> <200704110742.38727.a1426z@gawab.com> <Pine.LNX.4.61.0704110937060.32056@yvahk01.tjqt.qr> <461D1291.2060703@s5r6.in-berlin.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <461D1291.2060703@s5r6.in-berlin.de>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 11, 2007 at 06:53:37PM +0200, Stefan Richter wrote:
> Jan Engelhardt wrote:
> > On Apr 11 2007 07:42, Al Boldi wrote:
> >>Also, I don't think it's necessary to touch any of the "depends on"; keep 
> >>them as is, as they don't hurt staying that way, and may actually be 
> >>necessary under certain circumstances.  (see EMBEDDED)
> > 
> > Simplifying the depends lines is a good thing IMO.
> 
> If explicit dependency statements are replaced by if--endif blocks, does
> this count as simplification?
Applied with some common sense - yes.
if --endif blocks has been used in several places to make dependencies consistent.
When cleaning up the net part I recall a few places where the explicit dependency
was missing causing 1) dependencies to be wrong and 2) caused indention in menu-
config to be wrong.

But yet agin do not go and replace all dependencies with if--endif blocks.
They shall be used with some good taste.


	Sam
