Return-Path: <linux-kernel-owner+w=401wt.eu-S1754153AbYKLSt2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754153AbYKLSt2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2008 13:49:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752531AbYKLStS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Nov 2008 13:49:18 -0500
Received: from tomts13.bellnexxia.net ([209.226.175.34]:62871 "EHLO
	tomts13-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752375AbYKLStR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2008 13:49:17 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApsEABuxGklMQWxa/2dsb2JhbACBds5rg1c
Date: Wed, 12 Nov 2008 13:49:06 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Arnaldo Carvalho de Melo <acme@redhat.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] markers: Add missing stdargs.h include, needed due to
	va_list usage
Message-ID: <20081112184905.GA28208@Krystal>
References: <20081112125212.GA13263@ghostprotocols.net> <20081112172147.GD24126@Krystal> <20081112180139.GH13263@ghostprotocols.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <20081112180139.GH13263@ghostprotocols.net>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 13:48:32 up 160 days, 23:28,  8 users,  load average: 3.24, 1.26,
	1.01
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Arnaldo Carvalho de Melo (acme@redhat.com) wrote:
> Em Wed, Nov 12, 2008 at 12:21:47PM -0500, Mathieu Desnoyers escreveu:
> > * Arnaldo Carvalho de Melo (acme@redhat.com) wrote:
> > > diff --git a/include/linux/marker.h b/include/linux/marker.h
> > > index 889196c..6213b5e 100644
> > > --- a/include/linux/marker.h
> > > +++ b/include/linux/marker.h
> > > @@ -12,6 +12,7 @@
> > >   * See the file COPYING for more details.
> > >   */
> > >  
> > > +#include <stdarg.h>
> > 
> > Hrm given it's already included in kernel.h for printk, I am not sure
> > it's required here ? Although it cannot hurt to add it explicitly.
> 
> Well, its just that while writing code I noticed that if I included
> marker.h as the first include the compilation would fail.
> 
> My impression was that if you use something, you should include its
> definition, not relying on the includes hell.
> 

Ok,

Acked-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>

Thanks,

Mathieu

> > Mathieu
> > 
> > >  #include <linux/types.h>
> > >  
> > >  struct module;

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
