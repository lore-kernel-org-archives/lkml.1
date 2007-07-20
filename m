Return-Path: <linux-kernel-owner+w=401wt.eu-S940332AbXGTQCk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S940332AbXGTQCk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jul 2007 12:02:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S940148AbXGTQC1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Jul 2007 12:02:27 -0400
Received: from sovereign.computergmbh.de ([85.214.69.204]:37683 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S939949AbXGTQC0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jul 2007 12:02:26 -0400
Date: Fri, 20 Jul 2007 18:02:25 +0200 (CEST)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: Greg KH <gregkh@suse.de>
cc: Cornelia Huck <cornelia.huck@de.ibm.com>,
       Gabriel C <nix.or.die@googlemail.com>,
       Robert Schwebel <r.schwebel@pengutronix.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       kay.sievers@vrfy.org
Subject: Re: kobject link failure
In-Reply-To: <20070720150627.GA12822@suse.de>
Message-ID: <Pine.LNX.4.64.0707201756290.31013@fbirervta.pbzchgretzou.qr>
References: <Pine.LNX.4.64.0707191956510.31013@fbirervta.pbzchgretzou.qr>
 <469FA94E.20002@googlemail.com> <20070720080059.GA29639@suse.de>
 <20070720113221.390ed32a@gondolin.boeblingen.de.ibm.com>
 <20070720135813.0e416b2b@gondolin.boeblingen.de.ibm.com> <20070720150627.GA12822@suse.de>
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-699020219-1536441064-1184947345=:31013"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---699020219-1536441064-1184947345=:31013
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT


On Jul 20 2007 08:06, Greg KH wrote:
>> Leaving kobject_actions[] in kobject_uevent.c, but putting it outside
>> the #ifdef looks indeed like the best solution to me. This way, we
>> avoid adding #ifdef CONFIG_HOTPLUG into core.c, when all other
>> functions called do not need such a thing.
>
>Yeah, this is much nicer and smaller, thanks.  I'll throw away my patch
>and use this one instead.
>
>Can someone verify that it works properly for them please?

Works-For-Me™: Jan Engelhardt <jengelh@gmx.de>


	Jan
-- 
---699020219-1536441064-1184947345=:31013--
