Return-Path: <linux-kernel-owner+w=401wt.eu-S1756768AbYAHVD2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756768AbYAHVD2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2008 16:03:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751643AbYAHVDU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jan 2008 16:03:20 -0500
Received: from ns.gsystems.sk ([62.176.172.50]:51725 "EHLO www.gsystems.sk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751612AbYAHVDT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2008 16:03:19 -0500
From: Ondrej Zary <linux@rainbow-software.org>
To: Andi Kleen <andi@firstfloor.org>
Subject: Re: The ext3 way of journalling
Date: Tue, 8 Jan 2008 22:03:08 +0100
User-Agent: KMail/1.9.7
Cc: Theodore Tso <tytso@mit.edu>, Tuomo Valkonen <tuomov@iki.fi>,
       linux-kernel@vger.kernel.org
References: <slrnfo77tv.2rr.tuomov@jolt.modeemi.cs.tut.fi> <20080108181525.GL27800@mit.edu> <p734pdoqbva.fsf@bingen.suse.de>
In-Reply-To: <p734pdoqbva.fsf@bingen.suse.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200801082203.11037.linux@rainbow-software.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 08 January 2008 21:51:53 Andi Kleen wrote:
> Theodore Tso <tytso@mit.edu> writes:
> > Now, there are good reasons for doing periodic checks every N mounts
> > and after M months.  And it has to do with PC class hardware.  (Ted's
> > aphorism: "PC class hardware is cr*p").
>
> If these reasons are good ones (some skepticism here) then the correct
> way to really handle this would be to do regular background scrubbing
> during runtime; ideally with metadata checksums so that you can actually
> detect all corruption.
>
> But since fsck is so slow and disks are so big this whole thing
> is a ticking time bomb now. e.g. it is not uncommon to require tens
> of minutes or even hours of fsck time and some server that reboots
> only every few months will eat that when it happens to reboot.
> This means you get a quite long downtime.

That's why I always do "tune2fs -c 0 -i 0" on any new filesystem. It probably 
should be default.

>
> -Andi
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/



-- 
Ondrej Zary
