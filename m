Return-Path: <linux-kernel-owner+w=401wt.eu-S1759330AbXEaChz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759330AbXEaChz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2007 22:37:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755963AbXEaChs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 May 2007 22:37:48 -0400
Received: from mga09.intel.com ([134.134.136.24]:38143 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755658AbXEaChq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2007 22:37:46 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.14,596,1170662400"; 
   d="scan'208";a="92040685"
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Subject: RE: BUG: sleeping function called from invalid context at kernel/fork.c:385
Date: Wed, 30 May 2007 19:37:45 -0700
Message-ID: <617E1C2C70743745A92448908E030B2A01929DD3@scsmsx411.amr.corp.intel.com>
In-Reply-To: <Pine.LNX.4.64.0705301657530.3832@schroedinger.engr.sgi.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: BUG: sleeping function called from invalid context at kernel/fork.c:385
Thread-Index: AcejGAixn1k91OG4QuyhbKhTkDJfEAAFDLZw
From: "Luck, Tony" <tony.luck@intel.com>
To: "Christoph Lameter" <clameter@sgi.com>,
       "Randy Dunlap" <randy.dunlap@oracle.com>
Cc: "David Chinner" <dgc@sgi.com>, "Andrew Morton" <akpm@linux-foundation.org>,
       "lkml" <linux-kernel@vger.kernel.org>, <linux-ia64@vger.kernel.org>,
       "Sam Ravnborg" <sam@ravnborg.org>
X-OriginalArrivalTime: 31 May 2007 02:37:45.0776 (UTC) FILETIME=[ABB14B00:01C7A32C]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> Ahh okay. cscope will do that too.... But all have __exit.

The trick is that one of them *shouldn't* have __exit.  With cscope
you'll have to use the "Find functions calling this function:"
mode to try and find the __init function that is calling an
__exit function.

-Tony
