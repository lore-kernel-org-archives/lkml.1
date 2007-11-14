Return-Path: <linux-kernel-owner+w=401wt.eu-S1757852AbXKNOO7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757852AbXKNOO7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2007 09:14:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754772AbXKNOOs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Nov 2007 09:14:48 -0500
Received: from an-out-0708.google.com ([209.85.132.251]:37321 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754607AbXKNOOr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2007 09:14:47 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=f0PedGwVxAI+S/W0AZtSlKSJ/fli3pzSQxOHWwkaSqb1+ctdKMYMQIj3z5Y3nQrSh3HfahlFlkoOFPA0dyqtnvsFp5EEbc+G6Rf0eNXdSjKjJenhrdA9Twwq9c4CSOUseS3skfrMLN3Gd+57E1cqCa4e+fc8Uc04S2rRaGfzdsw=
Message-ID: <b637ec0b0711140614s143d053ame7a3f13884c29bf4@mail.gmail.com>
Date: Wed, 14 Nov 2007 15:14:46 +0100
From: "Fabio Comolli" <fabio.comolli@gmail.com>
To: "Pavel Machek" <pavel@ucw.cz>
Subject: Re: [BUG] New Kernel Bugs
Cc: "Andrew Morton" <akpm@linux-foundation.org>,
       "Natalie Protasevich" <protasnb@gmail.com>,
       linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       alsa-devel@alsa-project.org, linux-ide@vger.kernel.org,
       linux-pcmcia@lists.infradead.org, linux-input@atrey.karlin.mff.cuni.cz,
       bugme-daemon@bugzilla.kernel.org
In-Reply-To: <20071114132448.GA5183@ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <32209efe0711122242m3a5f081asf1c11a38b24db10c@mail.gmail.com>
	 <20071113031553.3c7b5c16.akpm@linux-foundation.org>
	 <20071114132448.GA5183@ucw.cz>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

FWIW, I see the same problem with another HP notebook, DV4378EA with
radeon X700 video card. It does not happen frequently but I can say
that since I disabled the tickless feature I can't reproduce the
problem anymore.

On Nov 14, 2007 2:24 PM, Pavel Machek <pavel@ucw.cz> wrote:
> Hi!
>
> > > Suspend to RAM resume hangs on a tickless (NO_HZ) kernel
> > > http://bugzilla.kernel.org/show_bug.cgi?id=9275
> > > Kernel: 2.6.23
> > > This is HP notebook nc6320 T2400 945GM
> >
> > No response from developers
>
> Maybe I'm optimistic, but I expected Ingo/Thomas to look after nohz
> problems. nohz=off highres=off fixes more than one suspend problem...
>
> ...stuff I've seen with NOHZ even without suspend (cursor blinking
> irregulary) make me think that nohz perhaps should not be used in
> production just yet...
>
>                                                         Pavel
> --
> (english) http://www.livejournal.com/~pavelmachek
> (cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
>
> -
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
