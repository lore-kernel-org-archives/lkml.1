Return-Path: <linux-kernel-owner+w=401wt.eu-S1758052AbYJHBIP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758052AbYJHBIP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2008 21:08:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754455AbYJHBH7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Oct 2008 21:07:59 -0400
Received: from yw-out-2324.google.com ([74.125.46.28]:12289 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752788AbYJHBH7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2008 21:07:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=w3RW70nwM2a3tE1GYjQmuiOWqIjwGytcGEmQ7IAKDl2peCLUmmenJUiE/fdc+9Vfxe
         xXiG6c2aDzPAM1zydITtnT0CVilDhOYcCpJ+EUGfpiOPSF+SDDmqzYBbKM/ZG35NiLrg
         rGj20G/Cg3Rx3hqy9VyLLwNwDZXksiZQViIQ4=
Date: Tue, 7 Oct 2008 21:07:53 -0400
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Parag Warudkar <parag.lkml@gmail.com>
Cc: Andreas Herrmann <andreas.herrmann3@amd.com>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>,
       Arjan van de Ven <arjan@infradead.org>, linux-kernel@vger.kernel.org
Subject: Re: 2.6.27-rc8+ - first impressions
Message-ID: <20081008010753.GA20753@anvil.corenet.prv>
References: <20081005183603.GA3263@amd.corenet.prv> <20081005121046.579089b9@infradead.org> <20081006062838.GC2808@amd.corenet.prv> <20081006195350.GB22097@alberich.amd.com> <20081007034230.GA6095@amd.corenet.prv> <20081007091032.GD22097@alberich.amd.com> <20081007113747.GA2819@amd.corenet.prv> <f7848160810070507n1a75034dta6fb97880174d22a@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f7848160810070507n1a75034dta6fb97880174d22a@mail.gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 07, 2008 at 08:07:49AM -0400, Parag Warudkar wrote:
> On Tue, Oct 7, 2008 at 7:37 AM, Dmitry Torokhov
> <dmitry.torokhov@gmail.com> wrote:
> > Hmm, that unfortunately does not work because I have SB4X0 revision 0x11
> > and the patch cuts off everything below 0x82. Is there anything that can
> > be done to enable HPET on early revisions?
> >
> 
> Later BIOS revisions for the 6115 "enable Vista support" which
> actually means HPET is properly enabled in BIOS for Vista to work.
> (i.e. there won't be a need to force enable it with later BIOS versions.)
> 
> Any reason you could not try the BIOS upgrade I pointed out earlier?
> 

I just did not want to do that on the road.

I do not see any difference with regard to timer wiring or hpet behavior
(hpet is disabled in BIOS, hpet=force causes hang) with the latest
(F.12) BIOS.

-- 
Dmitry
