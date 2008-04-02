Return-Path: <linux-kernel-owner+w=401wt.eu-S1755707AbYDBMtn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755707AbYDBMtn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2008 08:49:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753812AbYDBMtg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Apr 2008 08:49:36 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:1695 "EHLO spitz.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753073AbYDBMtg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2008 08:49:36 -0400
Date: Wed, 2 Apr 2008 14:49:23 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: perex@perex.cz, linux-kernel@vger.kernel.org, tiwai@suse.de
Subject: Re: usb audio: Fix another Dallas quirk
Message-ID: <20080402124922.GA5321@ucw.cz>
References: <20080329223241.GA5348@elf.ucw.cz> <20080401122000.83ce5a3e.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080401122000.83ce5a3e.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 2008-04-01 12:20:00, Andrew Morton wrote:
> On Sat, 29 Mar 2008 23:32:41 +0100
> Pavel Machek <pavel@suse.cz> wrote:
> 
> > 
> > Dallas USB speakers are buggy in more than one way. One of configs
> > they offer does not work at all.
> > 
> > Signed-off-by: Pavel Machek <pavel@suse.cz>
> > 
> > diff --git a/sound/usb/usbaudio.c b/sound/usb/usbaudio.c
> > index 257a4e1..b6b2490 100644
> > --- a/sound/usb/usbaudio.c
> > +++ b/sound/usb/usbaudio.c
> >  	int format;
> >  	struct audioformat *fp;
> >  	unsigned char *fmt, *csep;
> > +	int num;
> 
> This is not a patch - something munched the "@@ -2676,12 +2676,23 @@"
> line.
> 
> I typed it in again.

Thanks a lot. I guess I did something wrong when hand-editing it.

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
