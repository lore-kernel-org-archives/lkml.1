Return-Path: <linux-kernel-owner+w=401wt.eu-S1754652AbYHSJtz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754652AbYHSJtz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2008 05:49:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753513AbYHSJtm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Aug 2008 05:49:42 -0400
Received: from isilmar.linta.de ([213.133.102.198]:38162 "EHLO linta.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753099AbYHSJtl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2008 05:49:41 -0400
Date: Tue, 19 Aug 2008 11:49:38 +0200
From: Dominik Brodowski <linux@dominikbrodowski.net>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Andreas Mohr <andi@lisas.de>, linux-kernel@vger.kernel.org,
       linux-acpi@vger.kernel.org, johnstul@us.ibm.com,
       hirofumi@mail.parknet.co.jp, alan@lxorguk.ukuu.org.uk,
       arjan@infradead.org
Subject: Re: [PATCH 1/2] acpi_pm.c: use proper read function also in errata mode.
Message-ID: <20080819094938.GA21126@isilmar.linta.de>
Mail-Followup-To: Dominik Brodowski <linux@dominikbrodowski.net>,
	Andrew Morton <akpm@linux-foundation.org>,
	Andreas Mohr <andi@lisas.de>, linux-kernel@vger.kernel.org,
	linux-acpi@vger.kernel.org, johnstul@us.ibm.com,
	hirofumi@mail.parknet.co.jp, alan@lxorguk.ukuu.org.uk,
	arjan@infradead.org
References: <20080810101730.GA10024@rhlx01.hs-esslingen.de> <20080810162920.GA9860@comet.dominikbrodowski.net> <20080810190759.GA1879@rhlx01.hs-esslingen.de> <20080818190325.GA12581@comet.dominikbrodowski.net> <20080818121924.6b61f7af.akpm@linux-foundation.org> <20080818193517.GA22097@isilmar.linta.de> <20080818124755.162f24d1.akpm@linux-foundation.org> <20080818200916.GA18209@comet.dominikbrodowski.net> <20080818201033.GB18209@comet.dominikbrodowski.net> <20080819024334.2f3e69fa.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080819024334.2f3e69fa.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 19, 2008 at 02:43:34AM -0700, Andrew Morton wrote:
> On Mon, 18 Aug 2008 22:10:33 +0200 Dominik Brodowski <linux@dominikbrodowski.net> wrote:
> 
> > -	value1 = read_pmtmr();
> > +	value1 = clocksource_acpi_pm.read()
> >  	mach_countup(&count);
> > -	value2 = read_pmtmr();
> > +	value2 = clocksource_acpi_pm.read()
> 
> compiler got upset.  Did you send the wrong version?

gcc version 4.2.3 (Ubuntu 4.2.3-2ubuntu7) on amd64 worked fine... what did
yours complain about?

Best,
	Dominik
