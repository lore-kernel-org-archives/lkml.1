Return-Path: <linux-kernel-owner+w=401wt.eu-S1756990AbZFSUUy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756990AbZFSUUy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Jun 2009 16:20:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753340AbZFSUUq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Jun 2009 16:20:46 -0400
Received: from torrent.CC.McGill.CA ([132.206.27.49]:43611 "EHLO
	torrent.cc.mcgill.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751683AbZFSUUq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Jun 2009 16:20:46 -0400
Subject: Re: Panic booting 2.6.30
From: David Ronis <ronis@ronispc.chem.mcgill.ca>
Reply-To: ronis@ronispc.chem.mcgill.ca
To: Justin Mattock <justinmattock@gmail.com>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <dd18b0c30906191255h7d0c6bcfx58f32d4b34e13c34@mail.gmail.com>
References: <1245439404.25076.7.camel@ronispc.chem.mcgill.ca>
	 <4A3BE7EA.4050800@msgid.tls.msk.ru>
	 <dd18b0c30906191255h7d0c6bcfx58f32d4b34e13c34@mail.gmail.com>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Organization: Department of Chemistry, McGill University
Date: Fri, 19 Jun 2009 16:20:50 -0400
Message-Id: <1245442850.25076.11.camel@ronispc.chem.mcgill.ca>
Mime-Version: 1.0
X-Mailer: Evolution 2.27.3 
X-PMX-Version: 5.4.2.338381, Antispam-Engine: 2.6.0.325393, Antispam-Data: 2009.6.19.114543
X-McGill-WhereFrom: Internal
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks for the reply.

I don't know how to do this with the crashed kernel, but in 2.6.26.5
the expected /dev/hda? entries are there, while /dev/sda? aren't.

David

On Fri, 2009-06-19 at 12:55 -0700, Justin Mattock wrote:
> On Fri, Jun 19, 2009 at 12:32 PM, Michael Tokarev<mjt@tls.msk.ru> wrote:
> > David Ronis wrote:
> >>
> >> I've just upgraded an older machine (a P3 running slackware 11.0) from
> >> 2.6.26.5 to 2.6.30; the build was uneventful.  However, on reboot (using
> >> lilo) I get:
> >>
> >> VSF:  Cannot open root device "hda2" or unknown-block(0,0)
> >> Please append a correct root= boot option; here are the available
> >> partions:     <====== nothing shows here...
> >> Kernel-Panic - not syncing.
> >>
> >> I had rebooted with and without root=hda2.   The old kernel is still
> >> usable.
> >>
> >> Lilo.conf looks like:
> >
> > Add large-memory option to lilo.conf
> >
> > /mjt
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > Please read the FAQ at  http://www.tux.org/lkml/
> >
> 
> check  /dev/hda*  to see
> if it renamed itself to /dev/sda*
> (noticed this a few months ago with
> 2.6.17(I think) to 2.6.24)
> 
