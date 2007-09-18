Return-Path: <linux-kernel-owner+w=401wt.eu-S1756771AbXIRXXj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756771AbXIRXXj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Sep 2007 19:23:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752411AbXIRXXb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Sep 2007 19:23:31 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:13364 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751804AbXIRXXb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Sep 2007 19:23:31 -0400
Date: Tue, 18 Sep 2007 16:22:10 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       "Frank Ch. Eigler" <fche@redhat.com>,
       Christoph Hellwig <hch@infradead.org>
Subject: Re: [patch 3/4] Linux Kernel Markers - Documentation
Message-Id: <20070918162210.5da258ea.randy.dunlap@oracle.com>
In-Reply-To: <20070918211459.816763211@polymtl.ca>
References: <20070918211324.161373216@polymtl.ca>
	<20070918211459.816763211@polymtl.ca>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.4.2 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 18 Sep 2007 17:13:27 -0400 Mathieu Desnoyers wrote:

> Here is some documentation explaining what is/how to use the Linux
> Kernel Markers.
> 
> ---
> 
>  Documentation/markers/markers.txt          |   93 +++++++++++++++++++++++++++
>  Documentation/markers/src/Makefile         |    7 ++
>  Documentation/markers/src/marker-example.c |   55 ++++++++++++++++
>  Documentation/markers/src/probe-example.c  |   98 +++++++++++++++++++++++++++++
>  4 files changed, 253 insertions(+)
> 
> Index: linux-2.6-lttng/Documentation/markers/markers.txt
> ===================================================================
> --- /dev/null	1970-01-01 00:00:00.000000000 +0000
> +++ linux-2.6-lttng/Documentation/markers/markers.txt	2007-09-07 09:17:45.000000000 -0400
> @@ -0,0 +1,93 @@

> +The marker mechanism supports inserting multiple instances of the same marker.
> +Markers can be put in inline functions, inlined static functions, and
> +unrolled loops.

as well as regular functions ?

> +* Probe / marker example
> +
> +See the example provided in Documentation/markers/markers/src

                                       drop one of ^^^ "markers/"

> +Run, as root :
> +
> +make
> +insmod marker-example.ko (insmod order is not important)
> +insmod probe-example.ko
> +cat /proc/marker-example (returns an expected error)
> +rmmod marker-example probe-example
> +dmesg


---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
