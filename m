Return-Path: <linux-kernel-owner+w=401wt.eu-S1754491AbYJ0VkD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754491AbYJ0VkD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2008 17:40:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753163AbYJ0ViQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Oct 2008 17:38:16 -0400
Received: from smtp115.sbc.mail.sp1.yahoo.com ([69.147.64.88]:42658 "HELO
	smtp115.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752323AbYJ0ViK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2008 17:38:10 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Disposition:Message-Id:Content-Type:Content-Transfer-Encoding;
  b=yyYentATxZFNzUcZY8c3MVB4U9Oxkb3coKlpqTgPXVFg1fE18D377viIkRb/b3CYw4jGR1mnzre4onfPuuKieiqaJCsbLPPnu/x+cpIOLq7ZIgup7Cf8sspp4xd0rPvoIAJ0K+FLbHiy7uCInWTwzB7RyOlUvtdnmkUgu8yv0YI=  ;
X-YMail-OSG: Rk02wecVM1lJK8xrTXQkccDX.W5Qr7JxqvW8nrr_byMcWwADZlLmU_hXGDgWSbgvjs8YJcYBMN79dNS8aR2_y4Cxhn4G_CZIGJRokOfsEu0V5EeGVOHkiXN9fphE5RAXg5I-
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: Alessandro Zummo <alessandro.zummo@towertech.it>
Subject: Re: [rtc-linux] [i2c] [PATCH] rtc-ds1307 : SMBus compatibility
Date: Mon, 27 Oct 2008 14:29:24 -0700
User-Agent: KMail/1.9.10
Cc: rtc-linux@googlegroups.com, sbarre@sdelcc.com,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "i2c@lm-sensors.org" <i2c@lm-sensors.org>,
       Jean Delvare <khali@linux-fr.org>,
       Rodolfo Giometti <giometti@enneenne.com>,
       Andrew Morton <akpm@linux-foundation.org>
References: <C1C62166118DFA4A8BBA01A2411F0D170E9BE59C2F@PRI-MBX-101.dom1.vinci-energies.net> <C1C62166118DFA4A8BBA01A2411F0D170E9BEC880E@PRI-MBX-101.dom1.vinci-energies.net> <20081021202938.2eca3ac1@i1501.lan.towertech.it>
In-Reply-To: <20081021202938.2eca3ac1@i1501.lan.towertech.it>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200810271429.25490.david-b@pacbell.net>
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 21 October 2008, Alessandro Zummo wrote:
> > I've tested it with ds1307 chip.
> > Is somebody can test it on ds1337/ds1338 ?
> 
>  Given the amount of changes I need some Tested-bys
>  for the patch to go thru.

I tested these changes on my trusty ds1307 system using i2c-gpio
(vs a "real SMBus controller") and it works just fine.

Of the nine changed I/O calls, testing with the ds1307 covers
all but the three supporting the new alarm calls.  Given that
those alarm changes are "obvious", I actually don't have any
qualms signing off on these changes ... though it would of
course be good to have Rodolfo re-test his alarm code.  (It's
freshly merged in any case, so it merits testing just in case
a problem snuck in!)

- Dave
