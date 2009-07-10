Return-Path: <linux-kernel-owner+w=401wt.eu-S1757591AbZGJUfJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757591AbZGJUfJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jul 2009 16:35:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757419AbZGJUep
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Jul 2009 16:34:45 -0400
Received: from mail-fx0-f218.google.com ([209.85.220.218]:40597 "EHLO
	mail-fx0-f218.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754559AbZGJUen (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jul 2009 16:34:43 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-disposition:message-id:content-type
         :content-transfer-encoding;
        b=rEKbMr13ZoKrCMUPDhBGb+6m3UjYGR9yMKPBvyv7yP2ZmFQ+YAfbXXRtHZEd3GnLyo
         awmvlSkj0SQfMQMy85dea840K+acDw9Vw+MUWf0pqmOr8jsd234kZ6ZMDa0D6x+nBaKk
         4U1sDo4DBX0L/Hk5t/YQ+SL5DrvcJPH4Saigs=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Jonathan Corbet <corbet@lwn.net>
Subject: Re: CONFIG_VFAT_FS_DUALNAMES regressions
Date: Fri, 10 Jul 2009 22:40:14 +0200
User-Agent: KMail/1.11.4 (Linux/2.6.31-rc2-next-20090710-03838-g1540e8b-dirty; KDE/4.2.4; i686; ; )
Cc: Martin Steigerwald <Martin@lichtvoll.de>,
       David Newall <davidn@davidnewall.com>,
       Christoph Hellwig <hch@infradead.org>, Theodore Tso <tytso@mit.edu>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       James Bottomley <James.Bottomley@hansenpartnership.com>,
       tridge@samba.org, Jan Engelhardt <jengelh@medozas.de>,
       Rusty Russell <rusty@rustcorp.com.au>, Pavel Machek <pavel@ucw.cz>,
       john.lanza@linux.com,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-fsdevel@vger.kernel.org,
       Dave Kleikamp <shaggy@linux.vnet.ibm.com>, jcm@jonmasters.org
References: <20090708110451.1092afa7@lxorguk.ukuu.org.uk> <200907102049.12427.Martin@lichtvoll.de> <20090710133127.6839dc87@bike.lwn.net>
In-Reply-To: <20090710133127.6839dc87@bike.lwn.net>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200907102240.15773.bzolnier@gmail.com>
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 10 July 2009 21:31:27 Jonathan Corbet wrote:

> I have a lot of sympathy for Alan's assertion that we can't muck up our
> upstream code with hackarounds for every bit of legal obnoxiousness we
> encounter.  But outright refusal of things like patent workarounds does
> not help us either.  Linux is a pragmatic system; somehow, I believe,
> we can find a way to minimize our patent hassles without messing up the
> system as a whole.

Alan, Pavel and other people are suggesting pragmatic *long-term* solutions,
like moving kernel.org outside problematic geopolitical area.  Tainting *our*
code-base with (confusing for *our* users) workarounds doesn't belong in this
class of solutions.. actually no.. it is a PURE F*CKING IDIOCY..

Microsoft having patents on their *obsolete* filesystem should be *their*
problem, not *ours*.  We keep said filesystem strictly for compatibility
reasons and not because we would like to encourage hardware/software vendors
or users to use it.  Lets just update VFAT help text to mention potential
risks of using it, default it to N, rip it from defconfigs, pass it through
lawyers, remove CONFIG_VFAT_FS_DUALNAMES and move on..

When it comes to distributions if they really need they can easily deal with
the problem by simply allowing the 3-rd parties to host the repositories with
risky package (like they do with mp3 etc).

The end result is that end-users can still use full vfat, vendors are safe,
kernel developers don't waste their time on artificial problems and the blame
goes where it belong..

[ The validity of potentially bogus patents (or problems of hardware vendors
  caused by *their* decisions to use *obsolete* and patent-risky filesystem in
  their products) is an entirely different matter/discussion and it shouldn't
  be mixed with technical solutions.. ]
