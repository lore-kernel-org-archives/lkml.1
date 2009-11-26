Return-Path: <linux-kernel-owner+w=401wt.eu-S1760541AbZKZNSF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760541AbZKZNSF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Nov 2009 08:18:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760392AbZKZNSE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Nov 2009 08:18:04 -0500
Received: from mx1.redhat.com ([209.132.183.28]:21890 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754491AbZKZNSD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Nov 2009 08:18:03 -0500
Message-ID: <4B0E7FFD.10908@redhat.com>
Date: Thu, 26 Nov 2009 11:17:49 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
User-Agent: Thunderbird 2.0.0.22 (X11/20090609)
MIME-Version: 1.0
To: Andy Walls <awalls@radix.net>
CC: Christoph Bartelmus <lirc@bartelmus.de>, khc@pm.waw.pl,
       dmitry.torokhov@gmail.com, j@jannau.net, jarod@redhat.com,
       linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-media@vger.kernel.org, superm1@ubuntu.com
Subject: Re: [RFC] Should we create a raw input interface for IR's ? - Was:
 Re: [PATCH 1/3 v2] lirc core device driver infrastructure
References: <BDRae8rZjFB@christoph> <1259024037.3871.36.camel@palomino.walls.org>
In-Reply-To: <1259024037.3871.36.camel@palomino.walls.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andy Walls wrote:

> I generally don't understand the LIRC aversion I perceive in this thread
> (maybe I just have a skewed perception). 

> Regards,
> Andy "LIRC Fan-Boy" Walls

This is not a lirc love or hate thread. We're simply discussing the better
API's for IR, from the technical standpoint, considering that some users 
may want to use lirc and some users may want to have their IR working 
out-of-the-box.

By not using lirc, users will loose the advantages of having lircd, like clicking
on a button and calling automatically the DVD player application, but this means
that their device with the shipped IR will work without needing to do any setup.

Whatever we do, both kind of usages should be possible, since there are demand
for both.

Also, the decision should consider that the existing drivers will need to
support the new way without causing regressions.

Cheers,
Mauro.

