Return-Path: <linux-kernel-owner+w=401wt.eu-S1755939AbXIWNAi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755939AbXIWNAi (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Sep 2007 09:00:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751931AbXIWNAb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Sep 2007 09:00:31 -0400
Received: from ug-out-1314.google.com ([66.249.92.173]:23396 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751097AbXIWNAa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Sep 2007 09:00:30 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:from:organization:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-disposition:message-id:content-type:content-transfer-encoding;
        b=KKg09Ut4xKhaQpC1fmEmXbfhJ+QNy09sLqbOp+yHTUtUZXPcGZyCBj6rkWhaDk4gwhT8r+VxQh5/Io4pwP8ezK9Pz5Y2041TPrcwkr6q6HvU3HZo7Dme20n7qj6gue9BLqubZ2meUgAu26pqQADu+dkREQ8tI2RVu11j7DUkfzo=
From: Mihai =?utf-8?q?Don=C8=9Bu?= <mihai.dontu@gmail.com>
Organization: Home
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [patch 0/2] suspend/resume regression fixes
Date: Sun, 23 Sep 2007 16:00:22 +0300
User-Agent: KMail/1.9.7
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Oleg Verych <olecom@flower.upol.cz>,
       Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Len Brown <lenb@kernel.org>,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>
References: <20070922220347.586903979@linutronix.de> <200709230824.13320.mihai.dontu@gmail.com> <20070923133054.61319662@the-village.bc.nu>
In-Reply-To: <20070923133054.61319662@the-village.bc.nu>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200709231600.23382.mihai.dontu@gmail.com>
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 23 September 2007, Alan Cox wrote:
> >   I switched to libata, but it behaves like the old IDE without ACPI. I
> >   did not manage to get a full dmesg (apparently all volumes are mounted
> >   r/o right after a power up from a s2ram) but I did make a picture, from
> >   which I quote (if I may say so):
> 
> Device errors. 
> 
> Libata currently (wrongly IMHO) defaults to avoiding the use of ACPI
> suspend/resume methods
> 
> So you also need to boot with  "libata.noacpi=0" and if that works beat
> up Jeff a bit ..

  You were right, 'libata.noacpi=0' does the trick :)

  It's interesting my mmc is unmounted before s2ram and then mounted back
  on resume.

  So, to sum  up, I have a working suspend-to-ram with libata. Not bad, not
  bad at all...

  Thanks,

-- 
Mihai Donțu
