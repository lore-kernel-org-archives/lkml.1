Return-Path: <linux-kernel-owner+w=401wt.eu-S1754529AbZGPJCy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754529AbZGPJCy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jul 2009 05:02:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754156AbZGPJCx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Jul 2009 05:02:53 -0400
Received: from cantor2.suse.de ([195.135.220.15]:35681 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754082AbZGPJCw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jul 2009 05:02:52 -0400
Date: Thu, 16 Jul 2009 11:02:47 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
X-X-Sender: jkosina@wotan.suse.de
To: Andi Kleen <andi@firstfloor.org>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>, rjw@sisk.pl,
       linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
       Mike Galbraith <efault@gmx.de>
Subject: Re: [regression] 2.6.30 leaking keys on console switch
In-Reply-To: <20090713082527.GA26638@basil.fritz.box>
Message-ID: <alpine.LNX.2.00.0907161057120.11648@wotan.suse.de>
References: <87eiss7uhb.fsf@basil.nowhere.org> <alpine.LNX.2.00.0907071048210.4994@wotan.suse.de> <20090708065325.GE3309@dtor-d630.eng.vmware.com> <alpine.LNX.2.00.0907091319480.27327@wotan.suse.de> <20090713040528.GH10819@dtor-d630.eng.vmware.com>
 <alpine.LNX.2.00.0907130906140.10476@wotan.suse.de> <20090713082527.GA26638@basil.fritz.box>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 13 Jul 2009, Andi Kleen wrote:

> > > > > > Are you seeing with a specific keyboard type(s), or is this a 
> > > > > > general problem? Could you confirm whether it is specific either 
> > > > > > to PS2 or USB keyboards only, or it does happen for both?
> > > > > Can't think of any input chnages in this timeftrame that would cause
> > > > > such effect. Maybe TTY changes?
> > > > By the way, if I understand it correctly, Andi is able to see the very 
> > > > same effect even inside X, so tty can be possibly ruled out, right?
> > > Umm, doesn't SuSE still use legacy keyboard driver instead of evdev in
> > > X? Thomas mentioned recently it still did...
> > 
> > It does.
> > 
> > If I understand Andi's problem though, he is able to trigger the problem 
> > even solely on console, with X not being involved at all.
> 
> Sorry, I tried again and I can't reproduce the console misbehaviour anymore.
> Only see it in X.  I thought I had seen it in links resetting to the first
> page, but I don't see that now.

So by total coincidence I reproduced exactly this behavior (*) (while not 
trying to do so) on system running 2.6.24-rc3, with PS/2 keyboard. 

Andi, are you absolutely sure that this appeared between .29 and .30 for 
you?

And if so, is there any chance you could try bisecting it?

(*) have been on virtual desktop where firefox was running, switched to 
console using Ctrl-Alt-F1, and switched back to X using F7. Firefox then 
popped up some dialog about configuring some feature that is triggered by 
pressing F7/AltF7, or whatever. Is that what you are seeing?

-- 
Jiri Kosina
SUSE Labs
