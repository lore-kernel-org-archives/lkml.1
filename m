Return-Path: <linux-kernel-owner+w=401wt.eu-S1759002AbXETPvX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759002AbXETPvX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 May 2007 11:51:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757011AbXETPvP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 May 2007 11:51:15 -0400
Received: from smtpout.hostsharing.net ([83.223.95.15]:58584 "EHLO
	smtpout.hostsharing.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756770AbXETPvP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 May 2007 11:51:15 -0400
Date: Sun, 20 May 2007 17:49:06 +0200
From: Elimar Riesebieter <riesebie@lxtec.de>
To: aeb@cwi.nl, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Cornelia Huck <cornelia.huck@de.ibm.com>
Subject: Re: 2.6.22-rc2 built on ppc (3)
Message-ID: <20070520154906.GA4314@aragorn.home.lxtec.de>
Mail-Followup-To: aeb@cwi.nl, linux-kernel@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	Cornelia Huck <cornelia.huck@de.ibm.com>
References: <20070520111113.GE3253@aragorn.home.lxtec.de> <20070520122351.GC2006@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20070520122351.GC2006@localhost.localdomain>
Organization: LXTEC
X-gnupg-key-fingerprint: BE65 85E4 4867 7E9B 1F2A  B2CE DC88 3C6E C54F 7FB0
X-Editor: VIM - Vi IMproved 7.1 (2007 May 12, compiled May 15 2007 21:03:06)
User-Agent: Mutt/1.5.15+lxtec (2007-05-02)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 20 May 2007 the mental interface of
WANG Cong told:

> On Sun, May 20, 2007 at 01:11:13PM +0200, Elimar Riesebieter wrote:
> >Hi,
> >
> >FYI, building the kernel with
> >gcc (GCC) 4.1.3 20070514 (prerelease) (Debian 4.1.2-7)
> >on my powerbook (PPC) gives:
> >
> >...
> >fs/partitions/check.c: In function 'add_partition':
> >fs/partitions/check.c:392: warning: ignoring return value of 'kobject_add', declared with attribute warn_unused_result
> >fs/partitions/check.c:395: warning: ignoring return value of 'sysfs_create_link', declared with attribute warn_unused_result
> >fs/partitions/check.c:403: warning: ignoring return value of 'sysfs_create_file', declared with attribute warn_unused_result
> >...
> >
> >If more info is needed, please contact me via PM, as I am not
> >subscribed.
> >
> >Thanks for your patience
> >Elimar
> >
> 
> I don't know why these warnings are still in kernel. We have fixed them yet. Could you please check and try this patch?
> 
> http://marc.info/?l=linux-mm-commits&m=117624330000536&w=2

  CC      fs/partitions/check.o
fs/partitions/check.c: In function 'add_partition':
fs/partitions/check.c:398: error: 'struct kset' has no member named 'kset'
make[2]: *** [fs/partitions/check.o] Error 1
^make[1]: *** [fs/partitions] Error 2

Elimar

-- 
  Excellent day for drinking heavily. 
  Spike the office water cooler;-)
