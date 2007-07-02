Return-Path: <linux-kernel-owner+w=401wt.eu-S1758536AbXGBLnj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758536AbXGBLnj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jul 2007 07:43:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753578AbXGBLnc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Jul 2007 07:43:32 -0400
Received: from neon.samage.net ([85.17.153.66]:40291 "EHLO neon.samage.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753482AbXGBLnb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jul 2007 07:43:31 -0400
Message-ID: <51563.81.207.0.53.1183376603.squirrel@secure.samage.net>
Date: Mon, 2 Jul 2007 13:43:23 +0200 (CEST)
Subject: Re: blink driver power saving
From: "Indan Zupancic" <indan@nul.nu>
To: "Andi Kleen" <ak@suse.de>
Cc: "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Stephen Hemminger" <shemminger@linux-foundation.org>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org,
       "" Dmitry Torokhov "" <dtor@insightbb.com>
User-Agent: SquirrelMail/1.4.8
MIME-Version: 1.0
Content-Type: text/plain;charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Priority: 3 (Normal)
Importance: Normal
X-Spam-Score: -1.8
X-Scan-Signature: b011d5308189b8f364b008c39e0eea9f
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, July 2, 2007 01:59, Andi Kleen wrote:
> Well only those that could be already hung from user space
> with setleds (that was also confirmed).  Actually I thought
> they didn't hang completely, but just stopped reacting to
> the keyboard (which is actually pretty bad for every user
> to be able to trigger)

Pavel's lost key events, mine stopped reacting altogether.

> I guess the better way to handle those would be to find out the
> minimum frequency of blinking that is still ok and rate limit it to that in
> the keyboard driver.

Dmitry already has a patch for that. He limited it to one event each 50 ms.

> Anyways, Stephen's patch just doesn't make sense:
> he clearly didn't understand the code at all. Before you
> apply it and cripple it better drop the driver completely.

CC'ing Dmitry, as I think he doesn't like the blink driver much either. ;-)

Greetings,

Indan


