Return-Path: <linux-kernel-owner+w=401wt.eu-S1751755AbZHIKYX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751755AbZHIKYX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Aug 2009 06:24:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751545AbZHIKYW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Aug 2009 06:24:22 -0400
Received: from buzzloop.caiaq.de ([212.112.241.133]:35424 "EHLO
	buzzloop.caiaq.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751337AbZHIKYV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Aug 2009 06:24:21 -0400
Date: Sun, 9 Aug 2009 12:24:17 +0200
From: Daniel Mack <daniel@caiaq.de>
To: Roel Kluin <roel.kluin@gmail.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
       libertas-dev@lists.infradead.org, linux-wireless@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: Libertas: Association request to the driver failed
Message-ID: <20090809102417.GH13639@buzzloop.caiaq.de>
References: <20090807191156.GS19257@buzzloop.caiaq.de>
 <20090807193610.GK7545@tuxdriver.com>
 <20090808123512.GZ19257@buzzloop.caiaq.de>
 <4A7D8AB6.9030707@gmail.com>
 <4A7E9596.4070901@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A7E9596.4070901@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Aug 09, 2009 at 11:23:34AM +0200, Roel Kluin wrote:
> >> The change came in after -rc5,
> >> and I found 57921c31 ("libertas: Read buffer overflow") to be the
> >> culprit. Reverting it brings my libertas device back to life. I copied
> >> the author.
> >>
> >> Thanks,
> >> Daniel
> > 
> > Ah, I think I made an error, I think tmp is too small and should be
> > 
> > u8 tmp[*rates_size * ARRAY_SIZE(lbs_bg_rates) - 1];
> 
> After some sleep I realized it should be:
> 
> u8 tmp[*rates_size * ARRAY_SIZE(lbs_bg_rates)];

I'll test that tomorrow. Would be easier if you send in a new patch I
can ack directly in case it works :)

Thanks,
Daniel
