Return-Path: <linux-kernel-owner+w=401wt.eu-S1760494AbYHENnk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760494AbYHENnk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2008 09:43:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757939AbYHENna
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Aug 2008 09:43:30 -0400
Received: from www.church-of-our-saviour.org ([69.25.196.31]:58885 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757215AbYHENn2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2008 09:43:28 -0400
Date: Tue, 5 Aug 2008 09:14:17 -0400
From: Theodore Tso <tytso@mit.edu>
To: Robert Hancock <hancockr@shaw.ca>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, Gabor Gombas <gombasg@sztaki.hu>,
       Tejun Heo <htejun@gmail.com>, Elias Oltmanns <eo@nebensachen.de>,
       Jeff Garzik <jeff@garzik.org>,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       James Bottomley <James.Bottomley@hansenpartnership.com>,
       Pavel Machek <pavel@ucw.cz>, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/5] libata: Implement disk shock protection support
Message-ID: <20080805131417.GC8569@mit.edu>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>,
	Robert Hancock <hancockr@shaw.ca>,
	Alan Cox <alan@lxorguk.ukuu.org.uk>,
	Gabor Gombas <gombasg@sztaki.hu>, Tejun Heo <htejun@gmail.com>,
	Elias Oltmanns <eo@nebensachen.de>, Jeff Garzik <jeff@garzik.org>,
	Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
	James Bottomley <James.Bottomley@hansenpartnership.com>,
	Pavel Machek <pavel@ucw.cz>, linux-ide@vger.kernel.org,
	linux-kernel@vger.kernel.org
References: <fa.nx0yFPJm+aNXPHgykUrOzZXvvIs@ifi.uio.no> <fa.NfEr7Ik6e8oextyWICW/jR5emeE@ifi.uio.no> <fa.zGvATZImeUo0tHJe4hzlk5+mTiM@ifi.uio.no> <fa.SRVleMItV5QEF7/tgCjSHz0ScJA@ifi.uio.no> <fa.YKbhgq8XUxH/Qg1ArE+73YsDlpE@ifi.uio.no> <4897D16F.3000504@shaw.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4897D16F.3000504@shaw.ca>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@mit.edu
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 04, 2008 at 10:05:03PM -0600, Robert Hancock wrote:
> Yes, from what I've seen on these laptops, it doesn't take much to  
> trigger the shock protection in Windows - lifting the front of the  
> laptop off the table an inch and dropping it will do it, 

A few years ago, I had a Thinkpad T21 laptop, accidentally slip
through my butterfingers and dropped about an inch before it landed on
the table.  Unfortunately, (a) the Thinkpad T21 laptop was rather
heavy (compared to modern laptops), (b) it didn't have the rubber
"bubble" on the bottom of the laptop to cushion the landing as the T22
and T23's had (and I'm sure I know why it was added), and (c) the hard
drive was active at the time.  It was enough to cause a head crash and
Linux immediately started reporting an exponentially increasing number
of write errors; the hard drive was totally unusable within an hour or
so.

So there's a reason why the anti-shock protection is set at a rather
sensitive level...    

The real right answer though is to buy one of the laptop drives (such
as the Seagate Momentus 7200.2 or 7200.3) which has the anti-shock
detection built directly into the hard drive.  That way you don't have
to have a daemon that sits in the OS waking up the CPU some 20 to 30
times a second and burning up your battery even when the laptop is
idle.

							- Ted
