Return-Path: <linux-kernel-owner+w=401wt.eu-S1752128AbXLZS5s@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752128AbXLZS5s (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Dec 2007 13:57:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751328AbXLZS5l
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Dec 2007 13:57:41 -0500
Received: from terminus.zytor.com ([198.137.202.10]:57211 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750883AbXLZS5k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Dec 2007 13:57:40 -0500
Message-ID: <4772A3FB.8080108@zytor.com>
Date: Wed, 26 Dec 2007 10:56:59 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Pavel Machek <pavel@ucw.cz>
CC: kernel list <linux-kernel@vger.kernel.org>,
       Linux-pm mailing list <linux-pm@lists.osdl.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [RFC] sleepy linux
References: <20071225230731.GA29030@elf.ucw.cz>
In-Reply-To: <20071225230731.GA29030@elf.ucw.cz>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pavel Machek wrote:
> This is RFC. It does not even work for me... it sleeps but it will not
> wake up, because SATA wakeup code is missing. Code attached for illustration.
> 
> I wonder if this is the right approach? What is right interface to the
> drivers?
> 
> 3) Network card that is either down
>    or can wake up system on any packet (and not loose too many packets)
> 

This is the big crux I see.  You're going to constantly wake up the 
machine due to broadcast packets, and spend a lot of power just going in 
and out of S3.

	-hpa
