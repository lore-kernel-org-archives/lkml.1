Return-Path: <linux-kernel-owner+w=401wt.eu-S938225AbXHHUcV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S938225AbXHHUcV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2007 16:32:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932289AbXHHUcF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Aug 2007 16:32:05 -0400
Received: from DSL022.labridge.com ([206.117.136.22]:2259 "EHLO Perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761345AbXHHUcE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2007 16:32:04 -0400
Subject: Re: + remove-current-defines-and-uses-of-pr_err-add-pr_emerg.patch
	added to -mm tree
From: Joe Perches <joe@perches.com>
To: Jean Delvare <khali@linux-fr.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       mm-commits@vger.kernel.org, adaplas@pol.net, greg@kroah.com,
       jeff@garzik.org
In-Reply-To: <20070808220226.1dc03a67@hyperion.delvare>
References: <tI4NY5SL.1186153543.0764100.khali@localhost>
	 <1186179369.13852.36.camel@localhost>
	 <20070807131949.fa060048.akpm@linux-foundation.org>
	 <20070808220226.1dc03a67@hyperion.delvare>
Content-Type: text/plain
Date: Wed, 08 Aug 2007 13:31:26 -0700
Message-Id: <1186605086.11897.67.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.2-2.1mdv2007.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-08-08 at 22:02 +0200, Jean Delvare wrote:
> On Tue, 7 Aug 2007 13:19:49 -0700, Andrew Morton wrote:
> > On Fri, 03 Aug 2007 15:16:09 -0700
> > Joe Perches <joe@perches.com> wrote:
> > > Add new pr_<level> printk(KERN_<level> fmt "\n", ##arg) to kernel.h
> > > pr_info and pr_debug are unchanged
> > > Remove local pr_err #defines
> > > Convert current uses of pr_err
> > OK, I've lost the plot here.  If we have now converged on an
> > agreeable patch, please resend it?
> I don't think we have, no.
> It's not even clear what Joe is trying to achieve.

Goals in desired implementation sequence:

1 Standardization of pr_<level>
2 Correctness of single line uses of pr_<level>
3 Correctness of multiple line uses of printk(<level>)
4 Removal of local near equivalents of pr_<level>
5 Standardization of pr_<level> as single line only
6 Conversion of single line printk(KERN_<level> to pr_level
7 Standardize local #defines to enable/print pr_<level>
  __file__/__func__/__line__
8 Minimization/elimination of interleaved log messages

cheers, Joe

