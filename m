Return-Path: <linux-kernel-owner+w=401wt.eu-S1752099AbYKKSuq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752099AbYKKSuq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2008 13:50:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750924AbYKKSuf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Nov 2008 13:50:35 -0500
Received: from rn-out-0910.google.com ([64.233.170.191]:1867 "EHLO
	rn-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750898AbYKKSue (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2008 13:50:34 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=tUH7puFEucw35bRn+Qt2EwwFBRjA1O1lm7+SB535GuOdLkGWVpf8+4Mx9RgBiIwR5y
         NuU8p78aE98df7wEXuu1JGvnqRDbSkBWeTXUFcWjOo1J29MLJiA6qcnKdM5RJyWub693
         qJZ2bB0oTd13ZiLapQPtieJbGfUz28o+0Q3vA=
Date: Tue, 11 Nov 2008 13:50:30 -0500
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Jiri Kosina <jkosina@suse.cz>
Cc: Henrik Rydberg <rydberg@euromail.se>,
       Andrew Morton <akpm@linux-foundation.org>, linux-input@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] input: Map missing keys to appropriate functions
Message-ID: <20081111134955.ZZRA012@mailhub.coreip.homeip.net>
References: <491040AA.7010208@euromail.se> <alpine.LNX.1.10.0811111826270.24889@jikos.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LNX.1.10.0811111826270.24889@jikos.suse.cz>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 11, 2008 at 06:27:42PM +0100, Jiri Kosina wrote:
> On Tue, 4 Nov 2008, Henrik Rydberg wrote:
> 
> > On macbooks there are specific keys for the user-space functions Expose
> > and Dashboard, which currently has no counterpart in input.h. This patch
> > adds KEY_SCALE and KEY_DASHBOARD, and maps the keyboard accordingly.
> > Signed-off-by: Henrik Rydberg <rydberg@euromail.se>
> > ---
> >  drivers/hid/hid-apple.c |    5 +++--
> >  include/linux/input.h   |    2 ++
> [ ... ]
> > diff --git a/include/linux/input.h b/include/linux/input.h
> > index b86fb55..5341e82 100644
> > --- a/include/linux/input.h
> > +++ b/include/linux/input.h
> > @@ -238,6 +238,7 @@ struct input_absinfo {
> >  #define KEY_KPEQUAL		117
> >  #define KEY_KPPLUSMINUS		118
> >  #define KEY_PAUSE		119
> > +#define KEY_SCALE		120	/* AL Compiz Scale (Expose) */
> > 
> >  #define KEY_KPCOMMA		121
> >  #define KEY_HANGEUL		122
> > @@ -322,6 +323,7 @@ struct input_absinfo {
> >  #define KEY_PAUSECD		201
> >  #define KEY_PROG3		202
> >  #define KEY_PROG4		203
> > +#define KEY_DASHBOARD		204	/* AL Dashboard */
> >  #define KEY_SUSPEND		205
> >  #define KEY_CLOSE		206	/* AC Close */
> >  #define KEY_PLAY		207
> 
> Dmitry, could you please Ack this? Is it OK if I take it through my tree, 
> together with the hid-apple mapping update? Thanks.
> 

Sorry, running a bit behind... Yep, please take these through your
tree.

-- 
Dmitry
