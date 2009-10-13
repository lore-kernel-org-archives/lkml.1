Return-Path: <linux-kernel-owner+w=401wt.eu-S1761461AbZJMVzk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761461AbZJMVzk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Oct 2009 17:55:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761433AbZJMVzk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Oct 2009 17:55:40 -0400
Received: from lucidpixels.com ([75.144.35.66]:58348 "EHLO lucidpixels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761435AbZJMVzj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Oct 2009 17:55:39 -0400
Date: Tue, 13 Oct 2009 17:55:03 -0400 (EDT)
From: Justin Piszcz <jpiszcz@lucidpixels.com>
To: nut-upsuser@lists.alioth.debian.org
cc: linux-kernel@vger.kernel.org
Subject: USB/UPS connectivity issue on Intel DP55KG Motherboard
Message-ID: <alpine.DEB.2.00.0910131749190.5034@p34.internal.lan>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

I use the following in my ups.conf:

# USB:
[apc]
   driver = usbhid-ups
   port = auto
   desc = "APC 1500VA"
   pollfreq = 5

On my new motherboard (an Intel DP55KG), every once and awhile I get this:

Broadcast Message from nut@box.com
         (somewhere) at 17:48 ...

Communications with UPS apc@localhost lost


Broadcast Message from nut@box.com
         (somewhere) at 17:48 ...

Communications with UPS apc@localhost established

On my previous motherboard (a DG965WH), the exact same configuration was used
and I never had this issue.

Any hints?

Should I increase the pollfreq to say 30 seconds?

Would this 'workaround' the problem?

Is this a known bug on this chipset?

Justin.


