Return-Path: <linux-kernel-owner+w=401wt.eu-S1755652AbYL2Abg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755652AbYL2Abg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Dec 2008 19:31:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752536AbYL2Ab1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Dec 2008 19:31:27 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38209 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751620AbYL2Ab1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Dec 2008 19:31:27 -0500
Date: Sun, 28 Dec 2008 16:31:15 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Stephen Rothwell <sfr@canb.auug.org.au>
cc: Steve French <smfrench@gmail.com>, linux-cifs-client@lists.samba.org,
       "David S. Miller" <davem@davemloft.net>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: linux-next: origin tree build failure
In-Reply-To: <20081229103849.1cb1eb54.sfr@canb.auug.org.au>
Message-ID: <alpine.LFD.2.00.0812281630100.3082@localhost.localdomain>
References: <20081229103849.1cb1eb54.sfr@canb.auug.org.au>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 29 Dec 2008, Stephen Rothwell wrote:
> 
> Maybe someone should have warned Linus about the below known interaction
> between the net tree and the cifs tree ...

Gaah. I should have grepped for it, since the other place caused a 
conflict that I fixed. And I even tested that the result of my conflict 
resolution compiled, but since I don't configure cifs myself, I literally 
tested just the conflicting file.

Applied the fix, thanks,

		Linus
