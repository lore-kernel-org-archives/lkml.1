Return-Path: <linux-kernel-owner+w=401wt.eu-S1757804AbXIFPKG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757804AbXIFPKG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Sep 2007 11:10:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756133AbXIFPJz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Sep 2007 11:09:55 -0400
Received: from antispam.upcomillas.es ([130.206.70.245]:55069 "EHLO
	antispam.upcomillas.es" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754917AbXIFPJy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Sep 2007 11:09:54 -0400
Subject: Re: hda_intel : Patch + Regression in 2.6.18 -> 2.6.22
From: Romano Giannetti <romanol@upcomillas.es>
To: Takashi Iwai <tiwai@suse.de>
Cc: Andrew Morton <akpm@linux-foundation.org>, roger@computer-surgery.co.uk,
       linux-kernel@vger.kernel.org, perex@suse.cz
In-Reply-To: <s5hhcm96oza.wl%tiwai@suse.de>
References: <20070822222902.GA28563@computer-surgery.co.uk> 
	<20070905083844.6637da1e.akpm@linux-foundation.org> 
	<s5hlkbl6qsn.wl%tiwai@suse.de> 
	<20070905091633.87cfaa81.akpm@linux-foundation.org> 
	<s5hhcm96oza.wl%tiwai@suse.de>
Content-Type: text/plain;
	charset=utf-8
Date: Thu, 06 Sep 2007 17:09:50 +0200
Message-Id: <1189091390.3212.3.camel@rukbat>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-09-05 at 18:44 +0200, Takashi Iwai wrote:
> At Wed, 5 Sep 2007 09:16:33 -0700,
> Andrew Morton wrote:
> >
> > > On Wed, 05 Sep 2007 18:05:44 +0200 Takashi Iwai <tiwai@suse.de> wrote:
> > > Roger, could you try git-alsa patch in the latest mm together with
> > > model=acer-aspiore option?  If it works, I can easily add your device
> > > ID to the table.
> >
> > http://userweb.kernel.org/~akpm/git-alsa.patch is a copy of the alsa git
> > tree as of two minutes ago.  That applies against current Linus mainline,
> > but should apply OK on 2.6.23-rc5 as well.  Please test that, thanks.
> >
> > Takashi, perhaps that is 2.6.23 material?
>
> The changes for Acer Aspire is quite big, surely not for 2.6.23.
> Let's fix in 2.6.24 in a better way than a temporary hack (that
> would work only in a very limited way).

Just one hand up: I haven't tested the patch pointed to by Andrew, will
do asap, but it seems that contains the changes from

https://bugtrack.alsa-project.org/alsa-bug/view.php?id=3104

which are needed to have sound at all on my toshiba (although with some
remaining problems). I am not able to say if it's .23 material or not,
nor if it's a regression or not, being this a quite new laptop... but
maybe it's better to have a release with some sound and then fix it
properly after?

Thanks for your hard work,

	Romano




--
La presente comunicación tiene carácter confidencial y es para el exclusivo uso del destinatario indicado en la misma. Si Ud. no es el destinatario indicado, le informamos que cualquier forma de distribución, reproducción o uso de esta comunicación y/o de la información contenida en la misma están estrictamente prohibidos por la ley. Si Ud. ha recibido esta comunicación por error, por favor, notifíquelo inmediatamente al remitente contestando a este mensaje y proceda a continuación a destruirlo. Gracias por su colaboración.

This communication contains confidential information. It is for the exclusive use of the intended addressee. If you are not the intended addressee, please note that any form of distribution, copying or use of this communication or the information in it is strictly prohibited by law. If you have received this communication in error, please immediately notify the sender by reply e-mail and destroy this message. Thank you for your cooperation.

