Return-Path: <linux-kernel-owner+w=401wt.eu-S933085AbXCZIJv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933085AbXCZIJv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Mar 2007 04:09:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933660AbXCZIJv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Mar 2007 04:09:51 -0400
Received: from madara.hpl.hp.com ([192.6.19.124]:59936 "EHLO madara.hpl.hp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933085AbXCZIJs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Mar 2007 04:09:48 -0400
Date: Mon, 26 Mar 2007 00:09:08 -0800
From: Stephane Eranian <eranian@hpl.hp.com>
To: Folkert van Heusden <folkert@vanheusden.com>
Cc: Vignesh Babu BM <vignesh.babu@wipro.com>, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, ak@suse.de,
       Jan Engelhardt <jengelh@linux01.gwdg.de>
Subject: Re: kmalloc() with size zero
Message-ID: <20070326080908.GF9144@frankl.hpl.hp.com>
Reply-To: eranian@hpl.hp.com
References: <20070323001824.GA26540@frankl.hpl.hp.com> <Pine.LNX.4.61.0703230237390.9555@yvahk01.tjqt.qr> <1174624770.10742.2.camel@wriver-t81fb058.linuxcoe> <20070325163013.GW741@vanheusden.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070325163013.GW741@vanheusden.com>
User-Agent: Mutt/1.4.1i
Organisation: HP Labs Palo Alto
Address: HP Labs, 1U-17, 1501 Page Mill road, Palo Alto, CA 94304, USA.
E-mail: eranian@hpl.hp.com
X-HPL-MailScanner: Found to be clean
X-HPL-MailScanner-From: eranian@hpl.hp.com
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Sun, Mar 25, 2007 at 06:30:34PM +0200, Folkert van Heusden wrote:
> > > I'd say "feature", glibc's malloc also returns an address on
> > > malloc(0).
> > > 
> > This is implementation defined-the standard allows for return of either
> > null or an address.
> 
> Entirely for entertainment: AIX (5.3) returns NULL, IRIX returns a valid
> address.
> 
That's interesting, so many different behaviors! Personally, I still prefer
when malloc(0) returns zero because it makes it easier to catch errors.

-- 

-Stephane
