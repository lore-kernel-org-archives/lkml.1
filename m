Return-Path: <linux-kernel-owner+w=401wt.eu-S1758680AbXFZRZR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758680AbXFZRZR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jun 2007 13:25:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756075AbXFZRZG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Jun 2007 13:25:06 -0400
Received: from gw.ac.upc.edu ([147.83.30.3]:54437 "EHLO gw.ac.upc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756648AbXFZRZF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jun 2007 13:25:05 -0400
In-Reply-To: <20070626101958.1cf6c6ae.randy.dunlap@oracle.com>
References: <20070621225108.bb69a93d.randy.dunlap@oracle.com> <200706221626.39969.ak@suse.de> <20070622094429.0910c7cb.randy.dunlap@oracle.com> <200706221923.02736.ak@suse.de> <20070622132810.3c758590.randy.dunlap@oracle.com> <E1I2159-0005AH-DS@flower> <20070623104303.a186c5a8.randy.dunlap@oracle.com> <87645bhtvw.fsf@pelargir.dolphinics.no> <20070626101958.1cf6c6ae.randy.dunlap@oracle.com>
Mime-Version: 1.0 (Apple Message framework v752.3)
Content-Type: text/plain; charset=US-ASCII; delsp=yes; format=flowed
Message-Id: <B2A2FE52-84FF-4F03-8B19-38AC894D857A@ac.upc.edu>
Cc: Arne Georg Gleditsch <argggh@dolphinics.no>,
       Oleg Verych <olecom@flower.upol.cz>, Andi Kleen <ak@suse.de>,
       lkml <linux-kernel@vger.kernel.org>, <akpm@linux-foundation.org>
Content-Transfer-Encoding: 7bit
From: "Julio M. Merino Vidal" <jmerino@ac.upc.edu>
Subject: Re: NAK (bashizm in the /bin/sh script): [PATCH v3] doc/oops-tracing: add Code: decode info
Date: Tue, 26 Jun 2007 19:25:00 +0200
To: Randy Dunlap <randy.dunlap@oracle.com>
X-Mailer: Apple Mail (2.752.3)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 26/06/2007, at 19:19, Randy Dunlap wrote:
>
> Are these 2 line changes all that is needed?
>
> I sort of expected expressions like $((a + 2)) to need change also...
> maybe not for dash, but for sh?

The correct expression could be $((${a} + 2)).  Tested under NetBSD's  
sh, which is very POSIX-compliant.

-- 
Julio M. Merino Vidal <jmerino@ac.upc.edu>


