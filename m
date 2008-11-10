Return-Path: <linux-kernel-owner+w=401wt.eu-S1754465AbYKJQvU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754465AbYKJQvU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2008 11:51:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753577AbYKJQvM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Nov 2008 11:51:12 -0500
Received: from rv-out-0506.google.com ([209.85.198.238]:31576 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753397AbYKJQvK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2008 11:51:10 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references:x-google-sender-auth;
        b=dSRDhbIeMb12DCraQM4jAP3XDtmWw1I/6/tJ5KZu96l/Ja7XOoLhbsAkmaN8P1GH4y
         zb55xeoisfimoj5CTXEFmUoRSTgqrb6GPxaWN3xOCkSEUg+/JPjVv8+9gTgkup3sXltR
         8r6C+Z2xyMNZgTJNCyrvAU7Z80UUuW6jqmmuo=
Message-ID: <b6c5339f0811100851t1fd9a180pfe24312081885467@mail.gmail.com>
Date: Mon, 10 Nov 2008 11:51:09 -0500
From: "Bob Copeland" <me@bobcopeland.com>
To: "Maxim Levitsky" <maximlevitsky@gmail.com>
Subject: Re: Bugs on aspire one A150
Cc: linux-kernel@vger.kernel.org, linux-pm@lists.linux-foundation.org,
       ath5k-devel@venema.h4ckr.net, alsa-devel@alsa-project.org
In-Reply-To: <491506DB.1070000@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <491506DB.1070000@gmail.com>
X-Google-Sender-Auth: de7262bfc332c48c
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 7, 2008 at 10:26 PM, Maxim Levitsky <maximlevitsky@gmail.com> wrote:
> ** 2 - wireless: not to mention the fact that ath5k wasn't installed by
> default in ubuntu...
> wireless more or less works, but kernel log is full of backtraces.

As you've seen, these should at least be gone now...

> Was able to connect to my WPA2 access point.
> Sometimes wireless fails completely, especially after suspend to ram.

Did you get noise calibration failures in dmesg at this point?  Felix posted
a patch recently that handles them better.

> Advanced features like monitor/injection work, but when I changed the card's
> mac address it stopped working.
> I also noticed that if I then start airodump, then wireless works with new
> mac.

> ** 4 - wireless led doesn't work.
> ath5k devs, can you fix this?

Currently all the LED code we have in there is for setting a particular gpio
for particular laptops (and they differ between models).  We only have quirks
for IBM and HP, none for Acer.  Also, the legacy-hal seems to have a different
strategy for 2425 chips.  I can try to hack up some code for you to test.

-- 
Bob Copeland %% www.bobcopeland.com
