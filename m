Return-Path: <linux-kernel-owner+w=401wt.eu-S1752799AbXLZUpK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752799AbXLZUpK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Dec 2007 15:45:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751514AbXLZUo7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Dec 2007 15:44:59 -0500
Received: from terminus.zytor.com ([198.137.202.10]:33536 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751494AbXLZUo6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Dec 2007 15:44:58 -0500
Message-ID: <4772BD0C.3040609@zytor.com>
Date: Wed, 26 Dec 2007 12:43:56 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Oliver Neukum <oliver@neukum.org>
CC: Pavel Machek <pavel@ucw.cz>, kernel list <linux-kernel@vger.kernel.org>,
       Linux-pm mailing list <linux-pm@lists.osdl.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [RFC] sleepy linux
References: <20071225230731.GA29030@elf.ucw.cz> <4772A3FB.8080108@zytor.com> <200712262108.35643.oliver@neukum.org>
In-Reply-To: <200712262108.35643.oliver@neukum.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Oliver Neukum wrote:
> Am Mittwoch, 26. Dezember 2007 19:56:59 schrieb H. Peter Anvin:
>>> 3) Network card that is either down
>>>    or can wake up system on any packet (and not loose too many packets)
>>>
>> This is the big crux I see.  You're going to constantly wake up the 
>> machine due to broadcast packets, and spend a lot of power just going in 
>> and out of S3.
> 
> How many machines care a lot about saving power while they are connected
> to an ethernet? Wlan might be more of a problem.

A lot of them should.  An inordinate amount of machines sit there 
burning power for no reason.  You can argue that S3 isn't needed -- that 
nohz + C3/C4 + turning off the screen would be enough, and that might be 
legit.  Heck, I'm constantly frustrated by every distro upgrade breaking 
power management for my monitor.

	-hpa
