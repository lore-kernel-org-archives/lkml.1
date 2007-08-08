Return-Path: <linux-kernel-owner+w=401wt.eu-S937886AbXHHUjj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937886AbXHHUjj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2007 16:39:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758305AbXHHUj0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Aug 2007 16:39:26 -0400
Received: from sovereign.computergmbh.de ([85.214.69.204]:35521 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754639AbXHHUjZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2007 16:39:25 -0400
Date: Wed, 8 Aug 2007 22:39:24 +0200 (CEST)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: Joe Perches <joe@perches.com>
cc: Jean Delvare <khali@linux-fr.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       mm-commits@vger.kernel.org, adaplas@pol.net, greg@kroah.com,
       jeff@garzik.org
Subject: Re: + remove-current-defines-and-uses-of-pr_err-add-pr_emerg.patch
 added to -mm tree
In-Reply-To: <1186605086.11897.67.camel@localhost>
Message-ID: <Pine.LNX.4.64.0708082237210.10387@fbirervta.pbzchgretzou.qr>
References: <tI4NY5SL.1186153543.0764100.khali@localhost> 
 <1186179369.13852.36.camel@localhost>  <20070807131949.fa060048.akpm@linux-foundation.org>
  <20070808220226.1dc03a67@hyperion.delvare> <1186605086.11897.67.camel@localhost>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Aug 8 2007 13:31, Joe Perches wrote:
>Goals in desired implementation sequence:
>
>1 Standardization of pr_<level>
>2 Correctness of single line uses of pr_<level>
>3 Correctness of multiple line uses of printk(<level>)
>4 Removal of local near equivalents of pr_<level>
>5 Standardization of pr_<level> as single line only
>6 Conversion of single line printk(KERN_<level> to pr_level
>7 Standardize local #defines to enable/print pr_<level>
>  __file__/__func__/__line__

I fail to see what problem these are trying to fix. Please post some broken
code that would 'benefit' from pr_halleluja, and why printk(level ) could not
do the same.

>8 Minimization/elimination of interleaved log messages

This is a separate, and worthwhile, thing to do, yes.
And it can be done without deviating from the regular printk().


	Jan
-- 
