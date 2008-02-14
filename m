Return-Path: <linux-kernel-owner+w=401wt.eu-S1757524AbYBNKIX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757524AbYBNKIX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2008 05:08:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750954AbYBNKIL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Feb 2008 05:08:11 -0500
Received: from moutng.kundenserver.de ([212.227.126.187]:53066 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750894AbYBNKIJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2008 05:08:09 -0500
From: Hans-Peter Jansen <hpj@urpla.net>
To: petkovbb@gmail.com, linux-kernel@vger.kernel.org,
       linux-ide@vger.kernel.org, bzolnier@gmail.com
Subject: Re: IDE cdrom problem with PLEXTOR DVDR PX-608AL
Date: Thu, 14 Feb 2008 11:08:01 +0100
User-Agent: KMail/1.9.6 (enterprise 20071221.751182)
References: <200802121026.17420.hpj@urpla.net> <200802140037.51450.hpj@urpla.net> <20080214062652.GE13446@gollum.tnic>
In-Reply-To: <20080214062652.GE13446@gollum.tnic>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200802141108.02285.hpj@urpla.net>
X-Provags-ID: V01U2FsdGVkX18hfONU6/NoiUJ8bNnlcE0rVuMaoS0t42WFJOx
 iAGfnKbtEpVIoAGwmHyAcbEHkS7MnPtl+6gIZ0O7CPNWTHtRzX
 E+U2q1pBzxQ8YkZ2ydrCQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Donnerstag, 14. Februar 2008 schrieb Borislav Petkov:
> On Thu, Feb 14, 2008 at 12:37:50AM +0100, Hans-Peter Jansen wrote:
>
> [Added Bart to CC]
>
> > Am Dienstag, 12. Februar 2008 schrieb Borislav Petkov:
> > > On Tue, Feb 12, 2008 at 10:26:17AM +0100, Hans-Peter Jansen wrote:
> > > > Hi,
> > > >
> > > > I suffer from unreliable cdrom operations (failing DAE and burn
> > > > sessions) with the openSUSE 2.6.18.8-0.7-bigsmp kernel.
> > >
> > > 			^^^^
> > > Hi,
> > >
> > > can please you test this with a more recent kernel. Yours is almost
> > > ancient - from Sep. 2006.
> >
> > Sure, sorry. Here we go:
> >
> > Feb 14 00:18:18 kernel: hde: cdrom_pc_intr: The drive appears confused
> > (ireason = 0x01). Trying to recover by ending request.
> > Feb 14 00:27:27 kernel: hdc: cdrom_pc_intr: The drive appears confused
> > (ireason = 0x01). Trying to recover by ending request.
> >
> > ~> uname -a
> > Linux xrated 2.6.24.1-35-pae #1 SMP 2008/02/12 01:00:18 UTC i686 athlon
> > i386 GNU/Linux
>
> Actually the interrupt handler in ide-cd got rewritten and you're still
> using the old one (cdrom_pc_intr vs cdrom_newpc_intr). Those changes went
> into mainline before the 2.6.25-rc1 so we'll be able to test the new one
> only when you try out 2.6.25-rc1 or wait until 2.6.25 is released in case
> you don't want to try hazardous materials such as an -rc kernel[*] :).

Hrm, I highly depend on that system being reliable¹, thus I would prefer a 
diff, if feasible at all. That way, any breakage may be embanked to PATA.

OTOH, I'm willing to help to get down to the issue (knowing that this is the 
only way to finally get rid of it).

Thanks,
Pete

¹) As a matter of fact, I suffered from way to many regressions in essential
   subsystems (kernel, X, nss_ldap) lately, not to speak from the usual
   calamities in peripheral areas of such complex beasts.
