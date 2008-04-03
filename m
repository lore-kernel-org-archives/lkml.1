Return-Path: <linux-kernel-owner+w=401wt.eu-S1759506AbYDCPJS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759506AbYDCPJS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Apr 2008 11:09:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757488AbYDCPJI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Apr 2008 11:09:08 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:36848 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757415AbYDCPJH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Apr 2008 11:09:07 -0400
Subject: Re: BUG: ext3 hang in transaction commit
From: Peter Zijlstra <peterz@infradead.org>
To: Jan Kara <jack@suse.cz>
Cc: David Chinner <dgc@sgi.com>, lkml <linux-kernel@vger.kernel.org>,
       marcelo <marcelo@kvack.org>
In-Reply-To: <20080403100742.GA16314@atrey.karlin.mff.cuni.cz>
References: <20080326231612.GC103491721@sgi.com>
	 <20080403100742.GA16314@atrey.karlin.mff.cuni.cz>
Content-Type: text/plain
Date: Thu, 03 Apr 2008 17:08:55 +0200
Message-Id: <1207235335.8514.843.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.21.92 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Marcelo has seen something similar, kjournald got stuck and the rest of
userspace piled on top of it.

The softlockup watchdog triggered because kjournald got stuck in D state
for over 2 minutes. However Marcelo told me that it did get going
eventually...

He had a rather easy to reproduce case IIRC, I'll let him tell you more
about it :-)

