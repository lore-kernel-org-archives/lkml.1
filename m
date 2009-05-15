Return-Path: <linux-kernel-owner+w=401wt.eu-S1754180AbZEOSpa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754180AbZEOSpa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 May 2009 14:45:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753234AbZEOSpT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 May 2009 14:45:19 -0400
Received: from charlotte.tuxdriver.com ([70.61.120.58]:41628 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752746AbZEOSpS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 May 2009 14:45:18 -0400
Date: Fri, 15 May 2009 14:33:20 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: linux-kernel@vger.kernel.org
Cc: Jiri Slaby <jirislaby@gmail.com>, johannes@sipsolutions.net,
       linux-wireless@vger.kernel.org, Felix Fietkau <nbd@openwrt.org>,
       davem@davemloft.net, torvalds@linux-foundation.org
Subject: Re: [PATCH 1/2] mac80211: minstrel, fix memory corruption
Message-ID: <20090515183319.GF2773@tuxdriver.com>
References: <1241453096-8517-1-git-send-email-jirislaby@gmail.com> <20090515182131.GA6439@fancy-poultry.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090515182131.GA6439@fancy-poultry.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 15, 2009 at 08:21:31PM +0200, Heinz Diehl wrote:
> On 04.05.2009, Jiri Slaby wrote: 
> 
> > minstrel doesn't count max rate count in fact, since it doesn't use
> > a loop variable `i' and hence allocs space only for bitrates found in
> > the first band.
> [....]
> 
> This patchset crashes my WLAN. Reverting it does fix this:

http://www.kernel.org/pub/linux/kernel/people/linville/wireless-2.6/0002-mac80211-avoid-NULL-ptr-deref-when-finding-max_rate.patch

Original pull request here:

	http://marc.info/?l=linux-kernel&m=124214056932143&w=2

Unfortunately, I think Dave might have limited availability right now...

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
