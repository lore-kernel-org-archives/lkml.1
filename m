Return-Path: <linux-kernel-owner+w=401wt.eu-S1750790AbXBVCtC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750790AbXBVCtC (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Feb 2007 21:49:02 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750856AbXBVCtB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Feb 2007 21:49:01 -0500
Received: from mx2.suse.de ([195.135.220.15]:46368 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750790AbXBVCtB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Feb 2007 21:49:01 -0500
From: Neil Brown <neilb@suse.de>
To: Pierre Ossman <drzeus-list@drzeus.cx>
Date: Thu, 22 Feb 2007 13:48:00 +1100
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <17885.1120.437885.35438@notabene.brown>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: Block layer still stack abuser?
In-Reply-To: message from Pierre Ossman on Friday February 16
References: <45D59C3C.4090403@drzeus.cx>
X-Mailer: VM 7.19 under Emacs 21.4.1
X-face: [Gw_3E*Gng}4rRrKRYotwlE?.2|**#s9D<ml'fY1Vw+@XfR[fRCsUoP?K6bt3YD\ui5Fh?f
	LONpR';(ql)VM_TQ/<l_^D3~B:z$\YC7gUCuC=sYm/80G=$tt"98mr8(l))QzVKCk$6~gldn~*FK9x
	8`;pM{3S8679sP+MbP,72<3_PIH-$I&iaiIb|hV1d%cYg))BmI)AZ
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday February 16, drzeus-list@drzeus.cx wrote:
> I was wondering if the block layer has been changed into a more serialized
> manner yet? I've been trying to google this, but so far no luck. I know there
> was some talk about removing the stack based approach, but I can't find any
> information about where this went.
> 
> If it is currently fixed, a pointer to from which version would be nice.

Might this:
   http://lkml.org/lkml/2007/2/10/22

relate to your question?
If you are talking about stacking block device (via dm or md), then a
patch to fix this in in -mm but there are or were some potential
issues in dm that seem to be holding it up.

NeilBrown
