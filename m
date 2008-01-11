Return-Path: <linux-kernel-owner+w=401wt.eu-S1762170AbYAKTHk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762170AbYAKTHk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jan 2008 14:07:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761538AbYAKTHd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Jan 2008 14:07:33 -0500
Received: from ns.gsystems.sk ([62.176.172.50]:38778 "EHLO www.gsystems.sk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757005AbYAKTHc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jan 2008 14:07:32 -0500
From: Ondrej Zary <linux@rainbow-software.org>
To: Rene Herman <rene.herman@keyaccess.nl>
Subject: Re: [alsa-devel] PNP_DRIVER_RES_DISABLE breaks swsusp at least with snd_cs4236
Date: Fri, 11 Jan 2008 19:40:18 +0100
User-Agent: KMail/1.9.7
Cc: Pierre Ossman <drzeus@drzeus.cx>, Jaroslav Kysela <perex@perex.cz>,
       ALSA development <alsa-devel@alsa-project.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       Bjorn Helgaas <bjorn.helgaas@hp.com>, Andrew Morton <akpm@osdl.org>,
       Takashi Iwai <tiwai@suse.de>
References: <200801092343.48726.linux@rainbow-software.org> <20080111080141.75aaad5f@poseidon.drzeus.cx> <47877B83.5040604@keyaccess.nl>
In-Reply-To: <47877B83.5040604@keyaccess.nl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200801111940.22023.linux@rainbow-software.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 11 January 2008 15:21:55 Rene Herman wrote:
> On 11-01-08 08:01, Pierre Ossman wrote:
> > On Fri, 11 Jan 2008 02:19:07 +0100
> >
> > Rene Herman <rene.herman@keyaccess.nl> wrote:
> >> I see a PnP resume _consists_ of setting the resources so I can see the
> >> test implementation wise, but yes, conceptually it seems this test
> >> shouldn't be present. So just like the attached then?
> >>
> >> Pierre, what was the idea here? Added the other SOBs to the CC as
> >> well...
> >
> > You assume there was an idea? ;)
> >
> > I don't remember why things were done the way they were. And I can't find
> > any clues in the correspondence around the issue. So your guess is as
> > good as mine.
>
> Hrmpf. Well, okay. Ondrej -- I assume this patch fixes things?

Yes, it works fine.
3c509 card still does not work after resume, but that looks like another 
problem.

-- 
Ondrej Zary
