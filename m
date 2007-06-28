Return-Path: <linux-kernel-owner+w=401wt.eu-S1764432AbXF1H6z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764432AbXF1H6z (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jun 2007 03:58:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758614AbXF1H6r
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Jun 2007 03:58:47 -0400
Received: from poesci.dolphinics.no ([81.175.23.36]:44226 "EHLO
	poesci.dolphinics.no" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754627AbXF1H6r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jun 2007 03:58:47 -0400
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: "Julio M. Merino Vidal" <jmerino@ac.upc.edu>,
       Oleg Verych <olecom@flower.upol.cz>, Andi Kleen <ak@suse.de>,
       lkml <linux-kernel@vger.kernel.org>, <akpm@linux-foundation.org>
Subject: Re: NAK (bashizm in the /bin/sh script): [PATCH v3] doc/oops-tracing: add Code: decode info
References: <20070621225108.bb69a93d.randy.dunlap@oracle.com>
	<200706221626.39969.ak@suse.de>
	<20070622094429.0910c7cb.randy.dunlap@oracle.com>
	<200706221923.02736.ak@suse.de>
	<20070622132810.3c758590.randy.dunlap@oracle.com>
	<E1I2159-0005AH-DS@flower>
	<20070623104303.a186c5a8.randy.dunlap@oracle.com>
	<87645bhtvw.fsf@pelargir.dolphinics.no>
	<20070626101958.1cf6c6ae.randy.dunlap@oracle.com>
	<B2A2FE52-84FF-4F03-8B19-38AC894D857A@ac.upc.edu>
	<20070626105602.8bae494b.randy.dunlap@oracle.com>
From: Arne Georg Gleditsch <argggh@dolphinics.no>
Date: Thu, 28 Jun 2007 09:58:45 +0200
In-Reply-To: <20070626105602.8bae494b.randy.dunlap@oracle.com> (Randy Dunlap's message of "Tue\, 26 Jun 2007 10\:56\:02 -0700")
Message-ID: <871wfwik7e.fsf@pelargir.dolphinics.no>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/23.0.0 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Randy Dunlap <randy.dunlap@oracle.com> writes:
> On Tue, 26 Jun 2007 19:25:00 +0200 Julio M. Merino Vidal wrote:
>> The correct expression could be $((${a} + 2)).  Tested under NetBSD's  
>> sh, which is very POSIX-compliant.
>
> Thanks.  Does anyone see other changes that are needed?

[..]

> and the complete script is:

Both busybox sh and dash are happy with this.  (Or rather, busybox
would be if its mktemp hadn't been broken.)

-- 
								Arne.
