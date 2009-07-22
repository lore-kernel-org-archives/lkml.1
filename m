Return-Path: <linux-kernel-owner+w=401wt.eu-S1753594AbZGVQij@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753594AbZGVQij (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jul 2009 12:38:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753531AbZGVQii
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Jul 2009 12:38:38 -0400
Received: from rv-out-0506.google.com ([209.85.198.228]:8765 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753512AbZGVQih (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jul 2009 12:38:37 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=Z21ALCMp3mb9pIzTGFC6wtt235IHscFSPqqVK5bB9il0hXbwCidpbhzrs73Nlmqkgg
         DjMpGP7FZpaZHF6JhgwWI5sX9B+a/uM8Hc5VrQNsc2JWyT3NOf1cdaEmXtmn55e7/8oJ
         w5yX2GJJ5JDOi6e2PKfo8aiR8tL5dp99+Xf1I=
Date: Wed, 22 Jul 2009 09:38:33 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Alan Jenkins <sourcejedi.lkml@googlemail.com>
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC/RFT] serio - switch to using dev_pm_ops
Message-ID: <20090722163832.GB2775@dtor-d630.eng.vmware.com>
References: <20090721080612.GC10168@dtor-d630.eng.vmware.com> <9b2b86520907211448t24a091e2i6d8ad89f709f35ff@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9b2b86520907211448t24a091e2i6d8ad89f709f35ff@mail.gmail.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 21, 2009 at 10:48:05PM +0100, Alan Jenkins wrote:
> >  drivers/input/serio/serio.c |   30 ++++++++++++++++--------------
> >  1 files changed, 16 insertions(+), 14 deletions(-)
> 
> > -	if (!serio->suspended && state.event == PM_EVENT_SUSPEND)
> > -		serio_cleanup(serio);
> > -
> > -	serio->suspended = state.event == PM_EVENT_SUSPEND ||
> > -			   state.event == PM_EVENT_FREEZE;
> 
> > -	if (serio->suspended) {
> > -		serio->suspended = false;
> > -		serio_queue_event(serio, NULL, SERIO_RECONNECT_PORT);
> > -	}
> 
> It looks like you should be able to remove the suspended field of
> struct serio.  Or is it used somewhere else?
> 

No, it is not needed now, thanks for noticing.

-- 
Dmitry
