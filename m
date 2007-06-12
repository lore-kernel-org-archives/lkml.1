Return-Path: <linux-kernel-owner+w=401wt.eu-S1756797AbXFLPSw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756797AbXFLPSw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jun 2007 11:18:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754471AbXFLPSn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Jun 2007 11:18:43 -0400
Received: from stinky.trash.net ([213.144.137.162]:38649 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752137AbXFLPSm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jun 2007 11:18:42 -0400
Message-ID: <466EB8A3.4020107@trash.net>
Date: Tue, 12 Jun 2007 17:15:47 +0200
From: Patrick McHardy <kaber@trash.net>
User-Agent: Debian Thunderbird 1.0.7 (X11/20051019)
X-Accept-Language: en-us, en
MIME-Version: 1.0
To: Jan Engelhardt <jengelh@computergmbh.de>
CC: Oliver Neukum <oliver@neukum.org>, linux-kernel@vger.kernel.org
Subject: Re: cannot set IP for ethernet
References: <200706121441.13561.oliver@neukum.org> <Pine.LNX.4.64.0706121531040.19578@fbirervta.pbzchgretzou.qr> <200706121613.47718.oliver@neukum.org> <Pine.LNX.4.64.0706121714290.19578@fbirervta.pbzchgretzou.qr>
In-Reply-To: <Pine.LNX.4.64.0706121714290.19578@fbirervta.pbzchgretzou.qr>
X-Enigmail-Version: 0.93.0.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jan Engelhardt wrote:
> On Jun 12 2007 16:13, Oliver Neukum wrote:
> 
>>>On Jun 12 2007 14:41, Oliver Neukum wrote:
>>>
>>>>with 2.6.22-rc4-git2 I am getting errors when setting IP for ethernet
>>>>interfaces:
>>>>
>>>>ioctl(4, SIOCSIFADDR, 0x7fff94931600)   = -1 ENOBUFS (No buffer space available)
> 
> 
> Do you run VPN or some sort?


As far as I can see only inet_device allocation failure can lead
to this error. Please try the patch I sent in case it is reproducable
after reboot.
