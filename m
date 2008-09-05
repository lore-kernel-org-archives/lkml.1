Return-Path: <linux-kernel-owner+w=401wt.eu-S1753704AbYIEQiw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753704AbYIEQiw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2008 12:38:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751824AbYIEQik
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Sep 2008 12:38:40 -0400
Received: from mga02.intel.com ([134.134.136.20]:53772 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751075AbYIEQii convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2008 12:38:38 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.32,320,1217833200"; 
   d="scan'208";a="436113766"
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: [E1000-devel] linux-next: Tree for September 4 (PATCH: IXGBE)
Date: Fri, 5 Sep 2008 09:38:17 -0700
Message-ID: <36D9DB17C6DE9E40B059440DB8D95F520611FFF8@orsmsx418.amr.corp.intel.com>
In-Reply-To: <20080904204137.9b31f644.randy.dunlap@oracle.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [E1000-devel] linux-next: Tree for September 4 (PATCH: IXGBE)
Thread-Index: AckPCWaCnsXb0uofQpqaw9lW4ZPiEgAbESBw
References: <20080904193606.573f2cb3.sfr@canb.auug.org.au> <20080904204137.9b31f644.randy.dunlap@oracle.com>
From: "Brandeburg, Jesse" <jesse.brandeburg@intel.com>
To: "Randy Dunlap" <randy.dunlap@oracle.com>,
       "Stephen Rothwell" <sfr@canb.auug.org.au>,
       "jgarzik" <jgarzik@pobox.com>,
       "Kirsher, Jeffrey T" <jeffrey.t.kirsher@intel.com>,
       <e1000-devel@lists.sourceforge.net>
Cc: "Morton" <akpm@linux-foundation.org>, <linux-next@vger.kernel.org>,
       "LKML" <linux-kernel@vger.kernel.org>,
       <Andrew@sc8-sf-spam2-b.sourceforge.net>
X-OriginalArrivalTime: 05 Sep 2008 16:38:18.0264 (UTC) FILETIME=[CD0E8180:01C90F75]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Randy Dunlap wrote:
> From: Randy Dunlap <randy.dunlap@oracle.com>
> 
> ixgbe needs to be restricted to the same build config (m/y)
> as DCA since it calls the dca_*() functions.
> 
> ixgbe_main.c:(.text+0xd9c09): undefined reference to `dca3_get_tag'

Thanks Randy for catching that, you're correct.

Acked-by: Jesse Brandeburg <jesse.brandeburg@intel.com>
