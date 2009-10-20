Return-Path: <linux-kernel-owner+w=401wt.eu-S1756155AbZJTH1J@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756155AbZJTH1J (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Oct 2009 03:27:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756078AbZJTH1I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Oct 2009 03:27:08 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:51326 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755720AbZJTH0y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Oct 2009 03:26:54 -0400
Date: Tue, 20 Oct 2009 09:26:52 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Paul Fertser <fercerpav@gmail.com>
Cc: Anton Vorontsov <cbou@mail.ru>, David Woodhouse <dwmw2@infradead.org>,
       linux-kernel@vger.kernel.org,
       Nelson Castillo <arhuaco@freaks-unidos.net>,
       Balaji Rao <balajirrao@openmoko.org>
Subject: Re: [PATCH] power: pcf50633: introduces battery charging current
 control
Message-ID: <20091020072652.GD29579@elf.ucw.cz>
References: <1255471148-29047-1-git-send-email-fercerpav@gmail.com>
 <1255471148-29047-2-git-send-email-fercerpav@gmail.com>
 <20091017170124.GB1526@ucw.cz>
 <20091020000121.GC19580@home.pavel.comp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091020000121.GC19580@home.pavel.comp>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > > @@ -31,6 +31,8 @@ struct pcf50633_platform_data {
> > >  
> > >  	int charging_restart_interval;
> > >  
> > > +	int chg_ref_current_ma;
> > > +
> > 
> > ...and variable names? This is also inconsistent with name above.
> 
> I added a comment explaining what this value is supposed to be set
> to. The name is borrowed directly from the datasheet where it is
> called "charger reference current". I hope this is ok.

Can you call it "charging_reference_current_ma_" (or maybe
charging_reference_ma, or something), then? You chave
"charging_restart_interval" just above. Having both charging_ and chg_
prefixes is strange, and chg_ really does not hint at charging (I'd
read it "change").
									Pavel

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
