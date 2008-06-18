Return-Path: <linux-kernel-owner+w=401wt.eu-S1755609AbYFRUQg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755609AbYFRUQg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2008 16:16:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752319AbYFRUQ3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Jun 2008 16:16:29 -0400
Received: from dspnet.fr.eu.org ([213.186.44.138]:4629 "EHLO dspnet.fr.eu.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751036AbYFRUQ2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2008 16:16:28 -0400
X-Greylist: delayed 528 seconds by postgrey-1.27 at vger.kernel.org; Wed, 18 Jun 2008 16:16:28 EDT
Date: Wed, 18 Jun 2008 22:07:38 +0200
From: Olivier Galibert <galibert@pobox.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Hans-Peter Jansen <hpj@urpla.net>, linux-kernel@vger.kernel.org,
       "R.L. Horn" <lists@eastcheap.org>
Subject: Re: 2.6.25.3: serial problem (minicom)
Message-ID: <20080618200738.GB23861@dspnet.fr.eu.org>
Mail-Followup-To: Olivier Galibert <galibert@pobox.com>,
	Alan Cox <alan@lxorguk.ukuu.org.uk>,
	Hans-Peter Jansen <hpj@urpla.net>, linux-kernel@vger.kernel.org,
	"R.L. Horn" <lists@eastcheap.org>
References: <alpine.LNX.1.00.0806131635260.1294@hani.compact.internal> <alpine.LNX.1.00.0806162306400.10919@hani.compact.internal> <20080617095827.0f4f77de@lxorguk.ukuu.org.uk> <200806180215.45925.hpj@urpla.net> <20080618185534.5f969f63@lxorguk.ukuu.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080618185534.5f969f63@lxorguk.ukuu.org.uk>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 18, 2008 at 06:55:34PM +0100, Alan Cox wrote:
> On Wed, 18 Jun 2008 02:15:45 +0200
> "Hans-Peter Jansen" <hpj@urpla.net> wrote:
> 
> > Am Dienstag, 17. Juni 2008 schrieb Alan Cox:
> > > On Mon, 16 Jun 2008 23:22:54 -0500 (CDT)
> > >
> > > Ah ok I know what the bug is - it was fixed in 2.6.26-rc as follows
> > >
> > > +       /* Don't rewrite B0 */
> > > +       if (tty_termios_baud_rate(termios))
> > > +               tty_termios_encode_baud_rate(termios, baud, baud);
> > >  }
> > 
> > Alan, could this issue lead to dysfunctional serial dcf77 receivers, too? 
> > (and could you point my to the related git changeset?)
> 
> I don't generally work via git so I don't offhand know the changeset id.

e991a2bd4fa0b2f475b67dfe8f33e8ecbdcbb40b

git blame drivers/serial/8250.c then look for "rewrite B0" (which gets
you e991a2bd) then git show e991a2bd.

  OG.
