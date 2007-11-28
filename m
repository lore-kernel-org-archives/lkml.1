Return-Path: <linux-kernel-owner+w=401wt.eu-S1757892AbXK1Rns@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757892AbXK1Rns (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2007 12:43:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751440AbXK1Rnk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Nov 2007 12:43:40 -0500
Received: from main.gmane.org ([80.91.229.2]:60102 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753875AbXK1Rnj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2007 12:43:39 -0500
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Stephen Hemminger <shemminger@linux-foundation.org>
Subject: Re: Out of tree module using LSM
Date: Wed, 28 Nov 2007 09:39:56 -0800
Organization: Linux Foundation
Message-ID: <20071128093956.6625584b@freepuppy.rosehill>
References: <20071128144156.GA14106@infradead.org>
	<416908.77038.qm@web36613.mail.mud.yahoo.com>
	<20071128164613.GA21815@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Complaints-To: usenet@ger.gmane.org
X-Gmane-NNTP-Posting-Host: 069-064-229-129.pdx.net
In-Reply-To: <20071128164613.GA21815@infradead.org>
X-Newsreader: Claws Mail 3.0.2 (GTK+ 2.12.1; x86_64-redhat-linux-gnu)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 28 Nov 2007 16:46:13 +0000
Christoph Hellwig <hch@infradead.org> wrote:

> On Wed, Nov 28, 2007 at 08:38:43AM -0800, Casey Schaufler wrote:
> > Would you like to expound on that, or do you feel your claws
> > are sharp enough already?
> 
> Just take a look at code.
> 

The module in question hooks to the syscall table which is not
acceptable.  Including dumpster diving through symbol table to
find the syscall table since it is no longer exported.


-- 
Stephen Hemminger <shemminger@linux-foundation.org>

