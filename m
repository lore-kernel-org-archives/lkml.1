Return-Path: <linux-kernel-owner+w=401wt.eu-S1755689AbZHRCqM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755689AbZHRCqM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Aug 2009 22:46:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752185AbZHRCqL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Aug 2009 22:46:11 -0400
Received: from mail.lang.hm ([64.81.33.126]:55052 "EHLO bifrost.lang.hm"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751238AbZHRCqK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Aug 2009 22:46:10 -0400
Date: Mon, 17 Aug 2009 19:45:33 -0700 (PDT)
From: david@lang.hm
X-X-Sender: dlang@asgard.lang.hm
To: Rick Jones <rick.jones2@hp.com>
cc: David Miller <davem@davemloft.net>, tim.bird@am.sony.com,
       r.schwebel@pengutronix.de, vda.linux@googlemail.com,
       linux-kernel@vger.kernel.org, linux-embedded@vger.kernel.org,
       arjan@linux.intel.com, kernel@pengutronix.de, netdev@vger.kernel.org
Subject: Re: new ipdelay= option for faster netboot
In-Reply-To: <4A8A0454.8000902@hp.com>
Message-ID: <alpine.DEB.2.00.0908171942430.30426@asgard.lang.hm>
References: <20090814204305.GA31727@pengutronix.de> <4A89AC40.2040109@am.sony.com> <4A89DB15.6060101@am.sony.com> <20090817.180323.253692704.davem@davemloft.net> <4A8A0454.8000902@hp.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 17 Aug 2009, Rick Jones wrote:

> David Miller wrote:
>> I have card/switch combinations that take up to 10 seconds to
>> negotiate a proper link.
>
> Gotta love it when things adhere to specs...

the default on Cisco switches is to wait 30 seconds before fully enabling 
the port so that it can listen for spanning tree broadcasts.

for windows systems this doesn't cause any problems (they take long enough 
to boot), but for a tightly configured linux box it can be fully booted 
long before the switch decides to enable the port (for that matter, I have 
a bare-metal install process that takes about 90 seconds from hitting 
power, from a CD. I could probably speed things up by switching to USB 
boot media)

David Lang
