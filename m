Return-Path: <linux-kernel-owner+w=401wt.eu-S1754688AbZGMIZe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754688AbZGMIZe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jul 2009 04:25:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754339AbZGMIZd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Jul 2009 04:25:33 -0400
Received: from one.firstfloor.org ([213.235.205.2]:34612 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753302AbZGMIZc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jul 2009 04:25:32 -0400
Date: Mon, 13 Jul 2009 10:25:28 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Jiri Kosina <jkosina@suse.cz>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       Andi Kleen <andi@firstfloor.org>, rjw@sisk.pl,
       linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [regression] 2.6.30 leaking keys on console switch
Message-ID: <20090713082527.GA26638@basil.fritz.box>
References: <87eiss7uhb.fsf@basil.nowhere.org> <alpine.LNX.2.00.0907071048210.4994@wotan.suse.de> <20090708065325.GE3309@dtor-d630.eng.vmware.com> <alpine.LNX.2.00.0907091319480.27327@wotan.suse.de> <20090713040528.GH10819@dtor-d630.eng.vmware.com> <alpine.LNX.2.00.0907130906140.10476@wotan.suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LNX.2.00.0907130906140.10476@wotan.suse.de>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 13, 2009 at 09:07:22AM +0200, Jiri Kosina wrote:
> On Sun, 12 Jul 2009, Dmitry Torokhov wrote:
> 
> > > > > Are you seeing with a specific keyboard type(s), or is this a 
> > > > > general problem? Could you confirm whether it is specific either 
> > > > > to PS2 or USB keyboards only, or it does happen for both?
> > > > Can't think of any input chnages in this timeftrame that would cause
> > > > such effect. Maybe TTY changes?
> > > By the way, if I understand it correctly, Andi is able to see the very 
> > > same effect even inside X, so tty can be possibly ruled out, right?
> > Umm, doesn't SuSE still use legacy keyboard driver instead of evdev in
> > X? Thomas mentioned recently it still did...
> 
> It does.
> 
> If I understand Andi's problem though, he is able to trigger the problem 
> even solely on console, with X not being involved at all.

Sorry, I tried again and I can't reproduce the console misbehaviour anymore.
Only see it in X.  I thought I had seen it in links resetting to the first
page, but I don't see that now.

-andi

-- 
ak@linux.intel.com -- Speaking for myself only.
