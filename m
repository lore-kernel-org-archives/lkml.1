Return-Path: <linux-kernel-owner+w=401wt.eu-S1752816AbXLZUzI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752816AbXLZUzI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Dec 2007 15:55:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751633AbXLZUy5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Dec 2007 15:54:57 -0500
Received: from terminus.zytor.com ([198.137.202.10]:59432 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751603AbXLZUy4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Dec 2007 15:54:56 -0500
Message-ID: <4772BF86.4010906@zytor.com>
Date: Wed, 26 Dec 2007 12:54:30 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Pavel Machek <pavel@ucw.cz>
CC: Oliver Neukum <oliver@neukum.org>,
       kernel list <linux-kernel@vger.kernel.org>,
       Linux-pm mailing list <linux-pm@lists.osdl.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [RFC] sleepy linux
References: <20071225230731.GA29030@elf.ucw.cz> <4772A3FB.8080108@zytor.com> <200712262108.35643.oliver@neukum.org> <4772BD0C.3040609@zytor.com> <20071226205103.GG8094@elf.ucw.cz>
In-Reply-To: <20071226205103.GG8094@elf.ucw.cz>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pavel Machek wrote:
> On Wed 2007-12-26 12:43:56, H. Peter Anvin wrote:
>> Oliver Neukum wrote:
>>> Am Mittwoch, 26. Dezember 2007 19:56:59 schrieb H. Peter Anvin:
>>>>> 3) Network card that is either down
>>>>>    or can wake up system on any packet (and not loose too many packets)
>>>>>
>>>> This is the big crux I see.  You're going to constantly wake up the 
>>>> machine due to broadcast packets, and spend a lot of power just going in 
>>>> and out of S3.
>>> How many machines care a lot about saving power while they are connected
>>> to an ethernet? Wlan might be more of a problem.
>> A lot of them should.  An inordinate amount of machines sit there burning 
>> power for no reason.  You can argue that S3 isn't needed -- that nohz + 
>> C3/C4 + turning off the screen would be enough, and that might be
>> + legit.  
> 
> NOHZ + C4 + turn off screen + turn off disk + turn off SATA is still
> ~8W on thinkpad x60.
> 
> S3 is ~1W.
> 
> That's quite significant difference.
> 
> (But yes, connected-to-ethernet is not most important use scenario.)
> 								Pavel

Still... if we could get the desktops of the world down anywhere close 
to that range when not used, it would be a huge win.

	-hpa
