Return-Path: <linux-kernel-owner+w=401wt.eu-S1759686AbXH1VYn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759686AbXH1VYn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Aug 2007 17:24:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753132AbXH1VYe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Aug 2007 17:24:34 -0400
Received: from tomts25.bellnexxia.net ([209.226.175.188]:62882 "EHLO
	tomts25-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753307AbXH1VYd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Aug 2007 17:24:33 -0400
Date: Tue, 28 Aug 2007 17:24:31 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Christoph Hellwig <hch@infradead.org>, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org
Subject: Re: [patch 3/4] Linux Kernel Markers - Documentation
Message-ID: <20070828212431.GB12422@Krystal>
References: <20070820202704.927923667@polymtl.ca> <20070820202759.645867202@polymtl.ca> <20070828205314.GA10549@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <20070828205314.GA10549@infradead.org>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 17:24:07 up 29 days, 21:42,  6 users,  load average: 0.11, 0.16, 0.26
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

* Christoph Hellwig (hch@infradead.org) wrote:
> On Mon, Aug 20, 2007 at 04:27:07PM -0400, Mathieu Desnoyers wrote:
> > Here is some documentation explaining what is/how to use the Linux
> > Kernel Markers.
> 
> While porting my code from an older markers version I noticed the
> marker callbacks have grown a void *private argument.  Add it to
> the documentation aswell.
> 
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> 
Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>

Thanks!

> Index: linux-2.6/Documentation/marker.txt
> ===================================================================
> --- linux-2.6.orig/Documentation/marker.txt	2007-08-28 22:50:37.000000000 +0200
> +++ linux-2.6/Documentation/marker.txt	2007-08-28 22:51:07.000000000 +0200
> @@ -115,7 +115,7 @@ struct probe_data {
>  };
>  
>  void probe_subsystem_event(const struct __mark_marker *mdata,
> -		const char *format, ...)
> +		void *private, const char *format, ...)
>  {
>  	va_list ap;
>  	/* Declare args */

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
