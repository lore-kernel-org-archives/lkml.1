Return-Path: <linux-kernel-owner+w=401wt.eu-S1756040AbYCHFhP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756040AbYCHFhP (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Mar 2008 00:37:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751494AbYCHFhB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 8 Mar 2008 00:37:01 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:36508 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751046AbYCHFhB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Mar 2008 00:37:01 -0500
Date: Sat, 8 Mar 2008 14:41:21 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org
Subject: Re: [PATCH] [6/13] Core maskable allocator
Message-Id: <20080308144121.5f283231.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20080308140334.15987554.kamezawa.hiroyu@jp.fujitsu.com>
References: <200803071007.493903088@firstfloor.org>
	<20080307090716.9D3E91B419C@basil.firstfloor.org>
	<20080308140334.15987554.kamezawa.hiroyu@jp.fujitsu.com>
Organization: Fujitsu
X-Mailer: Sylpheed 2.4.2 (GTK+ 2.10.11; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 8 Mar 2008 14:03:34 +0900
KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> wrote:

> On Fri,  7 Mar 2008 10:07:16 +0100 (CET)
> Andi Kleen <andi@firstfloor.org> wrote:
> 
> > +static int __init setup_maskzone(char *s)
> > +{
> > +	do {
> > +		if (isdigit(*s)) {
> > +			mask_zone_size = memparse(s, &s);
> > +		} else if (!strncmp(s, "force", 5)) {
> > +			force_mask = 1;
> > +			s += 5;
> > +		} else
> > +			return -EINVAL;
> > +		if (*s == ',')
> > +			++s;
> > +	} while (*s);
> > +	return 0;
> > +}
> > +early_param("maskzone", setup_maskzone);
> 
> please confirm mask_zone_size is aligned to MAX_ORDER.
> 
Sorry, please ignore above comment :(

Thanks,
-Kame

