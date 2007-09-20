Return-Path: <linux-kernel-owner+w=401wt.eu-S1752332AbXITTm4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752332AbXITTm4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2007 15:42:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751799AbXITTms
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Sep 2007 15:42:48 -0400
Received: from an-out-0708.google.com ([209.85.132.246]:36981 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751151AbXITTmr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2007 15:42:47 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:to:subject:message-id:mail-followup-to:references:mime-version:content-type:content-disposition:in-reply-to:user-agent:from;
        b=RJrwiPozk/0SOKFt9lXKcKH4jQ4dadZ2GdCdZu3nFXCO6nyWazqzW1v6C+uDSt1271Kq/rs28Kd+J54g1aRICbvaq2ymB0NPGsdRqJvFS4EFPVm8cnz3etVdtFd1ENnwyN76Yh4ykqp6oOtvpY1CueywwsdVZ4nPoEZHyEGQCBo=
Date: Thu, 20 Sep 2007 15:42:31 -0400
To: Paul Mundt <lethal@linux-sh.org>, Michael Buesch <mb@bu3sch.de>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH -mm] ssb: Make pcmciahost depend on PCMCIA=y
Message-ID: <20070920194231.GB31759@nineveh.local>
Mail-Followup-To: Paul Mundt <lethal@linux-sh.org>,
	Michael Buesch <mb@bu3sch.de>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-kernel@vger.kernel.org
References: <20070912021100.GB26827@linux-sh.org> <200709121209.10068.mb@bu3sch.de> <20070912101745.GA23417@linux-sh.org> <200709121259.00700.mb@bu3sch.de> <20070913014333.GA26541@linux-sh.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070913014333.GA26541@linux-sh.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
From: jfannin@gmail.com (Joseph Fannin)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 13, 2007 at 10:43:33AM +0900, Paul Mundt wrote:
> On Wed, Sep 12, 2007 at 12:59:00PM +0200, Michael Buesch wrote:
> > On Wednesday 12 September 2007 12:17:45 Paul Mundt wrote:
> > > On Wed, Sep 12, 2007 at 12:09:09PM +0200, Michael Buesch wrote:
> > > > There we go. The usual SELECT dependency hell again...
> > > > Would changing SSB_PCMCIAHOST_POSSIBLE to tristate also fix it?
> > > > What would be the sideeffects?
> > > >
> > > I tried that first, if you do that you have to change the default to
> > > SSB && PCMCIA, and then anything that depends on it also has to be a
> > > tristate. That worked ok for SSB_PCMCIAHOST, but it didn't work ok for
> > > the b43 wireless + PCMCIA, which is why I opted for the PCMCIA=y thing
> > > instead, which makes sure that SSB_PCMCIAHOST can't be enabled if PCMCIA
> > > is modular.
> >
> > Ok, so much for "SELECT is easy and it works if used correctly..." :)
> > Well, let's apply that patch then. It needlessly restricts the
> > choice to not allow modular pcmcia in that case, though.
> >
> That is the compromise, yes. Feel free to propose a better solution ;-)

    I just ran into this link error (CONFIG_PCMCIA=m;
CONFIG_SSB_PCMCIAHOST=y).  No big deal; I don't have the hardware.

    But yeah, this is still a problem.

> -
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>

--
Joseph Fannin
jfannin@gmail.com

