Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757011Ab0BBWMt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Feb 2010 17:12:49 -0500
Received: from mail.solarflare.com ([216.237.3.220]:37748 "EHLO
	exchange.solarflare.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756982Ab0BBWMp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Feb 2010 17:12:45 -0500
Subject: Re: [PATCH] seastar - SeaStar Ethernet driver
From: Ben Hutchings <bhutchings@solarflare.com>
To: Randy Dunlap <rdunlap@xenotime.net>
Cc: Kevin Pedretti <ktpedre@sandia.gov>, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <4B68A03E.1010403@xenotime.net>
References: <20100202205845.GE5246@hawkeye.sandia.gov>
	 <4B68A03E.1010403@xenotime.net>
Content-Type: text/plain
Organization: Solarflare Communications
Date: Tue, 02 Feb 2010 22:12:41 +0000
Message-Id: <1265148761.2622.10.camel@achroite.uk.solarflarecom.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 (2.26.1-2.fc11) 
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 02 Feb 2010 22:13:28.0144 (UTC) FILETIME=[F237ED00:01CAA454]
X-TM-AS-Product-Ver: SMEX-8.0.0.1181-6.000.1038-17168.004
X-TM-AS-Result: No--19.998400-0.000000-31
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-02-02 at 13:59 -0800, Randy Dunlap wrote:
> On 02/02/10 12:58, Kevin Pedretti wrote:
[...]
> > +static void seastar_map_host_region(struct ss_priv *ssp, const void *addr)
> > +{
> > +	/* Round addr to the nearest 128 MB */
> > +	unsigned long raw_paddr = __pa(addr);
> > +	unsigned long paddr = raw_paddr&  ~((1<<  28) - 1);
> > +
> > +	htb_map[8] = 0x8000 | ((paddr>>  28) + 0);
> > +	htb_map[9] = 0x8000 | ((paddr>>  28) + 1);
> 
> space before <<, &, and >>
[...]

The spacing looked correct here.

Ben.

-- 
Ben Hutchings, Senior Software Engineer, Solarflare Communications
Not speaking for my employer; that's the marketing department's job.
They asked us to note that Solarflare product names are trademarked.

