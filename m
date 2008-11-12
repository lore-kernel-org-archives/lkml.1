Return-Path: <linux-kernel-owner+w=401wt.eu-S1753506AbYKLSB7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753506AbYKLSB7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2008 13:01:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752255AbYKLSBu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Nov 2008 13:01:50 -0500
Received: from mx2.redhat.com ([66.187.237.31]:35635 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751763AbYKLSBu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2008 13:01:50 -0500
Date: Wed, 12 Nov 2008 16:01:39 -0200
From: Arnaldo Carvalho de Melo <acme@redhat.com>
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] markers: Add missing stdargs.h include, needed due to
	va_list usage
Message-ID: <20081112180139.GH13263@ghostprotocols.net>
Mail-Followup-To: Arnaldo Carvalho de Melo <acme@redhat.com>,
	Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <20081112125212.GA13263@ghostprotocols.net> <20081112172147.GD24126@Krystal>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081112172147.GD24126@Krystal>
X-Url: http://oops.ghostprotocols.net:81/blog
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Wed, Nov 12, 2008 at 12:21:47PM -0500, Mathieu Desnoyers escreveu:
> * Arnaldo Carvalho de Melo (acme@redhat.com) wrote:
> > diff --git a/include/linux/marker.h b/include/linux/marker.h
> > index 889196c..6213b5e 100644
> > --- a/include/linux/marker.h
> > +++ b/include/linux/marker.h
> > @@ -12,6 +12,7 @@
> >   * See the file COPYING for more details.
> >   */
> >  
> > +#include <stdarg.h>
> 
> Hrm given it's already included in kernel.h for printk, I am not sure
> it's required here ? Although it cannot hurt to add it explicitly.

Well, its just that while writing code I noticed that if I included
marker.h as the first include the compilation would fail.

My impression was that if you use something, you should include its
definition, not relying on the includes hell.

> Mathieu
> 
> >  #include <linux/types.h>
> >  
> >  struct module;
