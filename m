Return-Path: <linux-kernel-owner+w=401wt.eu-S1755545AbZGIUD2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755545AbZGIUD2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jul 2009 16:03:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754030AbZGIUDU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Jul 2009 16:03:20 -0400
Received: from one.firstfloor.org ([213.235.205.2]:43274 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753975AbZGIUDU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jul 2009 16:03:20 -0400
Date: Thu, 9 Jul 2009 22:03:18 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Jiri Kosina <jkosina@suse.cz>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       Andi Kleen <andi@firstfloor.org>, rjw@sisk.pl,
       linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [regression] 2.6.30 leaking keys on console switch
Message-ID: <20090709200318.GB16355@basil.fritz.box>
References: <87eiss7uhb.fsf@basil.nowhere.org> <alpine.LNX.2.00.0907071048210.4994@wotan.suse.de> <20090708065325.GE3309@dtor-d630.eng.vmware.com> <alpine.LNX.2.00.0907091319480.27327@wotan.suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LNX.2.00.0907091319480.27327@wotan.suse.de>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 09, 2009 at 01:20:56PM +0200, Jiri Kosina wrote:
> On Tue, 7 Jul 2009, Dmitry Torokhov wrote:
> 
> > > Are you seeing with a specific keyboard type(s), or is this a general 
> > > problem? Could you confirm whether it is specific either to PS2 or USB 
> > > keyboards only, or it does happen for both?
> > Can't think of any input chnages in this timeftrame that would cause
> > such effect. Maybe TTY changes?
> 
> By the way, if I understand it correctly, Andi is able to see the very 
> same effect even inside X, so tty can be possibly ruled out, right?
> 
> Still, I don't see the leaking F key in the evtest output (see the mail 
> from yesterday), which is quite puzzling.

Everything quite puzzling.

I find it puzzling that people cannot reproduce this. I see this on two
quite different systems (different keyboard, system). Does really nobody
else see it?

I checked now and it happens with both when I switch with Alt-Fx
and Ctrl-Alt-Fx (at least on SUSE the later works from the consoles
too, so i usually use that)

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
