Return-Path: <linux-kernel-owner+w=401wt.eu-S1755942AbYGENRS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755942AbYGENRS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Jul 2008 09:17:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752876AbYGENRF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 Jul 2008 09:17:05 -0400
Received: from wa-out-1112.google.com ([209.85.146.178]:1956 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752614AbYGENRC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Jul 2008 09:17:02 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:mime-version:content-type
         :content-transfer-encoding:content-disposition:x-google-sender-auth;
        b=GuFhphxbZsUDjFfO8NnWBPNB4SKNxGPzgyEUpGU8Xd9h28MeYreeF8ZxlooRoL03j3
         xHDUOXnbVdkd4c8HainPckuu0H+9mxkOhRATnUS1+JRJBR4ANPSBZcPagPoht3dxFXa1
         NQgfj81O6R7TH50kmoeiTRBj3nojb2jCIDEGo=
Message-ID: <31e679430807050617u3fc706fasee9bb43a151c501f@mail.gmail.com>
Date: Sat, 5 Jul 2008 16:17:01 +0300
From: "Felipe Balbi" <felipebalbi@users.sourceforge.net>
To: "Kernel development list" <linux-kernel@vger.kernel.org>,
       linux-acpi@vger.kernel.org
Subject: Battery life difference
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
X-Google-Sender-Auth: 8dfc966726a479a8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello all,

I bought two x61s for testing purposes. One of them is running windows XP and
the other one is running clean ubuntu 8.04 with kernel 2.6.24-19. The problem
is that on windows that battery lasts around 3h30min and with linux 1h30min.

2 hours is a huge difference. Here's the scenario:

. x61s with windows xp
wifi on but not connected to any network, bluetooth on,
display is in the less brighten state.

. x61s with ubuntu 8.04
all radios off (modules removed and hw switch off),
display is in the less brighten state.
powertop runned and I did what it suggested me
to do. Also did some other stuff from thinkwiki on
how to reduce power consumption.

Well, what could still be using the system power so
much ?

Are we missing anything on the acpi implementation or
is it related to acpi integration to bus and device drivers ?

Anything I could help testing and maybe even coding, I
started reading the acpi specs and some notes on the
linux-acpi website.

One thing that called my attention is that D2 and D3 states
would require context save/restore opperations (not always
true in D2) and I can't see such feature in almost any drivers.

We're starting to plan it for omap drivers though due to omap3's
pm feature been able to reach off-states, but that's another
point and has nothing to do with x86.

Anyways, do we reach D2/D3 states anywhere ? I mean without
context save/restore we can't reach D3 and almost no D2 as well.

Any comments ?

-- 
Best Regards,

Felipe Balbi
felipebalbi@users.sourceforge.net
