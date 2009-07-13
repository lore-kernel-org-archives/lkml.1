Return-Path: <linux-kernel-owner+w=401wt.eu-S1754569AbZGMHHa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754569AbZGMHHa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jul 2009 03:07:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753661AbZGMHH2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Jul 2009 03:07:28 -0400
Received: from cantor2.suse.de ([195.135.220.15]:43800 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750934AbZGMHH1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jul 2009 03:07:27 -0400
Date: Mon, 13 Jul 2009 09:07:22 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
X-X-Sender: jkosina@wotan.suse.de
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Andi Kleen <andi@firstfloor.org>, rjw@sisk.pl, linux-input@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [regression] 2.6.30 leaking keys on console switch
In-Reply-To: <20090713040528.GH10819@dtor-d630.eng.vmware.com>
Message-ID: <alpine.LNX.2.00.0907130906140.10476@wotan.suse.de>
References: <87eiss7uhb.fsf@basil.nowhere.org> <alpine.LNX.2.00.0907071048210.4994@wotan.suse.de> <20090708065325.GE3309@dtor-d630.eng.vmware.com> <alpine.LNX.2.00.0907091319480.27327@wotan.suse.de> <20090713040528.GH10819@dtor-d630.eng.vmware.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 12 Jul 2009, Dmitry Torokhov wrote:

> > > > Are you seeing with a specific keyboard type(s), or is this a 
> > > > general problem? Could you confirm whether it is specific either 
> > > > to PS2 or USB keyboards only, or it does happen for both?
> > > Can't think of any input chnages in this timeftrame that would cause
> > > such effect. Maybe TTY changes?
> > By the way, if I understand it correctly, Andi is able to see the very 
> > same effect even inside X, so tty can be possibly ruled out, right?
> Umm, doesn't SuSE still use legacy keyboard driver instead of evdev in
> X? Thomas mentioned recently it still did...

It does.

If I understand Andi's problem though, he is able to trigger the problem 
even solely on console, with X not being involved at all.

-- 
Jiri Kosina
SUSE Labs
