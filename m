Return-Path: <linux-kernel-owner+w=401wt.eu-S1755023AbZJJWun@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755023AbZJJWun (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Oct 2009 18:50:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754771AbZJJWum
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Oct 2009 18:50:42 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:42795 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753268AbZJJWum (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Oct 2009 18:50:42 -0400
Date: Sun, 11 Oct 2009 00:49:58 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Cc: Alexey Starikovskiy <astarikovskiy@suse.de>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
       linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] battery: Fix charge_now returned by broken batteries
Message-ID: <20091010224958.GA15826@elf.ucw.cz>
References: <4AC91578.2020807@suse.de>
 <ca2dc2820910041455h18ece909rc2280a40f1899c0a@mail.gmail.com>
 <4AC923F4.9050100@suse.de>
 <ca2dc2820910041653o29d4b253n69270d231e56e447@mail.gmail.com>
 <4AC93B45.8090707@suse.de>
 <ca2dc2820910061005k2beae176lece9792bb15cda90@mail.gmail.com>
 <20091010120448.GB1811@ucw.cz>
 <ca2dc2820910101353g65e4591ds82bf9fff8378abd4@mail.gmail.com>
 <20091010212521.GD14051@elf.ucw.cz>
 <ca2dc2820910101444v16b44645se826ae2bfbdb90a3@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ca2dc2820910101444v16b44645se826ae2bfbdb90a3@mail.gmail.com>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat 2009-10-10 23:44:42, Miguel Ojeda wrote:
> On Sat, Oct 10, 2009 at 11:25 PM, Pavel Machek <pavel@ucw.cz> wrote:
> > Hi!
> >
> >> >> In "broken" batteries (is it broken finally? or is it expected
> >> >> behaviour?) like mine the old problem will be corrected, as it was
> >> >> only present in the charged state.
> >> >
> >> > I believe you better work around this in userspace... or agree that
> >> >>100% charge is possible.
> >>
> >> I agree that >100% charge is possible while charging (because that
> >> would mean the battery is over the last charged level); however, what
> >> does it mean when charged?
> >
> > Well, maybe the battery only updates full_charge_capacity during
> > powerdown or when the moon is full or something? (IOW you may be
> > breaking already working machines).
> >
> 
> I do not know about batteries as I said, I was waiting for someone to
> point out how batteries (normally/should) work.

Different batteries work very differently, I'm afraid.

> > Or perhaps add quirk based on DMI or something?
> 
> My battery is easily identified by its model name, so maybe we can
> apply the workaround only to known hardware. Still, that is a "heavy"
> solution, as I suppose there are many many battery models in the
> world. That is why I was asking whether some kind of standard/unified
> batteries' values/behavior exists (or implement it) that we can try to
> achieve easily with some heuristics like the one I proposed, instead
> of some kind of huge table-based workaround system.

The heuristics you proposed _will_ break other batteries, so it is not
acceptable without checking for model first.
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
