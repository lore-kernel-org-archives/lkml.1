Return-Path: <linux-kernel-owner+w=401wt.eu-S1754846AbYJGNUd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754846AbYJGNUd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2008 09:20:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753482AbYJGNUZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Oct 2008 09:20:25 -0400
Received: from outbound-va3.frontbridge.com ([216.32.180.16]:13043 "EHLO
	VA3EHSOBE006.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753479AbYJGNUY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2008 09:20:24 -0400
X-BigFish: VPS-61(z21eW6f5iz1432R98dR1805M179dR936fO3117K103dK1b0bM19c2kzzzzz32i6bh43j61h)
X-Spam-TCS-SCL: 0:0
X-FB-SS: 5,
X-WSS-ID: 0K8DEDJ-02-8AJ-01
Date: Tue, 7 Oct 2008 15:19:54 +0200
From: Andreas Herrmann <andreas.herrmann3@amd.com>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
CC: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Arjan van de Ven <arjan@infradead.org>, linux-kernel@vger.kernel.org
Subject: Re: 2.6.27-rc8+ - first impressions
Message-ID: <20081007131954.GE22097@alberich.amd.com>
References: <20081005183603.GA3263@amd.corenet.prv> <20081005121046.579089b9@infradead.org> <20081006062838.GC2808@amd.corenet.prv> <20081006195350.GB22097@alberich.amd.com> <20081007034230.GA6095@amd.corenet.prv> <20081007091032.GD22097@alberich.amd.com> <20081007113747.GA2819@amd.corenet.prv>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20081007113747.GA2819@amd.corenet.prv>
User-Agent: Mutt/1.5.16 (2007-06-09)
X-OriginalArrivalTime: 07 Oct 2008 13:20:07.0426 (UTC) FILETIME=[6AC89E20:01C9287F]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 07, 2008 at 07:37:47AM -0400, Dmitry Torokhov wrote:
> On Tue, Oct 07, 2008 at 11:10:32AM +0200, Andreas Herrmann wrote:
> > >On Mon, Oct 06, 2008 at 11:42:35PM -0400, Dmitry Torokhov wrote:
> > > On Mon, Oct 06, 2008 at 09:53:50PM +0200, Andreas Herrmann wrote:
> > > > 
> > > > FYI.
> > > > Commit e7250b8ae3870f37f660c2f65cafcaba85e3bfd3 of tip/master is
> > > > needed to really enable hpet on SB400. I guess that patch should go
> > > > upstream asap -- and probably it's a good idea to add a check for timer
> > > > interrupt routing as well which could solve the issues on HP nx6xxx
> > > > laptops.
> > > > 
> > > 
> > > Having trouble locating this one. Could you please send me a patch so I
> > > can try it here? Thanks!
> > 
> > Here it is.
> > 
> 
> Hmm, that unfortunately does not work because I have SB4X0 revision 0x11
> and the patch cuts off everything below 0x82. Is there anything that can
> be done to enable HPET on early revisions?

No, sorry.
It won't work as interrupts won't properly delivered.


Regards,

Andreas


