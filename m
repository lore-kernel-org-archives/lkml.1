Return-Path: <linux-kernel-owner+w=401wt.eu-S1753239AbXLZUva@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753239AbXLZUva (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Dec 2007 15:51:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751694AbXLZUvW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Dec 2007 15:51:22 -0500
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:38393 "EHLO amd.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751611AbXLZUvV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Dec 2007 15:51:21 -0500
Date: Wed, 26 Dec 2007 21:51:03 +0100
From: Pavel Machek <pavel@ucw.cz>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Oliver Neukum <oliver@neukum.org>,
       kernel list <linux-kernel@vger.kernel.org>,
       Linux-pm mailing list <linux-pm@lists.osdl.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [RFC] sleepy linux
Message-ID: <20071226205103.GG8094@elf.ucw.cz>
References: <20071225230731.GA29030@elf.ucw.cz> <4772A3FB.8080108@zytor.com> <200712262108.35643.oliver@neukum.org> <4772BD0C.3040609@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4772BD0C.3040609@zytor.com>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed 2007-12-26 12:43:56, H. Peter Anvin wrote:
> Oliver Neukum wrote:
>> Am Mittwoch, 26. Dezember 2007 19:56:59 schrieb H. Peter Anvin:
>>>> 3) Network card that is either down
>>>>    or can wake up system on any packet (and not loose too many packets)
>>>>
>>> This is the big crux I see.  You're going to constantly wake up the 
>>> machine due to broadcast packets, and spend a lot of power just going in 
>>> and out of S3.
>> How many machines care a lot about saving power while they are connected
>> to an ethernet? Wlan might be more of a problem.
>
> A lot of them should.  An inordinate amount of machines sit there burning 
> power for no reason.  You can argue that S3 isn't needed -- that nohz + 
> C3/C4 + turning off the screen would be enough, and that might be
> + legit.  

NOHZ + C4 + turn off screen + turn off disk + turn off SATA is still
~8W on thinkpad x60.

S3 is ~1W.

That's quite significant difference.

(But yes, connected-to-ethernet is not most important use scenario.)
								Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
