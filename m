Return-Path: <linux-kernel-owner+w=401wt.eu-S1753934AbXFYJgT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753934AbXFYJgT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jun 2007 05:36:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751889AbXFYJgJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Jun 2007 05:36:09 -0400
Received: from stinky.trash.net ([213.144.137.162]:63421 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751586AbXFYJgG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jun 2007 05:36:06 -0400
Message-ID: <467F8C84.9020404@trash.net>
Date: Mon, 25 Jun 2007 11:36:04 +0200
From: Patrick McHardy <kaber@trash.net>
User-Agent: Debian Thunderbird 1.0.7 (X11/20051019)
X-Accept-Language: en-us, en
MIME-Version: 1.0
To: Jan Engelhardt <jengelh@computergmbh.de>
CC: Kyle Moffett <mrmacman_g4@mac.com>, djones@rossove.com,
       LKML Kernel <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>, netdev@vger.kernel.org
Subject: Re: Scaling Max IP address limitation
References: <467EA7C1.4080006@rossove.com> <D6003DDE-0C36-437B-B70A-D422DFE153D0@mac.com> <Pine.LNX.4.64.0706242153240.11964@fbirervta.pbzchgretzou.qr>
In-Reply-To: <Pine.LNX.4.64.0706242153240.11964@fbirervta.pbzchgretzou.qr>
X-Enigmail-Version: 0.93.0.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jan Engelhardt wrote:
> On Jun 24 2007 15:08, Kyle Moffett wrote:
> 
>>Do you really need that many IP addresses?  When somebody finally gets
>>around to implementing REDIRECT support for ip6tables then you could
>>just redirect them all to the same port on the local system.
> 
> 
> The way I see it, it's: "if someone gets around to implement *IPv6 NAT*"
> (which, if its designers were asked, is contrary to the idea of ipv6).


You don't necessarily need NAT for REDIRECT, so we might actually have
an ip6tables REDIRECT some day. Check out the current TPROXY patches
for an example how to do it without NAT in case you're interested.

