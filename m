Return-Path: <linux-kernel-owner+w=401wt.eu-S1757955AbYLMOZQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757955AbYLMOZQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Dec 2008 09:25:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755991AbYLMOZE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 13 Dec 2008 09:25:04 -0500
Received: from mail.deathmatch.net ([70.167.247.36]:2020 "EHLO
	mail.deathmatch.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752132AbYLMOZB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Dec 2008 09:25:01 -0500
Date: Sat, 13 Dec 2008 09:24:45 -0500
From: Bob Copeland <me@bobcopeland.com>
To: Maxim Levitsky <maximlevitsky@gmail.com>
Cc: Nick Kossifidis <mickflemm@gmail.com>, ath5k-devel@venema.h4ckr.net,
       linux-kernel@vger.kernel.org
Subject: Re: [ath5k-devel] Bugs on aspire one A150
Message-ID: <20081213142444.GA19852@hash.localnet>
References: <491506DB.1070000@gmail.com> <b6c5339f0811100851t1fd9a180pfe24312081885467@mail.gmail.com> <4918A8C5.3050607@gmail.com> <40f31dec0811101412n1a4faf86sf4b1f37bb41caef9@mail.gmail.com> <1229174904.4964.5.camel@maxim-laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1229174904.4964.5.camel@maxim-laptop>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[trimmed a couple of lists from CC]

On Sat, Dec 13, 2008 at 03:28:24PM +0200, Maxim Levitsky wrote:
> > i think that some led settings are stored on EEPROM, let me check it out...
> 
> Indeed gpio #3 controls the led.
> I patched ath5k to use it, and led works now fine.

BTW I looked for settings in EEPROM and didn't find any.

> What I dislike is the way led blinks:

This is something that should rather change in mac80211, I think.  It 
just toggles the state on every packet, and we just do the same when
mac80211 says so (ath5k *could* set up timers like b43, but it's a
lot of extra code, and every driver shouldn't have to do so.)

-- 
Bob Copeland %% www.bobcopeland.com

