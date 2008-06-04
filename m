Return-Path: <linux-kernel-owner+w=401wt.eu-S1759513AbYFDJSh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759513AbYFDJSh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2008 05:18:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754020AbYFDJS3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Jun 2008 05:18:29 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:55482 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753001AbYFDJS3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2008 05:18:29 -0400
Subject: Re: [linux-pm] [PATCH] add a printk_init variant storing format
	strings in	__initdata
From: David Woodhouse <dwmw2@infradead.org>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       pavel@suse.cz, Andy Whitcroft <apw@shadowen.org>, mingo@elte.hu,
       linux-pm@lists.linux-foundation.org
In-Reply-To: <1212570622.14371.19.camel@johannes.berg>
References: <20080529162257.03426e48.akpm@linux-foundation.org>
	 <1212485252.0@pinky> <20080604011607.15dec5a7.akpm@linux-foundation.org>
	 <1212569949.4042.56.camel@shinybook.infradead.org>
	 <1212570622.14371.19.camel@johannes.berg>
Content-Type: text/plain
Date: Wed, 04 Jun 2008 10:17:59 +0100
Message-Id: <1212571079.4042.66.camel@shinybook.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 (2.22.1-2.fc9) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2008-06-04 at 11:10 +0200, Johannes Berg wrote:
> On Wed, 2008-06-04 at 09:59 +0100, David Woodhouse wrote:
> > On Wed, 2008-06-04 at 01:16 -0700, Andrew Morton wrote:
> > > We're going to want to be able to call printk_init() from modules. 
> > > Please fix and test that, if we decide to proceed.
> > 
> > Can we fix that by making it an alias for printk in the module case?
> > 
> > The only reason we need it to be __init is so that we get the section
> > warnings when you use it from non-init code, right? Won't we get the
> > warning when non-init code refers to the string in initdata anyway?
> 
> In fact, wasn't the warning Andy showed such a warning?

Hm, yes it was. Why do we need __printk_init() to be anything other than
an alias for printk, then?

-- 
dwmw2

