Return-Path: <linux-kernel-owner+w=401wt.eu-S1763021AbZCQLaa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763021AbZCQLaa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Mar 2009 07:30:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754285AbZCQLaV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Mar 2009 07:30:21 -0400
Received: from mail-fx0-f176.google.com ([209.85.220.176]:58764 "EHLO
	mail-fx0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754075AbZCQLaT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Mar 2009 07:30:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=KlzN5JSRkD9P+ZUYTBxUET7zTCei8G8D3NSLkxNLd5q6Ej1zJp/gFpGpGZRDwyHBbR
         BjB8JHVl2L4TZpw28bwbwrzPzI/PGEnjKLQuP6gN1KU4KKD1khivhEDKJ5V7BFkiJRFA
         LGbY/buXE+/ubACs2sP8T+BN2U2EVmdGVFYFQ=
Subject: Re: [alsa-devel] Bugs on aspire one A150
From: Maxim Levitsky <maximlevitsky@gmail.com>
To: Takashi Iwai <tiwai@suse.de>
Cc: Andreas Mohr <andi@lisas.de>, linux-kernel@vger.kernel.org,
       alsa-devel@alsa-project.org,
       Kernel Testers List <kernel-testers@vger.kernel.org>
In-Reply-To: <s5heiwwzim7.wl%tiwai@suse.de>
References: <s5h4oxtqy6q.wl%tiwai@suse.de>
	 <20090316160208.GB4458@rhlx01.hs-esslingen.de>
	 <s5hwsappi44.wl%tiwai@suse.de> <s5hprghphid.wl%tiwai@suse.de>
	 <20090316170015.GA9776@rhlx01.hs-esslingen.de>
	 <s5hljr5pex0.wl%tiwai@suse.de>
	 <20090316173000.GA25647@rhlx01.hs-esslingen.de>
	 <s5hiqm9pe1g.wl%tiwai@suse.de>
	 <20090316180638.GB25647@rhlx01.hs-esslingen.de>
	 <s5htz5tyzyg.wl%tiwai@suse.de>
	 <20090316212227.GA29471@rhlx01.hs-esslingen.de>
	 <1237251139.7952.1.camel@maxim-laptop>  <s5heiwwzim7.wl%tiwai@suse.de>
Content-Type: text/plain
Date: Tue, 17 Mar 2009 13:30:12 +0200
Message-Id: <1237289412.15134.2.camel@maxim-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-03-17 at 08:57 +0100, Takashi Iwai wrote:
> At Tue, 17 Mar 2009 02:52:19 +0200,
> Maxim Levitsky wrote:
> > 
> > On Mon, 2009-03-16 at 22:22 +0100, Andreas Mohr wrote:
> > > Hi,
> > > 
> > > On Mon, Mar 16, 2009 at 09:28:39PM +0100, Takashi Iwai wrote:
> > > > At Mon, 16 Mar 2009 19:06:38 +0100,
> > > > Andreas Mohr wrote:
> > > > > I just tried connecting a headset and switching to E-Mic.
> > > > > What I can say is:
> > > > > - opposite levels does NOT happen there (E-Mic is "analog micro"-based, right?)
> > > > > - leaving E-Mic unplugged will actually record from i-Mic (due to properly
> > > > >   working EAPD mechanism, right?)
> > > > 
> > > > The record from mic-jack is via analog path.  The phase-inversion
> > > > appears only for digital-mic, AFAIK.
> > > 
> > > Thought so.
> > > 
> > > > > One question still: is this a hardware defect (i.e. could this possibly
> > > > > be swapped cables of the microphone connector in this model or so?
> > > > > Not plausible but...), or is this an existing property
> > > > > of the HDA's dig-mic base? You indicated it's the latter I think...
> > > > 
> > > > My guess is that it's a hardware implementation.
> > > > Maybe for the noise suppression via mic array.
> > > 
> > > Not sure what this means.
> > > 
> > > > The question is whether the left / right channels recorded from
> > > > digital mic are really raw data, or they are for modified data
> > > > (for differential, etc)...  It's hard to guess without the actual
> > > > data.
> > > 
> > > I don't quite follow you here. Is there anything I could do about this?
> > > 
> > > Thanks,
> > > 
> > > Andreas
> > 
> > 
> > What about exposing the i-mic as a mono only device to userspace?
> > It is mono after all?
> 
> No, it's a mic-array.  And HD-audio cannot handle a mono stream.
No problem.
Lets just lie to usespace that it is mono, in kernel driver can pick one
of channels?

Maybe this is an array, but this doesn't explain the 'quality' of it.
It is so low (in windows too).

Best regards,
	Maxim Levitsky

