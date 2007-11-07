Return-Path: <linux-kernel-owner+w=401wt.eu-S1758651AbXKGWCE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758651AbXKGWCE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Nov 2007 17:02:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754954AbXKGWBw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Nov 2007 17:01:52 -0500
Received: from cantor2.suse.de ([195.135.220.15]:38200 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754802AbXKGWBv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Nov 2007 17:01:51 -0500
From: Neil Brown <neilb@suse.de>
To: Al Boldi <a1426z@gawab.com>, Andrew Morton <akpm@linux-foundation.org>,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Thu, 8 Nov 2007 09:01:42 +1100
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18226.13766.77137.149094@notabene.brown>
Subject: Re: Massive slowdown when re-querying large nfs dir - CORRECTION
In-Reply-To: message from Neil Brown on Thursday November 8
References: <200711050758.38090.a1426z@gawab.com>
	<20071106221939.cfa79f9e.akpm@linux-foundation.org>
	<18225.26935.146395.366451@notabene.brown>
	<200711071236.26780.a1426z@gawab.com>
	<18226.13566.548126.927574@notabene.brown>
X-Mailer: VM 7.19 under Emacs 21.4.1
X-face: [Gw_3E*Gng}4rRrKRYotwlE?.2|**#s9D<ml'fY1Vw+@XfR[fRCsUoP?K6bt3YD\ui5Fh?f
	LONpR';(ql)VM_TQ/<l_^D3~B:z$\YC7gUCuC=sYm/80G=$tt"98mr8(l))QzVKCk$6~gldn~*FK9x
	8`;pM{3S8679sP+MbP,72<3_PIH-$I&iaiIb|hV1d%cYg))BmI)AZ
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday November 8, neilb@suse.de wrote:
> 
> Not really a credible difference as the reported difference is between
> two *clients* and the speed of getattr vs lookup would depend on the
> *server*. 

Sorry, my bad.  I misread your original problem description.  It would
appear to be a server difference.

Maybe an "strace -tt" of the nfs server might show some significant
difference.

NeilBrown
