Return-Path: <linux-kernel-owner+w=401wt.eu-S1755918AbZGUVhR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755918AbZGUVhR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jul 2009 17:37:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753564AbZGUVhQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Jul 2009 17:37:16 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:54830 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753161AbZGUVhP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jul 2009 17:37:15 -0400
Date: Tue, 21 Jul 2009 23:37:06 +0200
From: Pavel Machek <pavel@ucw.cz>
To: tridge@samba.org
Cc: Boaz Harrosh <bharrosh@panasas.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       James Bottomley <James.Bottomley@HansenPartnership.com>,
       Martin Steigerwald <Martin@lichtvoll.de>,
       Jan Engelhardt <jengelh@medozas.de>, Theodore Tso <tytso@mit.edu>,
       Rusty Russell <rusty@rustcorp.com.au>, john.lanza@linux.com,
       OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
       linux-fsdevel@vger.kernel.org,
       Dave Kleikamp <shaggy@linux.vnet.ibm.com>, corbet@lwn.net,
       jcm@jonmasters.org, torvalds@linux-foundation.org
Subject: Re: CONFIG_VFAT_FS_DUALNAMES regressions
Message-ID: <20090721213705.GB29060@elf.ucw.cz>
References: <1247066878.4159.153.camel@mulgrave.site> <20090708163736.0f98e7e0@lxorguk.ukuu.org.uk> <1247069202.4159.212.camel@mulgrave.site> <20090708171848.21633768@lxorguk.ukuu.org.uk> <873a96a23x.fsf@devron.myhome.or.jp> <87hbxhwv0j.fsf@devron.myhome.or.jp> <19045.14307.658887.752950@samba.org> <4A65875D.7030902@panasas.com> <20090721103158.GG4133@elf.ucw.cz> <19045.49553.738185.211806@samba.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <19045.49553.738185.211806@samba.org>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

>  > Actually, why not having dosfsck creating _matching_ short names for
>  > long names? As it only writes short names, it should be safe :-).
> 
> As I mentioned to Boaz, what usually matters for claim construction in
> patents is the overall system. I'm sure John Lanza would be happy to
> run through it with you if you want a more legally detailed answer,
> but basically breaking it up within the one system isn't likely to
> help us.

Hehe, or we could create just long names and mark filesystem as
"needing repair" so that Windows fixes it up for us on next mount ;-).
									Pavel

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
