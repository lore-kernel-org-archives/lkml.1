Return-Path: <linux-kernel-owner+w=401wt.eu-S1752734AbZHLSPW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752734AbZHLSPW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Aug 2009 14:15:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752543AbZHLSPV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Aug 2009 14:15:21 -0400
Received: from acsinet11.oracle.com ([141.146.126.233]:25827 "EHLO
	acsinet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752527AbZHLSPV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Aug 2009 14:15:21 -0400
MIME-Version: 1.0
Message-ID: <8af5e5b5-31a6-47f3-adee-19ef4ee7d43c@default>
Date: Wed, 12 Aug 2009 11:14:35 -0700 (PDT)
From: Randy Dunlap <randy.dunlap@oracle.com>
To: <peterz@infradead.org>
Cc: <stern@rowland.harvard.edu>, <James.Bottomley@HansenPartnership.com>,
       <akpm@linux-foundation.org>, <mingo@elte.hu>,
       <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Add kerneldoc for flush_scheduled_work()
X-Mailer: Zimbra on Oracle Beehive
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
X-Source-IP: abhmt012.oracle.com [141.146.116.21]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A010201.4A83068D.019B:SCFSTAT5015188,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: peterz@infradead.org

On Wed, 2009-08-12 at 11:41 +0200, Ingo Molnar wrote:
> * Alan Stern <stern@rowland.harvard.edu> wrote:
> 
> > This patch (as1279) adds kerneldoc for flush_scheduled_work()
> > containing a stern warning that the function should be avoided.
> > 
> > Signed-off-by: Alan Stern <stern@rowland.harvard.edu>

> >  
> > +/**
> > + * flush_scheduled_work - ensure that all work scheduled on keventd_wq has run to completion.

> > + */
> 
> Looks good - a small nit: please use proper/consistent line length, 
> something like:
> 
> /**
>  * flush_scheduled_work - ensure that all work scheduled on 
>  *			  keventd_wq has run to completion
>  *

>  */


| And here I was thinking kerneldoc doesn't actually work like that, but
| perhaps Randy fixed it so the initial description can line-wrap?

Nope, function short description is still just a one-liner.

~Randy
