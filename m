Return-Path: <linux-kernel-owner+w=401wt.eu-S1759198AbYBTKUn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759198AbYBTKUn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2008 05:20:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751196AbYBTKUe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Feb 2008 05:20:34 -0500
Received: from sovereign.computergmbh.de ([85.214.69.204]:37740 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752505AbYBTKUe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2008 05:20:34 -0500
Date: Wed, 20 Feb 2008 11:20:33 +0100 (CET)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
cc: Karl Dahlke <eklhad@comcast.net>, linux-kernel@vger.kernel.org,
       Sam Ravnborg <sam@ravnborg.org>, Randy Dunlap <randy.dunlap@oracle.com>,
       Valdis.Kletnieks@vt.edu
Subject: Re: adapter, what's in a name
In-Reply-To: <47BBF532.4030704@s5r6.in-berlin.de>
Message-ID: <Pine.LNX.4.64.0802201116300.26109@fbirervta.pbzchgretzou.qr>
References: <20080119181606.eklhad@comcast.net> <47BBF532.4030704@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Feb 20 2008 10:38, Stefan Richter wrote:
>Karl Dahlke wrote:
>> The longer I stay on this list, the more I will learn.
>> But it's high volume, so I may not be able to stay for long.
>
>Because of the high volume at this list, it is essential that
>  - you keep everyone who posted in a tread in the Cc: list of your
>    replies, (that way it is possible to discuss on LKML even with
>    people who are not subscribed; but more importantly, people who
>    take part in a discussion are less likely to miss replies),
>  - you actually reply rather than start new threads all the time.

Indeed, in PINE, mails with your address in Cc get preprended with a
minus sign, mails with your addr in To gets prepended with a plus
sign, conveniently marking the discussions one has taken part in. (Or
alternatively, one can use 'select all mails with my address' to
color-highlight it.) Pretty nifty.

>Aren't those drivers ones for
>  - input devices,
>  - display devices (in a more general sense than visual displays, i.e.
>    also including audible and tactile displays)?
>Besides, if you had for example an USB device of that type, the most
>natural place for its sources would be somewhere beneath drivers/usb/.

Well actually, I think it would go into drivers/input/. It is not
quite obvious.

Wireless USB -- drivers/net/wireless, not drivers/usb/
Serial USB   -- drivers/usb/serial, not drivers/serial/usb/
for example, but it seems to flow well anyway.

