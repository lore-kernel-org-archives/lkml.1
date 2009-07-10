Return-Path: <linux-kernel-owner+w=401wt.eu-S1751573AbZGJAKP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751573AbZGJAKP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jul 2009 20:10:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750842AbZGJAKD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Jul 2009 20:10:03 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:53921 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750799AbZGJAKB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jul 2009 20:10:01 -0400
Date: Fri, 10 Jul 2009 01:09:45 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Theodore Tso <tytso@mit.edu>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, tridge@samba.org,
       Martin Steigerwald <Martin@lichtvoll.de>,
       Jan Engelhardt <jengelh@medozas.de>,
       Rusty Russell <rusty@rustcorp.com.au>, Pavel Machek <pavel@ucw.cz>,
       john.lanza@linux.com,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-fsdevel@vger.kernel.org,
       Dave Kleikamp <shaggy@linux.vnet.ibm.com>, corbet@lwn.net,
       jcm@jonmasters.org
Subject: Re: CONFIG_VFAT_FS_DUALNAMES regressions
Message-ID: <20090710010945.234cd8aa@lxorguk.ukuu.org.uk>
In-Reply-To: <20090709152541.GA6334@mit.edu>
References: <19028.3736.892828.352905@samba.org>
	<20090708110451.1092afa7@lxorguk.ukuu.org.uk>
	<19028.31088.400461.939917@samba.org>
	<20090708130256.40957c3f@lxorguk.ukuu.org.uk>
	<19028.39145.180869.603673@samba.org>
	<20090708142510.5068b4c3@lxorguk.ukuu.org.uk>
	<19029.17896.769106.375379@samba.org>
	<20090709104228.7821e2f0@lxorguk.ukuu.org.uk>
	<1247147981.3898.15.camel@mulgrave.site>
	<20090709151009.07b2508b@lxorguk.ukuu.org.uk>
	<20090709152541.GA6334@mit.edu>
X-Mailer: Claws Mail 3.7.1 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> However, I don't think they will think it's necessary, and I'll tell
> you why.  Regardless of whether or not source code with an #ifdef'ed

They do it for existing cases in existing packages. So I'd say the
evidence is very very clearly that they will and they do, already, now,
at this moment. No speculation - go look at the packages.

> the case), either way, the *binary*, which is to say the **product**
> does not contain any of the infringing functionality or code.  Hence,

You have a GPL obligation to supply the sources used to build the binary.

> But in any case, even for a very risk-averse company, getting this
> proposed patch into mainline is useful, since at any point in time the
> company can get a version of the code without any code that might be
> claimable as being infringing by using unifdef.  So it's still a net
> win.  And if people are worried about the very small chances of

That aspect of the argument makes sense and I would agree with you. Its
one way to keep a reference implementation in tree as a patch.

> problems (which perhaps we can improve), we can fix that as future
> patches against the mainline --- which is the right way to do OSS
> development.  Given that Hirofumi-san has already decided to take this
> patch, so unless Linus decides to override his decision, this
> discussion is rapidly becoming moot in any case.

I've not seen any evidence to support this, and there seem to be other fs
maintainers deeply unhappy with the longname corrupting patch - Christoph
included.

Alan
