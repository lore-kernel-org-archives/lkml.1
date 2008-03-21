Return-Path: <linux-kernel-owner+w=401wt.eu-S1756882AbYCUMhb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756882AbYCUMhb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Mar 2008 08:37:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754649AbYCUMhQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Mar 2008 08:37:16 -0400
Received: from out1.smtp.messagingengine.com ([66.111.4.25]:43722 "EHLO
	out1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754481AbYCUMhO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Mar 2008 08:37:14 -0400
X-Sasl-enc: JxXyHBYxKyRp1q8RnLXc09uHqGWV2NeiS1533Vh/8Oo/ 1206103032
Date: Fri, 21 Mar 2008 09:37:08 -0300
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       David Brownell <david-b@pacbell.net>,
       Richard Purdie <rpurdie@rpsys.net>, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>, Geert Uytterhoeven <geert@linux-m68k.org>,
       netdev@vger.kernel.org, Martin Schwidefsky <schwidefsky@de.ibm.com>,
       Heiko Carstens <heiko.carstens@de.ibm.com>, linux-usb@vger.kernel.org,
       linux-wireless@vger.kernel.org, video4linux-list@redhat.com,
       lm-sensors@lm-sensors.org
Subject: Re: use of preempt_count instead of in_atomic() at leds-gpio.c
Message-ID: <20080321123708.GE5586@khazad-dum.debian.net>
References: <20080316184349.GA28543@khazad-dum.debian.net> <200803161246.23909.david-b@pacbell.net> <20080318001429.896acf51.akpm@linux-foundation.org> <20080320225612.GB20788@khazad-dum.debian.net> <20080320164741.734e838c.akpm@linux-foundation.org> <20080321003604.GC20788@khazad-dum.debian.net> <20080320180802.426ad2d1.akpm@linux-foundation.org> <47E37E04.3080303@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47E37E04.3080303@s5r6.in-berlin.de>
X-GPG-Fingerprint: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F
	1CDB 0FE3
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 21 Mar 2008, Stefan Richter wrote:
> and eth1394 to deal with temporary lack of of tlabels.  Alas I just  
> recently received a report that eth1394's workaround is unsuccessful on  
> non-preemptible uniprocessor kernels.  I suspect the same issue exists  

Which, I think, is exactly the config where in_atomic() can't be used to
mean "in_scheduleable_context()" ?

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
