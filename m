Return-Path: <linux-kernel-owner+w=401wt.eu-S1757030AbYGUBDU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757030AbYGUBDU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jul 2008 21:03:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755208AbYGUBDF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Jul 2008 21:03:05 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:45789
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1754956AbYGUBDF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jul 2008 21:03:05 -0400
Date: Sun, 20 Jul 2008 18:03:04 -0700 (PDT)
Message-Id: <20080720.180304.51601407.davem@davemloft.net>
To: torvalds@linux-foundation.org
Cc: akpm@linux-foundation.org, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org, jmorris@namei.org, kaber@trash.net
Subject: Re: [GIT]: Networking
From: David Miller <davem@davemloft.net>
In-Reply-To: <alpine.LFD.1.10.0807201751440.31863@woody.linux-foundation.org>
References: <20080720.104411.81744468.davem@davemloft.net>
	<alpine.LFD.1.10.0807201751440.31863@woody.linux-foundation.org>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Sun, 20 Jul 2008 17:54:04 -0700 (PDT)

> On Sun, 20 Jul 2008, David Miller wrote:
> > 
> > Hello Linus.  This is the main networking merge for 2.6.27
> 
> Grr. And I quote:
> 
> 	  Security table (IP_NF_SECURITY) [Y/n/?] (NEW) ?
> 	
> 	This option adds a `security' table to iptables, for use
> 	with Mandatory Access Control (MAC) policy.
> 	
> 	If unsure, say N.
> 
> why the heck does this new config option apparently default to 'Y'? It's a 
> new option, so no old users can need it, and the docs even say you should 
> say 'N' unless you know what you're doing.
> 
> (Same issue with the IPv6 version).
> 
> Don't do this.

James/Patrick please fix this.

Thanks.
