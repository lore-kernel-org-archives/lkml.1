Return-Path: <linux-kernel-owner+w=401wt.eu-S1755558AbYIHT4F@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755558AbYIHT4F (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2008 15:56:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754891AbYIHTzs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Sep 2008 15:55:48 -0400
Received: from iabervon.org ([66.92.72.58]:60096 "EHLO iabervon.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754597AbYIHTzr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2008 15:55:47 -0400
Date: Mon, 8 Sep 2008 15:55:44 -0400 (EDT)
From: Daniel Barkalow <barkalow@iabervon.org>
To: "Renato S. Yamane" <yamane@diamondcut.com.br>
cc: Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       Jiri Kosina <jkosina@suse.cz>, linux-kernel@vger.kernel.org,
       Christopher Desjardins <cddesjardins@gmail.com>
Subject: Re: Lenovo 3000 N100 i8042 problems
In-Reply-To: <48C57FDE.2010306@diamondcut.com.br>
Message-ID: <alpine.LNX.1.00.0809081544410.19665@iabervon.org>
References: <alpine.LNX.1.00.0808240148580.19665@iabervon.org> <Pine.LNX.4.64.0809020120130.29111@twin.jikos.cz> <alpine.LNX.1.00.0809012014280.19665@iabervon.org> <alpine.LNX.1.10.0809021121410.23448@jikos.suse.cz> <20080902083940.ZZRA012@mailhub.coreip.homeip.net>
 <alpine.LNX.1.10.0809031349081.23448@jikos.suse.cz> <20080903101947.ZZRA012@mailhub.coreip.homeip.net> <20080903213258.GC14620@khazad-dum.debian.net> <48C57FDE.2010306@diamondcut.com.br>
User-Agent: Alpine 1.00 (LNX 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 8 Sep 2008, Renato S. Yamane wrote:

> Henrique de Moraes Holschuh wrote:
> > I fell I need to warn you guys that you are likely breaking machines that
> > match that DMI info but have a newer BIOS, unless they use different BIOSes
> > (not enough data without a full dmidecode output from the other machine).
> 
> dmidecode just from 3000-N100?
> Attached a dmidecode from a Lenovo Thinkpad T61.
> I have a Lenovo 3000-V200 too. You want a dmidecode from it?

It's almost certainly only 3000 series that's interesting; I think they 
test the Thinkpads with Linux and wouldn't ship with a quirky BIOS there. 
The 3000 series only officially supports Windows, and so there can be 
problems (evidently, mine does something odd with the legacy mux, and 
newer ones do something odd with the active mux).

You might want to poke at the quirk in the patch in this thread and see if 
one or the other mode works better, or if they're the same on your 
machines. In any case, neither the patch that got into 2.6.25 nor the 
narrowing patch in this thread would affect either of your machines.

	-Daniel
*This .sig left intentionally blank*
