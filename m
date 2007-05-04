Return-Path: <linux-kernel-owner+w=401wt.eu-S1755272AbXEDNl5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755272AbXEDNl5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 May 2007 09:41:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755256AbXEDNl4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 May 2007 09:41:56 -0400
Received: from extu-mxob-1.symantec.com ([216.10.194.28]:49016 "EHLO
	extu-mxob-1.symantec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755265AbXEDNly (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 May 2007 09:41:54 -0400
Date: Fri, 4 May 2007 14:41:38 +0100 (BST)
From: Hugh Dickins <hugh@veritas.com>
X-X-Sender: hugh@blonde.wat.veritas.com
To: Randy Dunlap <randy.dunlap@oracle.com>
cc: Andrew Morton <akpm@linux-foundation.org>,
       lkml <linux-kernel@vger.kernel.org>, jwboyer@linux.vnet.ibm.com,
       grant.likely@secretlab.ca, jketreno@linux.intel.com
Subject: Re: [PATCH v2] lib/hexdump
In-Reply-To: <20070503174924.d0cbafa3.randy.dunlap@oracle.com>
Message-ID: <Pine.LNX.4.64.0705041431390.16844@blonde.wat.veritas.com>
References: <20070502153556.3c995de7.randy.dunlap@oracle.com>
 <20070502154557.b463c9c3.akpm@linux-foundation.org> <46391730.2080003@oracle.com>
 <20070502160635.31dd91e6.akpm@linux-foundation.org>
 <20070502161533.cbf38b4b.randy.dunlap@oracle.com>
 <20070503174924.d0cbafa3.randy.dunlap@oracle.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-OriginalArrivalTime: 04 May 2007 13:41:51.0923 (UTC) FILETIME=[F8B19030:01C78E51]
X-Brightmail-Verdict: VlJEQwAAAAIAAAABAAAAAAAAAAEAAAAAAAAABmluYm94AGxpbnV4LWtlcm5lbEB2Z2VyLmtlcm5lbC5vcmcAYWtwbUBsaW51eC1mb3VuZGF0aW9uLm9yZwBqa2V0cmVub0BsaW51eC5pbnRlbC5jb20Aandib3llckBsaW51eC52bmV0LmlibS5jb20AZ3JhbnQubGlrZWx5QHNlY3JldGxhYi5jYQByYW5keS5kdW5sYXBAb3JhY2xlLmNvbQA=
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 3 May 2007, Randy Dunlap wrote:
> 
> Example output using %DUMP_PREFIX_OFFSET:
> 0009ab42: 40414243 44454647 48494a4b 4c4d4e4f-@ABCDEFG HIJKLMNO
                                               ^        ^
> Example output using %DUMP_PREFIX_ADDRESS:
> ffffffff88089af0: 70717273 74757677 78797a7b 7c7d7e7f-pqrstuvw xyz{|}~.
                                                       ^        ^
I see that hyphen as joining together two unlike fields rather than
separating them: maybe change it to a couple of spaces?  And the space
halfway through the string is more interfering than helpful (when that
field is useful, it's a string: which shouldn't have a spurious space
inserted).  Otherwise looks nice to me.

Hugh
