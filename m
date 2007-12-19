Return-Path: <linux-kernel-owner+w=401wt.eu-S1753870AbXLSSZH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753870AbXLSSZH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Dec 2007 13:25:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752252AbXLSSY4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Dec 2007 13:24:56 -0500
Received: from mu-out-0910.google.com ([209.85.134.185]:11071 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751053AbXLSSYz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Dec 2007 13:24:55 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:content-transfer-encoding:in-reply-to:user-agent;
        b=Zm6Xs1SrysbfFLXXp75I/psvJeoQV2K2wsmx2UaqasyTewHCuOyjEsFdAAiE7LownfmMfcCTUfhRlQ5feCdw7R5s1/l0NRkF/QBzX05/CoIChHnrX/m2cYEKPGfsR0OBoQM5h71pArQtjcQh7MQESUZcS+nKxPvhK50ts5BERHg=
Date: Wed, 19 Dec 2007 19:26:26 +0100
From: Marcin Slusarz <marcin.slusarz@gmail.com>
To: Takashi Iwai <tiwai@suse.de>
Cc: perex@perex.cz, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] sound/core.h: include sound/driver.h
Message-ID: <20071219182622.GB18104@joi>
References: <20071208205040.GG5087@joi> <s5hwsrh5yjt.wl%tiwai@suse.de> <20071216015825.GA26986@joi> <s5hsl211xeu.wl%tiwai@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <s5hsl211xeu.wl%tiwai@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 17, 2007 at 10:30:01AM +0100, Takashi Iwai wrote:
> At Sun, 16 Dec 2007 02:58:31 +0100,
> Marcin Slusarz wrote:
> >
> > On Fri, Dec 14, 2007 at 12:02:46PM +0100, Takashi Iwai wrote:
> > > At Sat, 8 Dec 2007 21:50:45 +0100,
> > > Marcin Ślusarz wrote:
> > > >
> > > > sound/core.h: include sound/driver.h
> > > >
> > > > include sound/driver.h in sound/core.h because core.h
> > > > uses SNDRV_CARDS (which is defined in sound/driver.h)
> > > >
> > > > Signed-off-by: Marcin Ślusarz <marcin.slusarz@gmail.com>
> > >
> > > Right now I have another (bigger) change for this include path, so
> > > this patch won't be needed any more.
> > >
> > > I applied the patches to sound/* except for this one and
> > > sound/memory.c.   Thanks!
> > >
> > Is there anything wrong with patch for rawmidi [1]?
>
> Ah, sorry, forgot to mention it.
>
> I'm still considering whether it's the best way.  The changes look
> exaggerated just for fixing sparse warnings.

It think it will let future code inspections a bit easier.
But if you have a better idea how to fix it, let me know.

Marcin
