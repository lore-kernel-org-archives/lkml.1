Return-Path: <linux-kernel-owner+w=401wt.eu-S1762741AbXFRM7w@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762741AbXFRM7w (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2007 08:59:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756073AbXFRM7n
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Jun 2007 08:59:43 -0400
Received: from mtagate2.de.ibm.com ([195.212.29.151]:4668 "EHLO
	mtagate2.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755775AbXFRM7m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2007 08:59:42 -0400
Subject: Re: [RFC/PATCH] Documentation of kernel messages
From: holzheu <holzheu@linux.vnet.ibm.com>
Reply-To: holzheu@linux.vnet.ibm.com
To: Gerrit Huizenga <gh@us.ibm.com>
Cc: Jan Kara <jack@suse.cz>, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org, randy.dunlap@oracle.com, gregkh@suse.de,
       mtk-manpages@gmx.net, schwidefsky@de.ibm.com, heiko.carstens@de.ibm.com,
       "lf_kernel_messages@linux-foundation.org" 
	<lf_kernel_messages@linux-foundation.org>
In-Reply-To: <E1HzGkR-0008DO-Un@w-gerrit.beaverton.ibm.com>
References: <E1HzGkR-0008DO-Un@w-gerrit.beaverton.ibm.com>
Content-Type: text/plain
Organization: IBM
Date: Mon, 18 Jun 2007 14:55:54 +0200
Message-Id: <1182171354.11400.40.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.0.2 (2.0.2-27.rhel4.6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Gerrit,

The common thing of your and our approach is, that we need an ID to
identify a message either by:

* Using hashes + component name (maybe)
* Or using hand-made message numbers + component name. Numbers have
  to be unique within the kernel component

I think the main difference of your approach is, that documentation will
be maintained outside the kernel. This has advantages, but also
disadvantages:

(+) Developers have less work to do :-)
(+) Kernel sources and patches have less lines of code, since message
    descriptions are not contained in the kernel sources.
(+) You can support multiple languages

(-) Hard to keep printks and descriptions up-to-date. If using hashes,
    each typo fix in a printk breaks the link to your documentation.
(-) Since the developer knows the meaning of a printk best, he probably
    would be the right person to write the description.
(-) For every Distribution or vanilla kernel you probably need separate
    external message databases.

I like the fact, that every printk gets an ID in your approach and you
do not need additional printk macros.

Maybe both approaches are not mutually exclusive. If developers would
like to document their messages within the kernel sources, they still
could use kernel-doc and our KMSG_DOC macro do do that.

I admit, that I am not sure about the the best solution here.

Michael


