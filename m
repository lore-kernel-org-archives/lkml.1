Return-Path: <linux-kernel-owner+w=401wt.eu-S1753897AbZHaR46@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753897AbZHaR46 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Aug 2009 13:56:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753864AbZHaR44
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 31 Aug 2009 13:56:56 -0400
Received: from mail-yw0-f188.google.com ([209.85.211.188]:52281 "EHLO
	mail-yw0-f188.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753854AbZHaR4x convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Aug 2009 13:56:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :content-type:content-transfer-encoding;
        b=CI+QLmy87/Vdk+GzLOWswhKoRWZ7a+QBpOvKYOFAlcWFUa/eYOVfj0OGBeRTL4HPjn
         UVzMFqfWmlsCXHO+JCgOHZ1T6t4MMhPXKJQ3vCTqQOinM1jdGWc9w12h3hh5BC6HWaJV
         3A4KHHK4STjGdhpEsikQrjttvA2IrEUiz1CLg=
MIME-Version: 1.0
In-Reply-To: <20090830152023.GB23828@mit.edu>
References: <20090824212518.GF29763@elf.ucw.cz> <4A947682.2010204@redhat.com>
	 <200908262253.17886.rob@landley.net> <4A967175.5070700@redhat.com>
	 <20090827221319.GA1601@ucw.cz> <4A9733C1.2070904@redhat.com>
	 <20090828064449.GA27528@elf.ucw.cz> <20090828120854.GA8153@mit.edu>
	 <20090830075135.GA1874@ucw.cz> <20090830152023.GB23828@mit.edu>
Date: Mon, 31 Aug 2009 10:49:28 -0700
Message-ID: <4807377b0908311049id9a2167r937bc8447c2b3546@mail.gmail.com>
Subject: Re: raid is dangerous but that's secret (was Re: [patch] ext2/3: 
	document conditions when reliable operation is possible)
From: Jesse Brandeburg <jesse.brandeburg@gmail.com>
To: Theodore Tso <tytso@mit.edu>, Pavel Machek <pavel@ucw.cz>,
       NeilBrown <neilb@suse.de>, Ric Wheeler <rwheeler@redhat.com>,
       Rob Landley <rob@landley.net>, Florian Weimer <fweimer@bfk.de>,
       Goswin von Brederlow <goswin-v-b@web.de>,
       kernel list <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@osdl.org>, mtk.manpages@gmail.com,
       rdunlap@xenotime.net, linux-doc@vger.kernel.org,
       linux-ext4@vger.kernel.org, corbet@lwn.net
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Aug 30, 2009 at 8:20 AM, Theodore Tso<tytso@mit.edu> wrote:
> So we *do* have the warning light; the problem is that just as some
> people may not realize that "check brakes" means, "YOU COULD DIE",
> some people may not realize that "hard drive failure; RAID array
> degraded" could mean, "YOU COULD LOSE DATA".
>
> Fortunately, for software RAID, this is easily solved; if you are so
> concerned, why don't you submit a patch to mdadm adjusting the e-mail
> sent to the system administrator when the array is in a degraded
> state, such that it states, "YOU COULD LOSE DATA".  I would gently
> suggest to you this would be ***far*** more effective that a patch to
> kernel documentation.

In the case of a degraded array, could the kernel be more proactive
(or maybe even mdadm) and have the filesystem remount itself withOUT
journalling enabled?  This seems on the surface to be possible, but I
don't know the internal particulars that might prevent/allow it.
