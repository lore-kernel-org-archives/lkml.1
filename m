Return-Path: <linux-kernel-owner+w=401wt.eu-S1756896AbZGCA67@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756896AbZGCA67 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jul 2009 20:58:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752861AbZGCA6u
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Jul 2009 20:58:50 -0400
Received: from mail.parknet.ad.jp ([210.171.162.6]:39287 "EHLO
	mail.officemail.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751847AbZGCA6t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jul 2009 20:58:49 -0400
From: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
To: tridge@samba.org
Cc: Jan Engelhardt <jengelh@medozas.de>, Theodore Tso <tytso@mit.edu>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Rusty Russell <rusty@rustcorp.com.au>, Pavel Machek <pavel@ucw.cz>,
       john.lanza@linux.com,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-fsdevel@vger.kernel.org,
       Dave Kleikamp <shaggy@linux.vnet.ibm.com>, corbet@lwn.net,
       jcm@jonmasters.org
Subject: Re: CONFIG_VFAT_FS_DUALNAMES regressions
References: <19013.8005.541836.436991@samba.org>
	<20090630063102.GB1351@ucw.cz>
	<200907012019.53932.rusty@rustcorp.com.au>
	<20090701122558.3a7c80d3@lxorguk.ukuu.org.uk>
	<20090701140503.GA21185@mit.edu>
	<alpine.LSU.2.00.0907030056210.17183@fbirervta.pbzchgretzou.qr>
	<alpine.LSU.2.00.0907030134291.17183@fbirervta.pbzchgretzou.qr>
	<19021.19842.663727.146474@samba.org>
Date: Fri, 03 Jul 2009 09:58:41 +0900
In-Reply-To: <19021.19842.663727.146474@samba.org> (tridge@samba.org's message
	of "Fri, 3 Jul 2009 10:14:58 +1000")
Message-ID: <87hbxu60qm.fsf@devron.myhome.or.jp>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Anti-Virus: Kaspersky Anti-Virus for MailServers 5.5.10/RELEASE, bases: 24052007 #308098, status: clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

tridge@samba.org writes:

> I should also mention that in the first patch I sent back in May, I
> added some code that made the 8.3 name problem easier on the user. It
> basically forced the shortname= option, overriding the mount option,
> when the patch was triggered. The end result was that a name like
> dcis3000.jpg would always be stored as a 8.3 name, and thus be visible
> to digital cameras, even if the mount options were set to say that
> lowercase names should be considered as "long" names.
>
> Hirofumi objected, on the basis that I was overriding the VFAT
> mount option. I think that overriding in this case would in fact be
> worthwhile, as I don't think many users ever think carefully about
> what shortname= option they are using, and unless you get it right
> then you can get some real surprises.
>
> Hirofumi-san, do you think that same objection you expressed
> previously also applies to this new patch? For example, would you
> think it reasonable to modify the patch to store the filename as 8.3
> if it can fit in 8.3 in a case mapped manner? Or store as 8.3 if it is
> all uppercase or all lowercase?

I have no objection to improve. And in this case, for this option, to
force the shortname= sounds reasonable.

Thanks.

> I think we will hit cases like the one Jan has pointed out where the
> exising shortname= options will become even more confusing than they
> were already when this new patch is applied, especially as I think
> most distros these days magically supply a shortname= option when you
> insert some VFAT formatted media.
-- 
OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
