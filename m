Return-Path: <linux-kernel-owner+w=401wt.eu-S1756223AbXFXOoq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756223AbXFXOoq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Jun 2007 10:44:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751453AbXFXOoi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 Jun 2007 10:44:38 -0400
Received: from static-ip-62-75-166-246.inaddr.intergenia.de ([62.75.166.246]:49290
	"EHLO vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750927AbXFXOoh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Jun 2007 10:44:37 -0400
From: Michael Buesch <mb@bu3sch.de>
To: Alexey Dobriyan <adobriyan@gmail.com>
Subject: Re: [PATCH] hw_random: add quality categories
Date: Sun, 24 Jun 2007 16:43:44 +0200
User-Agent: KMail/1.9.6
Cc: Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
References: <200706241555.22957.mb@bu3sch.de> <20070624143059.GA2944@martell.zuzino.mipt.ru>
In-Reply-To: <20070624143059.GA2944@martell.zuzino.mipt.ru>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200706241643.45126.mb@bu3sch.de>
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 24 June 2007 16:30:59 Alexey Dobriyan wrote:
> On Sun, Jun 24, 2007 at 03:55:22PM +0200, Michael Buesch wrote:
> > This adds quality categories for hardware random number generators.
> 
> > +static const char * hwrng_quality_string(enum hwrng_quality qual)
> > +{
> > +	switch (qual) {
> > +	case HWRNG_QUAL_HIGH:
> > +		return "high";
> > +	case HWRNG_QUAL_NORMAL:
> > +		return "normal";
> > +	case HWRNG_QUAL_LOW:
> > +		return "low";
> > +	case HWRNG_QUAL_PSEUDO:
> > +		return "pseudo";
> 
> And how are you going to extend this in future? HWRNG_QUAL_SUPERB ?

Why extend it? "high" means devices which generate truely
random data. Do you have a device which generates data more
random than true-random? how?

See the descriptions in hw_random.h

-- 
Greetings Michael.
