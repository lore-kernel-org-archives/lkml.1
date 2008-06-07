Return-Path: <linux-kernel-owner+w=401wt.eu-S932157AbYFGGnu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932157AbYFGGnu (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Jun 2008 02:43:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753269AbYFGGnn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Jun 2008 02:43:43 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43639 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751882AbYFGGnn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Jun 2008 02:43:43 -0400
Date: Fri, 6 Jun 2008 23:43:14 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Rik van Riel <riel@redhat.com>, linux-kernel@vger.kernel.org,
       lee.schermerhorn@hp.com
Subject: Re: [PATCH -mm 07/25] second chance replacement for anonymous pages
Message-Id: <20080606234314.265f5005.akpm@linux-foundation.org>
In-Reply-To: <20080607150154.9C55.KOSAKI.MOTOHIRO@jp.fujitsu.com>
References: <20080606202858.744030156@redhat.com>
	<20080606180443.43f782e2.akpm@linux-foundation.org>
	<20080607150154.9C55.KOSAKI.MOTOHIRO@jp.fujitsu.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 07 Jun 2008 15:03:42 +0900 KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com> wrote:

> > > + * pages.  Ie. a ratio of 3 means 3:1 or 25% of the anonymous pages are
> > > + * on the inactive list.
> > > + *
> > > + * total     return    max
> > > + * memory    value     inactive anon
> > 
> > This function doesn't "return" a "value".
> 
> Sorry, my bad.
> 
> in my country, "return value" is right word.

Not for a function which returns void!

> s/value/ratio/ is better?

Well it's referring to the value of zone->inactive_ratio.  So
replacing "return value" with "zone->inactive_ratio" would be ideal :)

> > 
> > > + * -------------------------------------
> > > + *   10MB       1         5MB
> > > + *  100MB       1        50MB
> > > + *    1GB       3       250MB
> > > + *   10GB      10       0.9GB
> > > + *  100GB      31         3GB
> > > + *    1TB     101        10GB
> > > + *   10TB     320        32GB
> > > + */
> 
