Return-Path: <linux-kernel-owner+w=401wt.eu-S1751823AbYLMRnU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751823AbYLMRnU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Dec 2008 12:43:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750968AbYLMRnK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 13 Dec 2008 12:43:10 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:40578 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750933AbYLMRnJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Dec 2008 12:43:09 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Maxim Levitsky <maximlevitsky@gmail.com>
Subject: Re: Bugs on aspire one A150
Date: Sat, 13 Dec 2008 18:42:27 +0100
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org, linux-pm@lists.linux-foundation.org,
       ath5k-devel@venema.h4ckr.net, alsa-devel@alsa-project.org,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       Matthew Garrett <mjg59@srcf.ucam.org>
References: <491506DB.1070000@gmail.com> <200812131435.34072.rjw@sisk.pl> <1229178097.4936.1.camel@maxim-laptop>
In-Reply-To: <1229178097.4936.1.camel@maxim-laptop>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200812131842.28420.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday, 13 of December 2008, Maxim Levitsky wrote:
> On Sat, 2008-12-13 at 14:35 +0100, Rafael J. Wysocki wrote:
> > On Saturday, 13 of December 2008, Maxim Levitsky wrote:
> > > 
> > > So, big thanks for everything.
> > > 
> > > Now aspire one linux support is very close to perfect,
> > > (only problem left is that wireless is limited to 18Mbits/s raw rate,
> > > but at some point I or developers of ath5k will get to the bottom of
> > > this)
> > > 
> > > I also noticed, that now the SD only card reader is always enabled
> > > regardless of card been there while booting, and same happens in
> > > windows, I suspect that this is permanent hardware change, which worries
> > > me, but this reader works fine otherwise.
> > > (This is another reason why binary bioses are evil, go and find out why
> > > it enables it)
> > > 
> > > 
> > > Also forgot to mention that both readers ignore write protect tab on SD
> > > card, and I will report this to correct mailing list soon.
> > > Everything else works fine
> > > 
> > > please include acpiphp fix in 2.6.28.
> > 
> > Which one is this?
> 
> 
> 
> acpiphp: Identify more removable slots
>     
>     According to section 6.3.6 of the ACPI spec, the presence of an _RMV
>     method that evaluates to 1 is sufficient to indicate that a slot is
>     removable without needing an eject method. This patch refactors the
>     ejectable slot detection code a little in order to flag these slots as
>     ejectable and register them. Acpihp therefore binds to the expresscard
>     slot on my HP test machine.
>     
>     Signed-off-by: Matthew Garrett <mjg@redhat.com>
> 
> 
> this makes acpiphp handle hotplug of (now one, sd reader is somehow
> always present) card reader.

This is
http://git.kernel.org/?p=linux/kernel/git/jbarnes/pci-2.6.git;a=commit;h=db9fe9a7230d65916c9938c4f91c75f9c5e00cb7
in the PCI tree.

It's scheduled for 2.6.29 and may be included into 2.6.28 -stable, but please
remember to notify the stable team as soon as this patch gets merged into the
mainline.

Thanks,
Rafael
