Return-Path: <linux-kernel-owner+w=401wt.eu-S1756774AbYFRXsv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756774AbYFRXsv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2008 19:48:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754835AbYFRXsm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Jun 2008 19:48:42 -0400
Received: from styx.suse.cz ([82.119.242.94]:44854 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754776AbYFRXsl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2008 19:48:41 -0400
Date: Thu, 19 Jun 2008 01:48:40 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: James Bottomley <James.Bottomley@hansenpartnership.com>
cc: benh@kernel.crashing.org, ksummit-2008-discuss@lists.linux-foundation.org,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [Ksummit-2008-discuss] Request for discussion on when to merge
 drivers
In-Reply-To: <1213832399.3515.109.camel@localhost.localdomain>
Message-ID: <alpine.LNX.1.10.0806190143230.4593@jikos.suse.cz>
References: <1213802866.3515.24.camel@localhost.localdomain> <1213831894.8011.29.camel@pasglop> <1213832399.3515.109.camel@localhost.localdomain>
User-Agent: Alpine 1.10 (LNX 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 18 Jun 2008, James Bottomley wrote:

> Arguably, I can do this by putting it into my upstream tree (which feeds
> into linux-next) the reason for not doing so is that Linus likes us to
> preserve history in there when we can.

This of course applies only for branches/trees for which there are 
downstream git users.

If the only reason you merge the driver into your tree is to have it 
propagated into linux-next, you could very well create a separate branch 
for it, and pull this branch into the one linux-next pulls from you (I 
guess you have a dedicated branch for linux-next which is safe to be 
rebased by definition, right?).

> If I need to pull the driver for a reroll it really screws the git 
> history

But not in any of the branches that have upstream git users.

-- 
Jiri Kosina
SUSE Labs
