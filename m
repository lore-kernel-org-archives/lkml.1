Return-Path: <linux-kernel-owner+w=401wt.eu-S1759500AbXEaDTb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759500AbXEaDTb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2007 23:19:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756171AbXEaDTU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 May 2007 23:19:20 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:36745 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756163AbXEaDTS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2007 23:19:18 -0400
Date: Wed, 30 May 2007 20:19:18 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: "Luck, Tony" <tony.luck@intel.com>
cc: Randy Dunlap <randy.dunlap@oracle.com>, David Chinner <dgc@sgi.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       lkml <linux-kernel@vger.kernel.org>, linux-ia64@vger.kernel.org,
       Sam Ravnborg <sam@ravnborg.org>
Subject: RE: BUG: sleeping function called from invalid context at
 kernel/fork.c:385
In-Reply-To: <617E1C2C70743745A92448908E030B2A01929DD3@scsmsx411.amr.corp.intel.com>
Message-ID: <Pine.LNX.4.64.0705302019040.5583@schroedinger.engr.sgi.com>
References: <617E1C2C70743745A92448908E030B2A01929DD3@scsmsx411.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 30 May 2007, Luck, Tony wrote:

> > Ahh okay. cscope will do that too.... But all have __exit.
> 
> The trick is that one of them *shouldn't* have __exit.  With cscope
> you'll have to use the "Find functions calling this function:"
> mode to try and find the __init function that is calling an
> __exit function.

Urgh... Does it have to be that difficult?
