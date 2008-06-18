Return-Path: <linux-kernel-owner+w=401wt.eu-S1755270AbYFRSNg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755270AbYFRSNg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2008 14:13:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752259AbYFRSN2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Jun 2008 14:13:28 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:40196 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752075AbYFRSN2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2008 14:13:28 -0400
Date: Wed, 18 Jun 2008 18:55:34 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: "Hans-Peter Jansen" <hpj@urpla.net>
Cc: linux-kernel@vger.kernel.org, "R.L. Horn" <lists@eastcheap.org>
Subject: Re: 2.6.25.3: serial problem (minicom)
Message-ID: <20080618185534.5f969f63@lxorguk.ukuu.org.uk>
In-Reply-To: <200806180215.45925.hpj@urpla.net>
References: <alpine.LNX.1.00.0806131635260.1294@hani.compact.internal>
	<alpine.LNX.1.00.0806162306400.10919@hani.compact.internal>
	<20080617095827.0f4f77de@lxorguk.ukuu.org.uk>
	<200806180215.45925.hpj@urpla.net>
X-Mailer: Claws Mail 3.4.0 (GTK+ 2.12.8; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 18 Jun 2008 02:15:45 +0200
"Hans-Peter Jansen" <hpj@urpla.net> wrote:

> Am Dienstag, 17. Juni 2008 schrieb Alan Cox:
> > On Mon, 16 Jun 2008 23:22:54 -0500 (CDT)
> >
> > Ah ok I know what the bug is - it was fixed in 2.6.26-rc as follows
> >
> > +       /* Don't rewrite B0 */
> > +       if (tty_termios_baud_rate(termios))
> > +               tty_termios_encode_baud_rate(termios, baud, baud);
> >  }
> 
> Alan, could this issue lead to dysfunctional serial dcf77 receivers, too? 
> (and could you point my to the related git changeset?)

I don't generally work via git so I don't offhand know the changeset id.
I guess it could do. If its causing this many actual problem cases it
might also want to go into stable.

Alan
