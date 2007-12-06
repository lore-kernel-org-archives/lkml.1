Return-Path: <linux-kernel-owner+w=401wt.eu-S1753975AbXLFOMh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753975AbXLFOMh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Dec 2007 09:12:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751592AbXLFOM3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Dec 2007 09:12:29 -0500
Received: from tomts13.bellnexxia.net ([209.226.175.34]:54909 "EHLO
	tomts13-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753109AbXLFOM2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Dec 2007 09:12:28 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Ah4FAP6RV0dMROHU/2dsb2JhbACBWo9P
Date: Thu, 6 Dec 2007 09:07:22 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: akpm@linux-foundation.org, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org
Subject: Re: [patch 00/11] Text Edit Lock for 2.6.24-rc4-git3
Message-ID: <20071206140722.GA10542@Krystal>
References: <20071206020246.417605824@polymtl.ca> <20071206094712.GB10455@osiris.boeblingen.de.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <20071206094712.GB10455@osiris.boeblingen.de.ibm.com>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 08:59:35 up 32 days, 19:05,  4 users,  load average: 0.27, 0.23,
	0.33
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Heiko Carstens (heiko.carstens@de.ibm.com) wrote:
> On Wed, Dec 05, 2007 at 09:02:46PM -0500, Mathieu Desnoyers wrote:
> > Hi,
> > 
> > Here is a repost of the text edit lock for 2.6.24-rc4-mm3. It is useful to
> > coordinate modification of live kernel code patching.
> > 
> > It includes a modification to kprobes (its first user) and is useful for the
> > Immediate Values.
> > 
> > It could be interesting to queue it for 2.6.25.
> 
> Everytime I see your huge patchset I'm wondering what it is good for and
> give up since the patch set is large. It would be very helpful if your
> patch descriptions would not only describe what you do but also why you
> do it.

Kernel tracing, so that we can help userspace application developpers
and kernel developpers debug problems caused by system-wide
program interactions.

See :

The patchset, including the LTTng tracer :

http://ltt.polymtl.ca/lttng/patch-2.6.24-rc4-git3-lttng-0.10-pre39.tar.bz2

To get the userspace apps that are needed to do something useful :

http://ltt.polymtl.ca/lttng/ltt-control-0.46-06112007.tar.gz
http://ltt.polymtl.ca/packages/lttv-0.10.0-pre5-05122007.tar.gz

http://ltt.polymtl.ca/svn/ltt/branches/poly/QUICKSTART
(a bit outdated)

Mathieu

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
