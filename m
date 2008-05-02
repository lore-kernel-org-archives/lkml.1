Return-Path: <linux-kernel-owner+w=401wt.eu-S935446AbYEBUge@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935446AbYEBUge (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 May 2008 16:36:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S936349AbYEBUgN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 May 2008 16:36:13 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.31.123]:46221 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934090AbYEBUgK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 May 2008 16:36:10 -0400
Date: Fri, 2 May 2008 22:35:54 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Cc: Jean Delvare <khali@linux-fr.org>, Matthew <jackdachef@gmail.com>,
       Rudolf Marek <r.marek@assembler.cz>,
       Maxim Levitsky <maximlevitsky@gmail.com>, trenn@suse.de,
       Kasper Sandberg <lkml@metanurb.dk>, Len Brown <lenb@kernel.org>,
       linux-acpi@vger.kernel.org, torvalds@linux-foundation.org,
       linux-kernel@vger.kernel.org, "Zhang, Rui" <rui.zhang@intel.com>
Subject: Re: Linux 2.6.25 (coretemp reads high temperatures)
Message-ID: <20080502203553.GE3956@ucw.cz>
References: <e85b9d30804180837y39c52e26i588e4b67c87a5e9d@mail.gmail.com> <200804182151.49021.lenb@kernel.org> <200804231143.10875.maximlevitsky@gmail.com> <1209406784.11608.15.camel@localhost> <1209474423.1784.837.camel@queen.suse.de> <20080429170824.09540206@hyperion.delvare> <48179DB4.8040701@assembler.cz> <e85b9d30804291558r4051f1bbm9256aa2af2d86b6c@mail.gmail.com> <20080430081035.2e789a50@hyperion.delvare> <20080430144655.GB3543@khazad-dum.debian.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20080430144655.GB3543@khazad-dum.debian.net>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > On Wed, 30 Apr 2008 00:58:50 +0200, Matthew wrote:
> > > so we were just too concerned all the time & even though the
> > > temperatures seem too high there's nothing to worry ?
> > 
> > Yes.
> 
> So the big deal here is that there is no "°C" anywhere in this
> measurement, it is in an arbitrary hardware scale?
> 
> > > but like lm_sensors's output states - it's not bad until  I / we're
> > > getting temperatures from 85°C (?) [in this particular case], ...
> > 
> > If I remember correctly, at 84°C your CPU will start to throttle, at
> > 100°C it will shut down. You still have 24°C before the former happens,
> > so it should be OK.
> 
> Better drop the °C from there.  It starts throttling at 84 ITUs and
> shuts down at 100 ITUs (Intel Thermal Units :p).

degrees Intel? :-)

If t1-t2 == 1ITU, is that 1degC?

> -- 
>   "One disk to rule them all, One disk to find them. One disk to bring
>   them all and in the darkness grind them. In the Land of Redmond
>   where the shadows lie." -- The Silicon Valley Tarot
>   Henrique Holschuh
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
