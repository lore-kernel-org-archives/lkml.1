Return-Path: <linux-kernel-owner+w=401wt.eu-S1758020AbYLMOi4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758020AbYLMOi4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Dec 2008 09:38:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756034AbYLMOit
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 13 Dec 2008 09:38:49 -0500
Received: from mail-bw0-f21.google.com ([209.85.218.21]:34618 "EHLO
	mail-bw0-f21.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752132AbYLMOis (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Dec 2008 09:38:48 -0500
X-Greylist: delayed 430 seconds by postgrey-1.27 at vger.kernel.org; Sat, 13 Dec 2008 09:38:48 EST
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=vqLkfjFTKX7RX8axUZK5K0JO4BFP77sWc92GzdFF9HAJvRviDmqT8BFa8z2tQRpNJj
         ym4/cL9PnowwoSg1H4Tat1rYLOoZQy9dgs2rpaSzUOi8a2CcQq+KXhWbJUzE4Hhu8BOY
         BFro5KXmob46TcP0jssR3ZuAnjYTf8Ezl3F1Y=
Subject: Re: [ath5k-devel] Bugs on aspire one A150
From: Maxim Levitsky <maximlevitsky@gmail.com>
To: Bob Copeland <me@bobcopeland.com>
Cc: Nick Kossifidis <mickflemm@gmail.com>, ath5k-devel@venema.h4ckr.net,
       linux-kernel@vger.kernel.org
In-Reply-To: <20081213142444.GA19852@hash.localnet>
References: <491506DB.1070000@gmail.com>
	 <b6c5339f0811100851t1fd9a180pfe24312081885467@mail.gmail.com>
	 <4918A8C5.3050607@gmail.com>
	 <40f31dec0811101412n1a4faf86sf4b1f37bb41caef9@mail.gmail.com>
	 <1229174904.4964.5.camel@maxim-laptop>
	 <20081213142444.GA19852@hash.localnet>
Content-Type: text/plain
Date: Sat, 13 Dec 2008 16:31:27 +0200
Message-Id: <1229178687.4936.13.camel@maxim-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2008-12-13 at 09:24 -0500, Bob Copeland wrote:
> [trimmed a couple of lists from CC]
> 
> On Sat, Dec 13, 2008 at 03:28:24PM +0200, Maxim Levitsky wrote:
> > > i think that some led settings are stored on EEPROM, let me check it out...
> > 
> > Indeed gpio #3 controls the led.
> > I patched ath5k to use it, and led works now fine.
> 
> BTW I looked for settings in EEPROM and didn't find any.
Then maybe create a whitelist of vendors vs gpio numbers?
Also a module param to set the gpio pin won't hurt.



> 
> > What I dislike is the way led blinks:
> 
> This is something that should rather change in mac80211, I think.  It 
> just toggles the state on every packet, and we just do the same when
> mac80211 says so (ath5k *could* set up timers like b43, but it's a
> lot of extra code, and every driver shouldn't have to do so.)
> 

IWL3945 sets timers too, and this does look ugly.

Also I noticed that sometimes led state gets inverted and it stuck until
I reload the module.

Best regards,
	Maxim Levitsky

