Return-Path: <linux-kernel-owner+w=401wt.eu-S1756344AbZAYPjT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756344AbZAYPjT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Jan 2009 10:39:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753098AbZAYPjJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 Jan 2009 10:39:09 -0500
Received: from smtp4.int-evry.fr ([157.159.10.71]:49034 "EHLO
	smtp4.int-evry.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752583AbZAYPjI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Jan 2009 10:39:08 -0500
From: Florian Fainelli <florian.fainelli@telecomint.eu>
To: Ingo Molnar <mingo@elte.hu>
Subject: Re: System clock runs too fast after 2.6.27 -> 2.6.28.1 upgrade
Date: Sun, 25 Jan 2009 16:38:32 +0100
User-Agent: KMail/1.9.9
Cc: john stultz <johnstul@us.ibm.com>, Miklos Vajna <vmiklos@frugalware.org>,
       linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Gabriel C <nix.or.die@googlemail.com>,
       =?iso-8859-1?q?CS=C9CSY_L=E1szl=F3?= <boobaa@frugalware.org>,
       r.schwebel@pengutronix.de, sven@geggus.net
References: <20090121171423.GI21473@genesis.frugalware.org> <200901251218.33255.florian.fainelli@telecomint.eu> <20090125150349.GB19168@elte.hu>
In-Reply-To: <20090125150349.GB19168@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200901251638.34040.florian.fainelli@telecomint.eu>
X-INT-MailScanner-Information: Please contact the ISP for more information
X-INT-MailScanner-ID: 5900F404FA4.9C025
X-INT-MailScanner: Found to be clean
X-INT-MailScanner-SpamCheck: 
X-INT-MailScanner-From: florian.fainelli@telecomint.eu
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le Sunday 25 January 2009 16:03:49 Ingo Molnar, vous avez écrit :
> * Florian Fainelli <florian.fainelli@telecomint.eu> wrote:
> > Le Saturday 24 January 2009 10:14:04 Ingo Molnar, vous avez écrit :
> > > * john stultz <johnstul@us.ibm.com> wrote:
> > > > On Fri, Jan 23, 2009 at 3:04 AM, Ingo Molnar <mingo@elte.hu> wrote:
> > > > > * john stultz <johnstul@us.ibm.com> wrote:
> > > > >> I'd think this would ideally be more of a subarch in the config
> > > > >> selection like the AMD Elan is, so folks know it really is not
> > > > >> just a extra-support feature and in fact limits what hardware you
> > > > >> can use the resulting kernel on.
> > > > >
> > > > > a better solution is that if RDC is set [it is unset by default] we
> > > > > should turn PIT_TICK_RATE into a variable, defaulting it to
> > > > > 1193182. If a real RDC or ELAN system is running, that variable is
> > > > > changed during early bootup, in the init functions for those
> > > > > platforms.
> > > >
> > > > Took a quick look at this, and I don't see any detection code for
> > > > either RDC. The X86_ELAN config also has no conditionals, but maybe
> > > > the elan cpufreq code can help here.
> > >
> > > i'd suggest to just remove the #ifdef for now (it's causing problems)
> > > and add the variable - we can add the quirks for those two platforms
> > > later on, separately from your patch(es).
> >
> > Fine with me. Ingo, is there any infrastructure yet to get an early
> > quirk set the PIT tick rate accordingly ?
>
> Not yet but it should be easy - do you have the time to implement it?

Not until a week, sorry.

Thanks
-- 
Cordialement, Florian Fainelli
------------------------------
