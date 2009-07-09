Return-Path: <linux-kernel-owner+w=401wt.eu-S1755861AbZGIV63@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755861AbZGIV63 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jul 2009 17:58:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754577AbZGIV6W
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Jul 2009 17:58:22 -0400
Received: from cantor.suse.de ([195.135.220.2]:39528 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754095AbZGIV6V (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jul 2009 17:58:21 -0400
Date: Thu, 9 Jul 2009 23:58:17 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
X-X-Sender: jkosina@wotan.suse.de
To: Andi Kleen <andi@firstfloor.org>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>, rjw@sisk.pl,
       linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [regression] 2.6.30 leaking keys on console switch
In-Reply-To: <20090709200318.GB16355@basil.fritz.box>
Message-ID: <alpine.LNX.2.00.0907092356250.27327@wotan.suse.de>
References: <87eiss7uhb.fsf@basil.nowhere.org> <alpine.LNX.2.00.0907071048210.4994@wotan.suse.de> <20090708065325.GE3309@dtor-d630.eng.vmware.com> <alpine.LNX.2.00.0907091319480.27327@wotan.suse.de> <20090709200318.GB16355@basil.fritz.box>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 9 Jul 2009, Andi Kleen wrote:

> > Umm, actually, Andi, could you verify whether reverting e7b5c1ef4d changes 
> > the behavior you are observing in any way?
> Tested that, no change unfortunately.

Is there any possibility to connect PS/2 keyboard to those systems, to see 
if it is specific to USB keyboards or whether it is rather generic input 
problem?

On Thu, 9 Jul 2009, Andi Kleen wrote:

> > By the way, if I understand it correctly, Andi is able to see the very 
> > same effect even inside X, so tty can be possibly ruled out, right?
> > 
> > Still, I don't see the leaking F key in the evtest output (see the mail 
> > from yesterday), which is quite puzzling.
> 
> Everything quite puzzling.
> 
> I find it puzzling that people cannot reproduce this. I see this on two
> quite different systems (different keyboard, system). Does really nobody
> else see it?

I really tried, and I don't. Could you please send me your config?

-- 
Jiri Kosina
SUSE Labs
