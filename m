Return-Path: <linux-kernel-owner+w=401wt.eu-S1754898AbYJVVsm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754898AbYJVVsm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2008 17:48:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751631AbYJVVsc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Oct 2008 17:48:32 -0400
Received: from ey-out-2122.google.com ([74.125.78.24]:6830 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751460AbYJVVsb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2008 17:48:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-disposition:message-id:content-type
         :content-transfer-encoding;
        b=W5HwkEU+ct8SK8wFG8ZFGguTH46k8PGOtrlOWnWD0zdMNC4mM8C5fXaELRJjOhvBQB
         38yoTBvqXf0CfUfBxYq0HFUBHaAgzoHOulS5oICmMCNqgQhy2ZxEDfiPBCEdGoj4ucbi
         I4uTX0MYmnG/Aj+3V9jk+56TVuP1dvkno9GL8=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Subject: Re: [git pull] IDE updates #4
Date: Wed, 22 Oct 2008 23:37:42 +0200
User-Agent: KMail/1.9.10
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Stephen Rothwell <sfr@canb.auug.org.au>, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org
References: <200810212100.52985.bzolnier@gmail.com> <58cb370e0810220514x419c9669jba1b7be942d3644a@mail.gmail.com> <48FF2047.6000509@ru.mvista.com>
In-Reply-To: <48FF2047.6000509@ru.mvista.com>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200810222337.42218.bzolnier@gmail.com>
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 22 October 2008, Sergei Shtylyov wrote:
> Hello.
> 
> Bartlomiej Zolnierkiewicz wrote:
> 
> >>> Remove needless/confusing subdirs from drivers/ide/.
> >> I think that with 2 new drivers being submitted/reworked based on feedback
> >> and several patches submitted and pending submission to the pata-2.6 series
> >> this really could have waited till 2.6.29...
> >>     
> >
> > The situation is perfect right now for this change as there are no outstanding
> > patches in pata-2.6 tree 
> 
>    There was one patch (already stale TX4939 version driver) as of 
> yesterday.

Indeed.

> > and number of new submitted patches is < 10 (I'll take
> > care of fixing them up, ditto for all other new stuff that will be using old
> > naming scheme).
> >   
> 
>    Thanks for clarifying this.
>    This rename only added more uncertainty for my pending patchset 
> (which had been already dependant on at least TX4939 driver which keeps 
> being recast by Atsushi and being stale in pata-2.6 series) as I can't 
> predict when you and Linus will merge the changes and this is getting on 
> my nerves, as I don't have time on any extra rework and I'm running out 
> of time with the submission. I know I should have done this earlier and 

Maybe some parts could be submitted separately?
(so keeping them up-to-date in pata-2.6 would be my task)

Also I didn't know anything about your patchset and its
dependency on TX4939, otherwise I'll be pushing things in
different order or even skip this pull request if needed
(TX493x drivers are new stuff and were still under review,
such things can be also submitted after the merge window
closes so they were given the lowest priority).

Please ping me about such issues, I'm certainly willing to
adjust my workflow if this is going to help other people with
their work but I can't do much if I don't know anything...

> I'd have done this if its not for my unfortunate vacations... I aslso 
> kept finding new issues looking on the IOC4 driver. :-/

I remember about your SGIIOC4 fixes and they are going to
make the next git pull request so sooner this one gets in the
better.  Also maybe you could get some help with fixing this
driver from SGI folks if there are still some issues left?

Thanks,
Bart
