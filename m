Return-Path: <linux-kernel-owner+w=401wt.eu-S1751821AbXCYQah@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751821AbXCYQah (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Mar 2007 12:30:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751872AbXCYQah
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 Mar 2007 12:30:37 -0400
Received: from keetweej.vanheusden.com ([213.84.46.114]:43880 "EHLO
	keetweej.vanheusden.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751821AbXCYQag (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Mar 2007 12:30:36 -0400
Date: Sun, 25 Mar 2007 18:30:34 +0200
From: Folkert van Heusden <folkert@vanheusden.com>
To: Vignesh Babu BM <vignesh.babu@wipro.com>
Cc: Stephane Eranian <eranian@hpl.hp.com>, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, ak@suse.de,
       Jan Engelhardt <jengelh@linux01.gwdg.de>
Subject: Re: kmalloc() with size zero
Message-ID: <20070325163013.GW741@vanheusden.com>
References: <20070323001824.GA26540@frankl.hpl.hp.com> <Pine.LNX.4.61.0703230237390.9555@yvahk01.tjqt.qr> <1174624770.10742.2.camel@wriver-t81fb058.linuxcoe>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1174624770.10742.2.camel@wriver-t81fb058.linuxcoe>
Organization: www.unixexpert.nl
X-Chameleon-Return-To: folkert@vanheusden.com
X-Xfmail-Return-To: folkert@vanheusden.com
X-Phonenumber: +31-6-41278122
X-URL: http://www.vanheusden.com/
X-PGP-KeyID: 1F28D8AE
X-GPG-fingerprint: AC89 09CE 41F2 00B4 FCF2  B174 3019 0E8C 1F28 D8AE
X-Key: http://pgp.surfnet.nl:11371/pks/lookup?op=get&search=0x1F28D8AE
Reply-By: Sun Mar 18 00:02:24 CET 2007
X-Message-Flag: PGP key-id: 0x1f28d8ae - consider encrypting your e-mail to me with PGP!
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> > I'd say "feature", glibc's malloc also returns an address on
> > malloc(0).
> > 
> This is implementation defined-the standard allows for return of either
> null or an address.

Entirely for entertainment: AIX (5.3) returns NULL, IRIX returns a valid
address.


Folkert van Heusden

-- 
MultiTail är en flexibel redskap för att fälja logfilar, utför av
commandoer, filtrera, ge färg, sammanfoga, o.s.v. följa.
http://www.vanheusden.com/multitail/
----------------------------------------------------------------------
Phone: +31-6-41278122, PGP-key: 1F28D8AE, www.vanheusden.com
