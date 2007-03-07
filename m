Return-Path: <linux-kernel-owner+w=401wt.eu-S1030301AbXCGWQy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030301AbXCGWQy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2007 17:16:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030297AbXCGWQy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Mar 2007 17:16:54 -0500
Received: from wr-out-0506.google.com ([64.233.184.236]:42843 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030301AbXCGWQx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2007 17:16:53 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=FY8KHPD1NnbOohldV6OA8INDyDfkSWwvLe8z3sx5ShVbebhaOGpcXvIpYYOgArjEsOjEoKa1fH6JK2doT0wFYDDipQUPXxpZwvwPM+tpWsUcNc2sJZjGtsOPc5pVnbQa/GDHARsmb/BpmQKva3WF6XKAXGJ9Zvn2jkpnX0hGbXI=
Message-ID: <6bffcb0e0703071416j2217623bxbef6d24ddf755630@mail.gmail.com>
Date: Wed, 7 Mar 2007 23:16:51 +0100
From: "Michal Piotrowski" <michal.k.k.piotrowski@gmail.com>
To: "Andrew Morton" <akpm@linux-foundation.org>
Subject: Re: mm snapshot broken-out-2007-03-05-02-22.tar.gz uploaded
Cc: "Randy Cushman" <rcushman_linux@earthlink.net>,
       "Takashi Iwai" <tiwai@suse.de>, "Jaroslav Kysela" <perex@suse.cz>,
       alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org,
       "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Adrian Bunk" <bunk@stusta.de>
In-Reply-To: <20070307115024.756c848f.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200703051024.l25AOIF3015951@shell0.pdx.osdl.net>
	 <45EC2DEB.1050108@googlemail.com> <45EEA3C4.7000501@googlemail.com>
	 <20070307104746.f08a2e84.akpm@linux-foundation.org>
	 <6bffcb0e0703071141j42309702w793e4a76b1b23bfa@mail.gmail.com>
	 <20070307115024.756c848f.akpm@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/03/07, Andrew Morton <akpm@linux-foundation.org> wrote:
> On Wed, 7 Mar 2007 20:41:30 +0100 "Michal Piotrowski" <michal.k.k.piotrowski@gmail.com> wrote:
>
> > > > 831466f4ad2b5fe23dff77edbe6a7c244435e973 is first bad commit
> > > > commit 831466f4ad2b5fe23dff77edbe6a7c244435e973
> > > > Author: Randy Cushman <rcushman_linux@earthlink.net>
> > > > Date:   Tue Dec 19 18:42:16 2006 +0100
> > > >
> > > >     [ALSA] ac97 - fix microphone and line_in selection logic
> > > >
> > > >     This patch fixes the Microphone and LINE_IN select logic for
> > > >     Analog Devices surround codecs with shared jacks.  The existing
> > > >     code can never utilize the shared jacks for Microphone and LINE_IN
> > > >     due to the reversed jack selection logic.  The patched code
> > > >     correctly selects the shared jack for input if the 'Channel Mode'
> > > >     selector does not specify that the jack is to be used for output.
> > > >     Specifically, in '2ch' mode the Center/LFE jack is used for
> > > >     microphone input and the Surround jack is used for LINE_IN,
> > > >     in '4ch' mode the Center/LFE jack is used for microphone input
> > > >     and the Surround jack is used for output, and in '6ch' mode
> > > >     both jacks are used for output.
> > > >
> > > >     Signed-off-by: Randy Cushman <rcushman_linux@earthlink.net>
> > > >     Signed-off-by: Takashi Iwai <tiwai@suse.de>
> > > >     Signed-off-by: Jaroslav Kysela <perex@suse.cz>
> > > >
> > >
> > > Is 2.6.21-rc3 similarly broken?
> >
> > Yes.
> >
>
> OK.  Can you please confirm that applying the below fixes 2.6.21-rc3?

Yes, I can confirm that.

>
> If so, I'll queue it up for application in a week or two if there is no
> progress on this.
>

Regards,
Michal

-- 
Michal K. K. Piotrowski
LTG - Linux Testers Group (PL)
(http://www.stardust.webpages.pl/ltg/)
LTG - Linux Testers Group (EN)
(http://www.stardust.webpages.pl/linux_testers_group_en/)
