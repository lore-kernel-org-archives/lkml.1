Return-Path: <linux-kernel-owner+w=401wt.eu-S1754313AbYCMKDS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754313AbYCMKDS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Mar 2008 06:03:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752072AbYCMKDF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Mar 2008 06:03:05 -0400
Received: from mtagate8.de.ibm.com ([195.212.29.157]:41558 "EHLO
	mtagate8.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752002AbYCMKDD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Mar 2008 06:03:03 -0400
Subject: Re: [patch 01/10] Add new fields for System z10 to /proc/sysinfo
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
Reply-To: schwidefsky@de.ibm.com
To: "Josef 'Jeff' Sipek" <jeffpc@josefsipek.net>
Cc: linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org
In-Reply-To: <20080312175751.GB10653@josefsipek.net>
References: <20080312173155.703966894@de.ibm.com>
	 <20080312173216.213008370@de.ibm.com>
	 <20080312175751.GB10653@josefsipek.net>
Content-Type: text/plain
Organization: IBM Corporation
Date: Thu, 13 Mar 2008 11:02:55 +0100
Message-Id: <1205402575.26537.46.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2008-03-12 at 13:57 -0400, Josef 'Jeff' Sipek wrote:
> > Index: quilt-2.6/drivers/s390/sysinfo.c
> > ===================================================================
> > --- quilt-2.6.orig/drivers/s390/sysinfo.c
> > +++ quilt-2.6/drivers/s390/sysinfo.c
> > @@ -26,6 +26,11 @@ struct sysinfo_1_1_1 {
> >  	char sequence[16];
> >  	char plant[4];
> >  	char model[16];
> > +	char model_perm_cap[16];
> > +	char model_temp_cap[16];
> > +	char model_cap_rating[4];
> > +	char model_perm_cap_rating[4];
> > +	char model_temp_cap_rating[4];
> >  };
> 
> I'd try to be safer, and make the struct __attribute__((packed))...

Hmm, that would be true for all sysinfo typedefs. The automatic
alignment does the right thing though. Don't know if its worth the
effort - at least until you get bitten for the first time ;-)

-- 
blue skies,
  Martin.

"Reality continues to ruin my life." - Calvin.


