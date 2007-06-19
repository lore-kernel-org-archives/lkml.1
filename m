Return-Path: <linux-kernel-owner+w=401wt.eu-S1759474AbXFSNex@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759474AbXFSNex (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jun 2007 09:34:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751388AbXFSNep
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Jun 2007 09:34:45 -0400
Received: from tomts13-srv.bellnexxia.net ([209.226.175.34]:62567 "EHLO
	tomts13-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752101AbXFSNeo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jun 2007 09:34:44 -0400
Date: Tue, 19 Jun 2007 09:30:20 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Arjan van de Ven <arjan@infradead.org>
Cc: prasanna@in.ibm.com, Andi Kleen <ak@suse.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Chuck Ebbert <cebbert@redhat.com>, linux-kernel@vger.kernel.org,
       ananth@in.ibm.com
Subject: Re: [patch 2/2] kprobes x86_64 quick fix mark-ro-data
Message-ID: <20070619133020.GA22368@Krystal>
References: <20070615202310.178466032@polymtl.ca> <4676D2A9.6090403@redhat.com> <20070618115632.7aca8c0f.akpm@linux-foundation.org> <200706182132.56559.ak@suse.de> <20070619100644.GA5478@in.ibm.com> <20070619100810.GA301@in.ibm.com> <1182259288.3014.7.camel@laptopd505.fenrus.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <1182259288.3014.7.camel@laptopd505.fenrus.org>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 09:29:49 up 21 days, 22:08,  3 users,  load average: 0.79, 1.28, 1.44
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

* Arjan van de Ven (arjan@infradead.org) wrote:
> On Tue, 2007-06-19 at 15:38 +0530, S. P. Prasanna wrote:
> > This patch is a quick fix for x86_64 to enable kprobes only if DEBUG_RODATA is
> > not configured. Since DEBUG_RODATA markes the kernel text pages as read-only.
> 
> 
> it does??
> 
> I don't seem to be able to find this in the source code..... 
> 

See arch/x86_64/mm/init.c:mark_rodata_ro().

Mathieu

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
