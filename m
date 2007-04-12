Return-Path: <linux-kernel-owner+w=401wt.eu-S2992577AbXDLPau@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992577AbXDLPau (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Apr 2007 11:30:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992578AbXDLPau
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Apr 2007 11:30:50 -0400
Received: from mail.screens.ru ([213.234.233.54]:47993 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S2992577AbXDLPat (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Apr 2007 11:30:49 -0400
Date: Thu, 12 Apr 2007 18:35:41 +0400
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: lkml <linux-kernel@vger.kernel.org>, inaky.perez-gonzalez@intel.com,
       dwalker@mvista.com, tglx@linutronix.de,
       akpm <akpm@linux-foundation.org>
Subject: Re: [PATCH] kernel-doc: fix plist.h comments
Message-ID: <20070412143541.GA177@tv-sign.ru>
References: <20070411173913.3a758a46.randy.dunlap@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070411173913.3a758a46.randy.dunlap@oracle.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/11, Randy Dunlap wrote:
>
> From: Randy Dunlap <randy.dunlap@oracle.com>
> 
> Make kernel-doc comments match macro names.
> Correct parameter names in a few places.
> Remove '#' from beginning of kernel-doc comment macro names.
> Remove extra (erroneous) blank lines in kernel-doc.
> 
> Warning(plist.h:100): Cannot understand  * #PLIST_HEAD_INIT - static struct plist_head initializer on line 100 - I thought it was a doc line
> Warning(plist.h:112): Cannot understand  * #PLIST_NODE_INIT - static struct plist_node initializer on line 112 - I thought it was a doc line
> Warning(plist.h:103): No description found for parameter '_lock'
> Warning(plist.h:129): No description found for parameter 'lock'
> Warning(plist.h:158): No description found for parameter 'pos'
> Warning(plist.h:169): No description found for parameter 'pos'
> Warning(plist.h:169): No description found for parameter 'n'
> Warning(plist.h:179): No description found for parameter 'mem'
> 
> This still leaves one warning & one error that need attention:
> Error(plist.h:219): cannot understand prototype: '('
> Warning(plist.h): no structured comments found

(off-topic)

plist is very simple and generic. It's a pity we have plist_head.lock.
It is strange that plist_del() has a "head" parameter just to make
CONFIG_DEBUG_PI_LIST happy.

It would be better imho to make a separate d_plist_head or something for
rtmutex.

Oleg.

