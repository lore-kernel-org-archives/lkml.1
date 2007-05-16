Return-Path: <linux-kernel-owner+w=401wt.eu-S1762980AbXEPXke@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762980AbXEPXke (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2007 19:40:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757511AbXEPXk0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 May 2007 19:40:26 -0400
Received: from gw.goop.org ([64.81.55.164]:36995 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757473AbXEPXk0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2007 19:40:26 -0400
Message-ID: <464B9664.2040200@goop.org>
Date: Wed, 16 May 2007 16:40:20 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: David Chinner <dgc@sgi.com>
CC: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, xfs-masters@oss.sgi.com
Subject: Re: [2/3] 2.6.22-rc1: known regressions v2 - XFS
References: <464B6743.9000607@googlemail.com> <464B6A2B.9020703@googlemail.com> <20070516233419.GP85884050@sgi.com>
In-Reply-To: <20070516233419.GP85884050@sgi.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

David Chinner wrote:
> Jeremy has tentatively indicated that the patch has fixed the problem.
> Have you seen any more problems since applying the patch, Jeremy?
>   

No, it continues to seem sound with casual use; I would have expected to
see the problem reoccur by now.  I'd like to rerun the full set of tests
I did before to be sure, but so far so good.  No other apparent
regressions either.

Also, the match between the observed symptoms and the bugfix is very
good, which adds confidence (ie, no element of "it works now but we
don't know why").  I guess the only remaining concern is whether there
are any other paths which fail to dirty the inode.

Did you manage to repro the problem?

    J
