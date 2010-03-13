Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932866Ab0CMIo0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Mar 2010 03:44:26 -0500
Received: from mail-yx0-f174.google.com ([209.85.210.174]:62501 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755432Ab0CMIoY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Mar 2010 03:44:24 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=kiDZOKj1HmpvAGg+WLxYFqt1+oFvGZ/Q4ZV17dOf/de894WflaMuB2g+0OXE5PvgSU
         3keIdaXGPAIBY5g9ZcW06iftxdnCwzLhXCayYqhw8ll2qjmPesvZ8iPFfssaR7ZfXVh3
         azLjoxMyMFOvMq86Mw233twzNqUCvApAZ6naU=
Date: Sat, 13 Mar 2010 00:44:19 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Robin Getz <rgetz@blackfin.uclinux.org>
Cc: "Hennerich, Michael" <Michael.Hennerich@analog.com>,
       Mike Frysinger <vapier.adi@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-input@vger.kernel.org" <linux-input@vger.kernel.org>
Subject: Re: [git pull] Input updates for 2.6.34-rc0
Message-ID: <20100313084419.GE22494@core.coreip.homeip.net>
References: <20100301080342.GH765@core.coreip.homeip.net>
 <201003091439.49023.rgetz@blackfin.uclinux.org>
 <544AC56F16B56944AEC3BD4E3D5917712D6B1D98DB@LIMKCMBX1.ad.analog.com>
 <201003121555.37998.rgetz@blackfin.uclinux.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201003121555.37998.rgetz@blackfin.uclinux.org>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 12, 2010 at 03:55:37PM -0500, Robin Getz wrote:
> On Wed 10 Mar 2010 03:30, Hennerich, Michael pondered:
> > Robin Getz wrote on 2010-03-09:
> > > On Tue 9 Mar 2010 13:20, Dmitry Torokhov pondered:
> > >> On Tue, Mar 09, 2010 at 01:13:34PM -0500, Mike Frysinger wrote:
> > >>> On Tue, Mar 9, 2010 at 13:10, Dmitry Torokhov wrote:
> > >>>> On Tue, Mar 09, 2010 at 12:58:24PM -0500, Mike Frysinger wrote:
> > >>>>> On Tue, Mar 9, 2010 at 12:51, Dmitry Torokhov wrote:
> > >>>>>> On Tue, Mar 09, 2010 at 09:44:08AM -0500, Mike Frysinger
> > > wrote:
> > > [snip]
> > >>>>> i understand the ADXL34x is a bit wonky, but what else would you
> > >>>>> propose ?  or just leave the driver in limbo forever until people
> > >>>>> forget about it ?
> > >>>>
> > >>>> No, just till we have proper framework for it to be merged into.
> > >>>
> > >>> that sounds fine, but is there actually something in progress for
> > >>> that ?  waiting for a framework no one is working on is the same
> > >>> in practice ...
> > >>
> > >> I have high hopes that IIO will fill the needs of these kinds of
> > > devices.
> > >
> > > The fact of things is that many people are using this as pointing device.
> > >
> > > I'm not convinced that IIO is the best place for these types of
> > > things...
> > 
> > Very true - this driver was originally targeted and designed as a 
> > typical human interface input device. 
> > 
> 
> Dmitry:
> 
> Care to comment? I would prefer to come to some sort of conclusion. As Mike 
> said - leaving the driver in limbo forever isn't really a solution for 
> anyone....

OK, you swayed my opinion about 3-axis accelerometers, I will review the
patch again (although IIRC I was pretty satisfied with it) and apply.

-- 
Dmitry
