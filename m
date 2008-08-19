Return-Path: <linux-kernel-owner+w=401wt.eu-S1756492AbYHSR4Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756492AbYHSR4Y (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2008 13:56:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754511AbYHSR4H
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Aug 2008 13:56:07 -0400
Received: from hs-out-0708.google.com ([64.233.178.242]:3974 "EHLO
	hs-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752938AbYHSR4D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2008 13:56:03 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=pHkzFIf+tI8jpW9vxc3Zu0ewDiGVcAn4zheqJQhk8P5feYfFAtkRF5VI8XAzLleuI8
         rdrXesQwVpC7SPbw8u3wztFHjB5UbL3WDOtKsc/coaIAkuk1XHdTA8G8aW+Q790H/Ch2
         IDFjNI7BlnNwiov9Mv3idlCkHLQQ8iEuZD4K4=
Date: Tue, 19 Aug 2008 13:55:58 -0400
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Jiri Kosina <jkosina@suse.cz>
Cc: Randy Dunlap <rdunlap@xenotime.net>, Aivils Stoss <aivils@latnet.lv>,
       stern@rowland.harvard.edu, lud <linux-usb@vger.kernel.org>,
       Samuel Thibault <samuel.thibault@ens-lyon.org>,
       linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
       linuxconsole-dev@lists.sourceforge.net
Subject: Re: PROBLEM: USB keyboards works only 4 per PC host port
Message-ID: <20080819135447.ZZRA012@mailhub.coreip.homeip.net>
References: <200808080702.24969.aivils@latnet.lv> <200808181642.49489.aivils@latnet.lv> <20080818081432.782d9632.rdunlap@xenotime.net> <200808191527.06945.aivils@latnet.lv> <20080819081936.37fef673.rdunlap@xenotime.net> <alpine.LNX.1.10.0808191721560.18058@jikos.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LNX.1.10.0808191721560.18058@jikos.suse.cz>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 19, 2008 at 05:23:07PM +0200, Jiri Kosina wrote:
> On Tue, 19 Aug 2008, Randy Dunlap wrote:
> 
> > > 2.6.22-1-mepis-smp
> > > Quite stable. Have oops sometime inside evdev. Support up to 16 
> > > USB keyboards, where 4 hubs are plugged into PC and 4 keyboards on
> > > each hub. Any hub cascade support only 4 keyboards, where 5th or more
> > > is registered but don't send input events. Oops inside evdev , when
> > > USB keyboard unplugged. No slow down even all USB keyboards does
> > > not work properly. My be this one support more than 16 keyboards, but
> > > i don't have PC USB ports enough.
> > Has the evdev oops been reported and/or fixed? I think that we would 
> > prefer to fix that soonish.
> 
> We haven't seen the respective oops yet, or have I missed it?
> 
> I'd bet it is fixed in newer kernels by patches that introduce proper 
> locking into evdev code.
> 

If evdev (or any other part of the input sybsystem) still oopses in
2.6.26 and 2.6.27 I would like to see that oops very much.

-- 
Dmitry
