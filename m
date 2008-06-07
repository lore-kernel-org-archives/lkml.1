Return-Path: <linux-kernel-owner+w=401wt.eu-S1761286AbYFGGEb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761286AbYFGGEb (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Jun 2008 02:04:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756687AbYFGGEY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Jun 2008 02:04:24 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:33755 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756565AbYFGGEY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Jun 2008 02:04:24 -0400
Date: Sat, 07 Jun 2008 15:03:42 +0900
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH -mm 07/25] second chance replacement for anonymous pages
Cc: kosaki.motohiro@jp.fujitsu.com, Rik van Riel <riel@redhat.com>,
       linux-kernel@vger.kernel.org, lee.schermerhorn@hp.com
In-Reply-To: <20080606180443.43f782e2.akpm@linux-foundation.org>
References: <20080606202858.744030156@redhat.com> <20080606180443.43f782e2.akpm@linux-foundation.org>
Message-Id: <20080607150154.9C55.KOSAKI.MOTOHIRO@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.42 [ja]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > + * pages.  Ie. a ratio of 3 means 3:1 or 25% of the anonymous pages are
> > + * on the inactive list.
> > + *
> > + * total     return    max
> > + * memory    value     inactive anon
> 
> This function doesn't "return" a "value".

Sorry, my bad.

in my country, "return value" is right word.
s/value/ratio/ is better?

> 
> > + * -------------------------------------
> > + *   10MB       1         5MB
> > + *  100MB       1        50MB
> > + *    1GB       3       250MB
> > + *   10GB      10       0.9GB
> > + *  100GB      31         3GB
> > + *    1TB     101        10GB
> > + *   10TB     320        32GB
> > + */


