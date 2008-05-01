Return-Path: <linux-kernel-owner+w=401wt.eu-S1760534AbYEAEeE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760534AbYEAEeE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 May 2008 00:34:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761047AbYEAEda
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 May 2008 00:33:30 -0400
Received: from e35.co.us.ibm.com ([32.97.110.153]:36338 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761030AbYEAEd3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 May 2008 00:33:29 -0400
Date: Wed, 30 Apr 2008 21:33:25 -0700
From: Tim Pepper <lnxninja@linux.vnet.ibm.com>
To: Nadia.Derbey@bull.net
Cc: manfred@colorfullife.com, paulmck@linux.vnet.ibm.com,
       linux-kernel@vger.kernel.org, efault@gmx.de, akpm@linux-foundation.org
Subject: Re: [PATCH 10/10] Get rid of ipc_lock_down()
Message-ID: <20080501043324.GI30274@tpepper-t42p.dolavim.us>
References: <20080429143304.741001000@bull.net> <20080429143732.153670000@bull.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080429143732.153670000@bull.net>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 29 Apr at 16:33:14 +0200 Nadia.Derbey@bull.net said:
> [PATCH 10/10]
> 
> With the previous patch ipc_lock() becomes lockless.
> So there is no need anymore for ipc_lock_down()-like routines.

...cleanup post conversion to RCU.

Could we get a version of the series without all the duplication and
without the cleanups (separate into standalone pre- and post- patches)?
If you're too busy, now that I've sifted through these I could make a
simpler series that does this.

It will be a looooot easier to discuss the locking when all we're looking
at is the locking changes.

-- 
Tim Pepper  <lnxninja@linux.vnet.ibm.com>
IBM Linux Technology Center
