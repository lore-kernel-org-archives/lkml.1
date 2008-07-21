Return-Path: <linux-kernel-owner+w=401wt.eu-S1757373AbYGUAyp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757373AbYGUAyp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jul 2008 20:54:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755630AbYGUAye
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Jul 2008 20:54:34 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35544 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755409AbYGUAyd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jul 2008 20:54:33 -0400
Date: Sun, 20 Jul 2008 17:54:04 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: David Miller <davem@davemloft.net>
cc: akpm@linux-foundation.org, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [GIT]: Networking
In-Reply-To: <20080720.104411.81744468.davem@davemloft.net>
Message-ID: <alpine.LFD.1.10.0807201751440.31863@woody.linux-foundation.org>
References: <20080720.104411.81744468.davem@davemloft.net>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Sun, 20 Jul 2008, David Miller wrote:
> 
> Hello Linus.  This is the main networking merge for 2.6.27

Grr. And I quote:

	  Security table (IP_NF_SECURITY) [Y/n/?] (NEW) ?
	
	This option adds a `security' table to iptables, for use
	with Mandatory Access Control (MAC) policy.
	
	If unsure, say N.

why the heck does this new config option apparently default to 'Y'? It's a 
new option, so no old users can need it, and the docs even say you should 
say 'N' unless you know what you're doing.

(Same issue with the IPv6 version).

Don't do this.

		Linus
