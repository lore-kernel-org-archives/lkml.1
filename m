Return-Path: <linux-kernel-owner+w=401wt.eu-S1751540AbZG3OLg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751540AbZG3OLg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jul 2009 10:11:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751198AbZG3OLg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Jul 2009 10:11:36 -0400
Received: from ru.mvista.com ([213.79.90.228]:31770 "EHLO
	buildserver.ru.mvista.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751498AbZG3OLe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jul 2009 10:11:34 -0400
Date: Thu, 30 Jul 2009 18:11:34 +0400
From: Anton Vorontsov <avorontsov@ru.mvista.com>
To: Ian Molton <ian@mnementh.co.uk>
Cc: Daniel Mack <daniel@caiaq.de>, linux-kernel@vger.kernel.org,
       Anton Vorontsov <cbou@mail.ru>, Matt Reimer <mreimer@vpop.net>
Subject: Re: [PATCH 1/2] power_supply: get_by_name and set_charged
	functionality
Message-ID: <20090730141134.GB25759@oksana.dev.rtsoft.ru>
Reply-To: avorontsov@ru.mvista.com
References: <20090723183451.GI13236@buzzloop.caiaq.de>
 <1248374154-15606-1-git-send-email-daniel@caiaq.de>
 <20090728220635.GH19257@buzzloop.caiaq.de>
 <4A70249C.6060705@f2s.com>
 <20090729103659.GI19257@buzzloop.caiaq.de>
 <4A704451.1070004@mnementh.co.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <4A704451.1070004@mnementh.co.uk>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 29, 2009 at 01:45:05PM +0100, Ian Molton wrote:
> Daniel Mack wrote:
> >On Wed, Jul 29, 2009 at 11:29:48AM +0100, Ian molton wrote:
> >>Looks ok. the only comment I have right now is that the comment
> >>doesnt  quite match the patch - it suggests that the patch
> >>doesnt include the  power_supply_set_battery_charged() function,
> >>when it does in fact.
> >
> >The subject mentions it, and the body references it again. Hmm. Anyway.
> >Want me to resend? Or could the commiter add another sentence to point
> >that out? I think that would be Anton, as he agreed to pick all the
> >other patches I recently sent in.
> 
> I'm not that fussed - you just seemed to want feedback, so I had a read ;-)
> 
> If you change it, I'd write something like:
> 
> This adds a function that indicates that a battery is fully charged.
> It also includes functions to get a power_supply device from the
> class of registered devices by name reference. These can be used to
> find a specific battery to call power_supply_set_battery_charged()
> on.
> 
> Some battery drivers might need this information to calibrate
> themselves.

Ian, Matt, much thanks for reviews and acks!
Daniel, thanks for the patches, and for the patience. :-)


Following patches applied to battery-2.6.git (for -next):

Daniel Mack (8):
      ds2760_battery: delay power supply registration
      ds2760_battery: export more features
      ds2760_battery: add rated_capacity module parameter
      ds2760_battery: handle full_active_uAh == 0 case correctly
      ds2760_battery: add current_accum module parameter
      power_supply: EXPORT_SYMBOL cleanups
      power_supply: get_by_name and set_charged functionality
      ds2760_battery: implement set_charged() feature

Let me know if I missed anything.

-- 
Anton Vorontsov
email: cbouatmailru@gmail.com
irc://irc.freenode.net/bd2
