Return-Path: <linux-kernel-owner+w=401wt.eu-S1754717AbZGPJYL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754717AbZGPJYL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jul 2009 05:24:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754340AbZGPJYL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Jul 2009 05:24:11 -0400
Received: from one.firstfloor.org ([213.235.205.2]:46318 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754294AbZGPJYK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jul 2009 05:24:10 -0400
Date: Thu, 16 Jul 2009 11:24:06 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Jiri Kosina <jkosina@suse.cz>
Cc: Andi Kleen <andi@firstfloor.org>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>, rjw@sisk.pl,
       linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
       Mike Galbraith <efault@gmx.de>
Subject: Re: [regression] 2.6.30 leaking keys on console switch
Message-ID: <20090716092406.GC8046@one.firstfloor.org>
References: <87eiss7uhb.fsf@basil.nowhere.org> <alpine.LNX.2.00.0907071048210.4994@wotan.suse.de> <20090708065325.GE3309@dtor-d630.eng.vmware.com> <alpine.LNX.2.00.0907091319480.27327@wotan.suse.de> <20090713040528.GH10819@dtor-d630.eng.vmware.com> <alpine.LNX.2.00.0907130906140.10476@wotan.suse.de> <20090713082527.GA26638@basil.fritz.box> <alpine.LNX.2.00.0907161057120.11648@wotan.suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LNX.2.00.0907161057120.11648@wotan.suse.de>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Andi, are you absolutely sure that this appeared between .29 and .30 for 
> you?

I only noticed it after the .30 update at least.

> And if so, is there any chance you could try bisecting it?

Ok.

> 
> (*) have been on virtual desktop where firefox was running, switched to 
> console using Ctrl-Alt-F1, and switched back to X using F7. Firefox then 
> popped up some dialog about configuring some feature that is triggered by 
> pressing F7/AltF7, or whatever. Is that what you are seeing?

Yes, I typically see it with the help screen. It also happens with
other applications, not just firefox.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
