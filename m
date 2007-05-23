Return-Path: <linux-kernel-owner+w=401wt.eu-S1764934AbXEWHZd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764934AbXEWHZd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2007 03:25:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758778AbXEWHZX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 May 2007 03:25:23 -0400
Received: from nz-out-0506.google.com ([64.233.162.224]:52603 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758746AbXEWHZW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2007 03:25:22 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:subject:from:to:cc:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=ogRlcdPW2cORIzN/6liawa+DaJ579yiA7YtraM5o8UimdH7qo+3aQ7e8ldUUjyJyI9MSL/c3FWuDox5n5d23xCLOmAxlEjvwAOlQVTphm9CPV0U1xfdDK5da3hCDsIZiTl6tmjtWUiarTLU3QPRkyjSIHu8NqTnLEhCiRVB2uR0=
Subject: 2.6.21.1 fails to suspend/resume  to disk  (sort of)
From: Romano Giannetti <romano.giannetti@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Pavel Machek <pavel@ucw.cz>, "Rafael J. Wysocki" <rjw@sisk.pl>
Content-Type: text/plain
Date: Wed, 23 May 2007 09:25:15 +0200
Message-Id: <1179905115.7043.25.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, 

I am trying to upgrade from my ubuntu kernel 2.6.17.3 to 2.6.21.1 and I
have quite a bunch of problems with suspend/resume, both to disk and to
ram. I have reported the s2ram problem in a separate message (search for
a follow-up to the thread with subject "[patch 00/69] -stable review".
http://lkml.org/lkml/2007/5/23/38

Now for the suspend to disk. With default setting (/sys/power/disk ==
platform) my laptop (vaio PGC-FX701) fails to poweroff; it stays with
backlight on, a white screen, and if I power it off manually afterward
it did not resume.

By doing echo shutdown > /sys/power/disk the laptop *do* power off (it's
very slow, but I think that's related with the 60 secs delay commented
in the other post). Then it resume --- text console did resume ok ---
but the virtual console with X do not come back. I had to do a
ctrl-alt-backspace thing. 

Any hints? More data?

