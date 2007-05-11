Return-Path: <linux-kernel-owner+w=401wt.eu-S933165AbXEKWzF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933165AbXEKWzF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 May 2007 18:55:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756579AbXEKWy4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 May 2007 18:54:56 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:24698 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755169AbXEKWy4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 May 2007 18:54:56 -0400
Date: Fri, 11 May 2007 15:57:40 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Andi Kleen <ak@suse.de>, Andrew Morton <akpm@linux-foundation.org>,
       lkml <linux-kernel@vger.kernel.org>, Chris Wright <chrisw@sous-sol.org>
Subject: Re: [patch 4/7] add argv_split()
Message-Id: <20070511155740.25d3cc67.randy.dunlap@oracle.com>
In-Reply-To: <20070511000027.596468000@goop.org>
References: <20070510235708.155502000@goop.org>
	<20070511000027.596468000@goop.org>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.3.1 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Whitelist: TRUE
X-Whitelist: TRUE
X-Brightmail-Tracker: AAAAAQAAAAI=
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 10 May 2007 16:57:12 -0700 Jeremy Fitzhardinge wrote:

> --- /dev/null
> +++ b/lib/argv_split.c
> @@ -0,0 +1,159 @@
> +
> +/**
> + * argv_free - free an argv
> + *

extra "blank" line.

> + * @argv - the argument vector to be freed
> + *
> + * Frees an argv and the strings it points to.
> + */
> +void argv_free(char **argv)
> +{
> +	char **p;
> +	for (p = argv; *p; p++)
> +		kfree(*p);
> +
> +	kfree(argv);
> +}
> +EXPORT_SYMBOL(argv_free);

---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
