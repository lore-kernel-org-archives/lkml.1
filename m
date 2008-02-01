Return-Path: <linux-kernel-owner+w=401wt.eu-S1758543AbYBASee@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758543AbYBASee (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2008 13:34:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754112AbYBASeD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Feb 2008 13:34:03 -0500
Received: from sca-es-mail-2.Sun.COM ([192.18.43.133]:35574 "EHLO
	sca-es-mail-2.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753842AbYBASd7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2008 13:33:59 -0500
Date: Fri, 01 Feb 2008 10:51:36 -0800
From: Yinghai Lu <Yinghai.Lu@Sun.COM>
Subject: Re: [PATCH] make loglevel related commandline to early_param
In-reply-to: <p73bq704zqs.fsf@bingen.suse.de>
To: Andi Kleen <andi@firstfloor.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Message-id: <200802011051.36943.yinghai.lu@sun.com>
Organization: SUN
MIME-version: 1.0
Content-type: text/plain; charset=iso-8859-1
Content-transfer-encoding: 7BIT
Content-disposition: inline
References: <200802010240.37799.yinghai.lu@sun.com>
 <p73bq704zqs.fsf@bingen.suse.de>
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 01 February 2008 04:39:39 am Andi Kleen wrote:
> Yinghai Lu <Yinghai.Lu@Sun.COM> writes:
> 
> > diff --git a/init/main.c b/init/main.c
> > index cb81ed1..a774a93 100644
> > --- a/init/main.c
> > +++ b/init/main.c
> > @@ -232,22 +232,18 @@ EXPORT_SYMBOL(loops_per_jiffy);
> >  
> >  static int __init debug_kernel(char *str)
> >  {
> > -	if (*str)
> > -		return 0;
> >  	console_loglevel = 10;
> >  	return 1;
> 
> The return semantics changes with early_param so you need to change that in all cases to return 0
> (and negative value for errors) 
> 


thanks. I will send another one.

YH
