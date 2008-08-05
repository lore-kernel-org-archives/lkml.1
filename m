Return-Path: <linux-kernel-owner+w=401wt.eu-S1762267AbYHET7R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762267AbYHET7R (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2008 15:59:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758564AbYHET7B
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Aug 2008 15:59:01 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:57925 "EHLO
	gprs189-60.eurotel.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757951AbYHET7A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2008 15:59:00 -0400
Date: Tue, 5 Aug 2008 22:00:21 +0200
From: Pavel Machek <pavel@suse.cz>
To: Eric Piel <eric.piel@tremplin-utc.net>
Cc: Theodore Tso <tytso@mit.edu>, Robert Hancock <hancockr@shaw.ca>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, Gabor Gombas <gombasg@sztaki.hu>,
       Tejun Heo <htejun@gmail.com>, Elias Oltmanns <eo@nebensachen.de>,
       Jeff Garzik <jeff@garzik.org>,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       James Bottomley <James.Bottomley@hansenpartnership.com>,
       linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/5] libata: Implement disk shock protection support
Message-ID: <20080805200021.GF7939@elf.ucw.cz>
References: <fa.nx0yFPJm+aNXPHgykUrOzZXvvIs@ifi.uio.no> <fa.NfEr7Ik6e8oextyWICW/jR5emeE@ifi.uio.no> <fa.zGvATZImeUo0tHJe4hzlk5+mTiM@ifi.uio.no> <fa.SRVleMItV5QEF7/tgCjSHz0ScJA@ifi.uio.no> <fa.YKbhgq8XUxH/Qg1ArE+73YsDlpE@ifi.uio.no> <4897D16F.3000504@shaw.ca> <20080805131417.GC8569@mit.edu> <48986E3A.5020707@tremplin-utc.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48986E3A.5020707@tremplin-utc.net>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 2008-08-05 17:14:02, Eric Piel wrote:
> Theodore Tso schreef:
>> The real right answer though is to buy one of the laptop drives (such
>> as the Seagate Momentus 7200.2 or 7200.3) which has the anti-shock
>> detection built directly into the hard drive.  That way you don't have
>> to have a daemon that sits in the OS waking up the CPU some 20 to 30
>> times a second and burning up your battery even when the laptop is
>> idle.
> Well, it's not always _that_ bad. For instance, the accelerometer in the HP 
> laptops (lis3lv02dl) can monitor free-falls by itself. When the laptop 
> starts falling, it generates one interrupt.

I was told that "when it starts falling" is too late.

Thinkpads at least tried to detect the movement before fall: before
notebook falls off table, it is very likely to tilt a lot.
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
