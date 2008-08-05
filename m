Return-Path: <linux-kernel-owner+w=401wt.eu-S1757717AbYHEO3c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757717AbYHEO3c (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2008 10:29:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755474AbYHEO3X
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Aug 2008 10:29:23 -0400
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:52888 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755367AbYHEO3W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2008 10:29:22 -0400
X-Sasl-enc: gxXyGkzN1GQSYAsK6/cqwHe9o3SXxmqdZYzTRd7E7wwL 1217946560
Date: Tue, 5 Aug 2008 11:29:15 -0300
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Theodore Tso <tytso@mit.edu>, Robert Hancock <hancockr@shaw.ca>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, Gabor Gombas <gombasg@sztaki.hu>,
       Tejun Heo <htejun@gmail.com>, Elias Oltmanns <eo@nebensachen.de>,
       Jeff Garzik <jeff@garzik.org>,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       James Bottomley <James.Bottomley@hansenpartnership.com>,
       Pavel Machek <pavel@ucw.cz>, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/5] libata: Implement disk shock protection support
Message-ID: <20080805142915.GD32675@khazad-dum.debian.net>
References: <fa.nx0yFPJm+aNXPHgykUrOzZXvvIs@ifi.uio.no> <fa.NfEr7Ik6e8oextyWICW/jR5emeE@ifi.uio.no> <fa.zGvATZImeUo0tHJe4hzlk5+mTiM@ifi.uio.no> <fa.SRVleMItV5QEF7/tgCjSHz0ScJA@ifi.uio.no> <fa.YKbhgq8XUxH/Qg1ArE+73YsDlpE@ifi.uio.no> <4897D16F.3000504@shaw.ca> <20080805131417.GC8569@mit.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080805131417.GC8569@mit.edu>
X-GPG-Fingerprint: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F
	1CDB 0FE3
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 05 Aug 2008, Theodore Tso wrote:
> The real right answer though is to buy one of the laptop drives (such
> as the Seagate Momentus 7200.2 or 7200.3) which has the anti-shock
> detection built directly into the hard drive.  That way you don't have
> to have a daemon that sits in the OS waking up the CPU some 20 to 30
> times a second and burning up your battery even when the laptop is
> idle.

Make that 50 times a second for the kernel over a slow LPC bus IO path, plus
whatever userspace needs to process that data and feed it back as an UNLOAD
IMMEDIATE request...

Yes, doing it inside the HD itself is *MUCH* better.  But only very few
disks do it, so far, I only know of those Seagates.  And they are available
only on SATA.  So, many thinkpad owners will want "software-based" HDAPS for
at least five more years, maybe more (thinkpads REALLY have a long useful
life, we still see a good number of T23 in heavy use...).

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
