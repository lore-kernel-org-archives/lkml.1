Return-Path: <linux-kernel-owner+w=401wt.eu-S1759852AbZEMLO0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759852AbZEMLO0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 May 2009 07:14:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759735AbZEMLOM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 May 2009 07:14:12 -0400
Received: from rv-out-0506.google.com ([209.85.198.230]:13548 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759555AbZEMLOK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 May 2009 07:14:10 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:in-reply-to:references:x-mailer
         :mime-version:content-type:content-transfer-encoding;
        b=ptvd7tIg/7aYVT0wa/MVD3Yyb4M4/+a4ONDjU7ckLo5NGRrSXt4KzOw1hHnDRNlvoN
         Q3LzAiCI8IuH6TAWjFrguzU7oRiDS2o0QxVDykNgTlPLSD66rYG137/dR9Gc6HgdPH+T
         3M2byz/tnt/AH34QzPmoKnfCV3w0mgOwnn6vA=
Date: Wed, 13 May 2009 20:13:49 +0900
From: Minchan Kim <minchan.kim@gmail.com>
To: David Woodhouse <dwmw2@infradead.org>
Cc: Minchan Kim <minchan.kim@gmail.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Lee Schermerhorn <Lee.Schermerhorn@hp.com>,
       Matt Mackall <mpm@selenic.com>
Subject: Re: [PATCH] Kconfig: CONFIG_UNEVICTABLE_LRU move into EMBEDDED
 submenu
Message-Id: <20090513201349.a90a9d46.minchan.kim@barrios-desktop>
In-Reply-To: <1242211037.24436.552.camel@macbook.infradead.org>
References: <20090513172904.7234.A69D9226@jp.fujitsu.com>
	<20090513175152.1590c117.minchan.kim@barrios-desktop>
	<20090513175539.723A.A69D9226@jp.fujitsu.com>
	<20090513191221.674bc543.minchan.kim@barrios-desktop>
	<1242211037.24436.552.camel@macbook.infradead.org>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 13 May 2009 11:37:17 +0100
David Woodhouse <dwmw2@infradead.org> wrote:

> On Wed, 2009-05-13 at 19:12 +0900, Minchan Kim wrote:
> > > No.
> > > As far as I know, many embedded guys use this configuration.
> > > they hate unexpected latency by reclaim. !UNEVICTABLE_LRU increase
> > > unexpectability largely.
> > 
> > As I said previous(http://lkml.org/lkml/2009/3/16/209), Many embedded
> > environment have a small ram. It doesn't have a big impact in such
> > case. 
> > 
> > Let CCed embedded matainers. 
> > I won't have a objection if embedded maintainers ack this. 
> 
> I probably wouldn't be cheerleading for it if you wanted to make it
> optional when it wasn't before -- but I suppose we might as well
> preserve the option under CONFIG_EMBEDDED if the alternative is to lose
> it completely.

Thanks for good commeting.
If embedded maintainer don't have an obejction, me, too. :)

But Let's add following comment like CONFIG_AIO. 

"Disabling this option saves about 7k"

> 
> Acked-by: David Woodhouse <David.Woodhouse@intel.com>
> 
> -- 
> David Woodhouse                            Open Source Technology Centre
> David.Woodhouse@intel.com                              Intel Corporation
> 


-- 
Kinds Regards
Minchan Kim
