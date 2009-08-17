Return-Path: <linux-kernel-owner+w=401wt.eu-S1758216AbZHQWfc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758216AbZHQWfc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Aug 2009 18:35:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751228AbZHQWfc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Aug 2009 18:35:32 -0400
Received: from outbound-dub.frontbridge.com ([213.199.154.16]:45628 "EHLO
	IE1EHSOBE001.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751176AbZHQWfb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Aug 2009 18:35:31 -0400
X-SpamScore: -16
X-BigFish: VPS-16(zz1432R98dNzz1202hzzz2fh6bh66h)
X-Spam-TCS-SCL: 5:0
Message-ID: <4A89DB15.6060101@am.sony.com>
Date: Mon, 17 Aug 2009 15:35:01 -0700
From: Tim Bird <tim.bird@am.sony.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Robert Schwebel <r.schwebel@pengutronix.de>
CC: Denys Vlasenko <vda.linux@googlemail.com>, linux-kernel@vger.kernel.org,
       linux-embedded@vger.kernel.org,
       Arjan van de Ven <arjan@linux.intel.com>, kernel@pengutronix.de
Subject: new ipdelay= option for faster netboot (was Re: New fast(?)-boot
 results on ARM)
References: <20090814170228.GM13320@pengutronix.de> <1158166a0908141304y70300ab3p899b0d4609efded9@mail.gmail.com> <20090814204305.GA31727@pengutronix.de> <4A89AC40.2040109@am.sony.com>
In-Reply-To: <4A89AC40.2040109@am.sony.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 17 Aug 2009 22:35:02.0620 (UTC) FILETIME=[F5F989C0:01CA1F8A]
X-SEL-encryption-scan: scanned
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tim Bird wrote:
> See the definitions of CONF_PRE_OPEN and CON_POST_OPEN
> in net/ipv4/ipconfig.c
> 
> They are set to ridiculously long values.  In my experience,
> you can cut them down considerably with no dangerous side
> effects (but I haven't asked the network guys about the
> possible downsides).

It turns out that others have seen this delay.  Simon
Arlott recently posted a patch to make the delay avoidable
at boot time from the kernel command line.

See http://patchwork.kernel.org/patch/31678/
 -- Tim

=============================
Tim Bird
Architecture Group Chair, CE Linux Forum
Senior Staff Engineer, Sony Corporation of America
=============================

