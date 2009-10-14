Return-Path: <linux-kernel-owner+w=401wt.eu-S932833AbZJNLPZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932833AbZJNLPZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Oct 2009 07:15:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932595AbZJNLPY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Oct 2009 07:15:24 -0400
Received: from mail-fx0-f227.google.com ([209.85.220.227]:35381 "EHLO
	mail-fx0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756251AbZJNLPX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Oct 2009 07:15:23 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=Fzm5BYpb15pqMvkjY7RCysVMQiCKLHuqvSLkEYjFLencrtiJ9WQi4IkaB9XgcYDUf+
         D4SVjueV4bfoa+RnazYax09Qk838pFJX2jrl3hxMxasJulZdhySNA4t10SNW0Lr+Jngh
         BKwKh475RDLUuwYgZ4gXgc8CUjLhaNSANi+qs=
Date: Wed, 14 Oct 2009 13:13:25 +0200
From: "Carlos R. Mafra" <crmafra2@gmail.com>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: linux-kernel@vger.kernel.org, "Rafael J. Wysocki" <rjw@sisk.pl>,
       linux-input@vger.kernel.org
Subject: Re: [bisected regression] Touchpad "paste" stops working after
	suspend to RAM
Message-ID: <20091014111325.GA4586@Pilar.aei.mpg.de>
References: <20091013121109.GB4619@Pilar.aei.mpg.de> <20091013182643.GC21593@core.coreip.homeip.net> <20091013190819.GA7555@Pilar.aei.mpg.de> <20091013194654.GD21593@core.coreip.homeip.net> <20091013202459.GE21593@core.coreip.homeip.net> <20091013231641.GA4404@Pilar.aei.mpg.de> <20091013235607.GA28819@core.coreip.homeip.net> <20091013235701.GB28819@core.coreip.homeip.net> <20091014005131.GA4371@Pilar.aei.mpg.de> <20091014023008.GA29672@core.coreip.homeip.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091014023008.GA29672@core.coreip.homeip.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 13.Oct'09 at 19:30:08 -0700, Dmitry Torokhov wrote:
> On Wed, Oct 14, 2009 at 02:51:31AM +0200, Carlos R. Mafra wrote:
> > On Tue 13.Oct'09 at 16:57:01 -0700, Dmitry Torokhov wrote:
> > > On Tue, Oct 13, 2009 at 04:56:08PM -0700, Dmitry Torokhov wrote:
> > > > On Wed, Oct 14, 2009 at 01:16:41AM +0200, Carlos R. Mafra wrote:
> > > > > [restoring Cc: list]
> > > > > 
> > > > > On Tue 13.Oct'09 at 13:24:59 -0700, Dmitry Torokhov wrote:
> > > > > >
> > > > > > Could you please try this patch (again if you could post dmesg that
> > > > > > would be great). Thank you!
> > > > > 
> > > > > The patch quoted below also fixes the problem. I attached the
> > > > > syslog with i8042.debug (with a s2ram in the middle) to the
> > > > > bugzilla: 
> > > > > 
> > > > > http://bugzilla.kernel.org/show_bug.cgi?id=14392
> > > > > 
> > > > 
> > > > Still not quite happy, although it is better. I don't understand why
> > > > your box likes to reply on AUX port when command is sent via keyboard
> > > > port.
> > > > 
> > > > Could you please try booting with atkbd.reset (I assume keyboard is
> > > > built in) and send me yet another dmesg.
> > > > 
> > > 
> > > Oh, yes, keep the last patch applied. Thanks!
> > 
> > I uploaded the dmesg with atkbd.reset (and i8042.debug too, btw)
> > to the bugzilla.
> > 
> 
> Hmm, this is messed up... For some reason your box insists on replying
> to reset commands from AUX port, no matter what device we trying to
> reset. Does your box (Vaio, right?) has external PS/2 ports? I don't
> believe Vaios have docking stations... 

My Vaio has no PS/2 port and no docking station.

> Also, could you please boot with
> i8042.nomux and send me yet another dmesg and dmidecode too.

Ok, they are in the kernel bugzilla #14392 now.

> Thanks for your patience.

I thank _you_ for digging the problem even further. Your proposed patch
"fixed" it already for me, but you are being honest in saying that
you are still not happy with your fix and want to do better. I really
appreciate that and will help you with what I can do. I hope there is
a way out of my Vaio's oddities.
