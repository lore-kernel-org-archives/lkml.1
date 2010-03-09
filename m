Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755469Ab0CISKs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Mar 2010 13:10:48 -0500
Received: from mail-fx0-f213.google.com ([209.85.220.213]:58888 "EHLO
	mail-fx0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755398Ab0CISKp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Mar 2010 13:10:45 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        b=r/v3wQ96Rjl6pVe5pCL0zvnOW2nLJTjASJ/FKMnoi+R1kc8Tn+5vKct2ajuizTrF7k
         OHZD1BUEnLCGZ0R139Lx4UjIxTn4gZhN3RjlT6dcl07XB+v1ZcEQzksMNTNkuAv8CqEa
         kPNRDnfeL/b6m98SLrVRRjLUVpp4zwQCTnBVU=
Date: Tue, 9 Mar 2010 10:10:37 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Mike Frysinger <vapier.adi@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-input@vger.kernel.org,
       Michael Hennerich <michael.hennerich@analog.com>,
       Robin Getz <rgetz@blackfin.uclinux.org>
Subject: Re: [git pull] Input updates for 2.6.34-rc0
Message-ID: <20100309181037.GB19814@core.coreip.homeip.net>
References: <20100301080342.GH765@core.coreip.homeip.net>
 <8bd0f97a1003090644p19fb7dacqe1f2fb3adee3fa7a@mail.gmail.com>
 <20100309175107.GB23378@core.coreip.homeip.net>
 <8bd0f97a1003090958i741f4ffm3528450e89089e9@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <8bd0f97a1003090958i741f4ffm3528450e89089e9@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 09, 2010 at 12:58:24PM -0500, Mike Frysinger wrote:
> On Tue, Mar 9, 2010 at 12:51, Dmitry Torokhov wrote:
> > On Tue, Mar 09, 2010 at 09:44:08AM -0500, Mike Frysinger wrote:
> >> On Mon, Mar 1, 2010 at 03:03, Dmitry Torokhov wrote:
> >> > Hi Linus,
> >> >
> >> > Please pull from:
> >> >
> >> >        git://git.kernel.org/pub/scm/linux/kernel/git/dtor/input.git for-linus
> >> > or
> >> >        master.kernel.org:/pub/scm/linux/kernel/git/dtor/input.git for-linus
> >> >
> >> > to receive first round of updates for the input subsystem.
> >>
> >> i'm trying to figure out what the problem is with the ADXL34x and
> >> AD714x drivers you seem to have accepted (at least, you didnt say
> >> there was anything left for us to do).  i would have expected them to
> >> be in 2.6.33/2.6.34 already, but it seems they arent moving now.  so
> >> what's up ?
> >
> > I am still spooked by the fact that this is an accelerometer and does
> > not have to be an input device but maybe used for different purposes as
> > well.
> 
> the AD714x is not an accelerometer, it's a capacitance touch sensor
>

OK, will dig it up.
 
> i understand the ADXL34x is a bit wonky, but what else would you
> propose ?  or just leave the driver in limbo forever until people
> forget about it ?

No, just till we have proper framework for it to be merged into.

-- 
Dmitry
