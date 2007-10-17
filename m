Return-Path: <linux-kernel-owner+w=401wt.eu-S934505AbXJQCJK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934505AbXJQCJK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2007 22:09:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758017AbXJQCI4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Oct 2007 22:08:56 -0400
Received: from ra.tuxdriver.com ([70.61.120.52]:2202 "EHLO ra.tuxdriver.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753965AbXJQCIy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2007 22:08:54 -0400
Date: Tue, 16 Oct 2007 21:03:39 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, kay.sievers@vrfy.org,
       linux-kernel@vger.kernel.org, Bcm43xx-dev@lists.berlios.de,
       linux-wireless@vger.kernel.org, Michael Buesch <mb@bu3sch.de>
Subject: Re: [PATCH] ssb: Fix regression in 2.6.23-git3 due to change in
	calling add_uevent_var
Message-ID: <20071017010338.GA3441@tuxdriver.com>
References: <47119f37.hwmEVx/qSP6GAYhm%Larry.Finger@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47119f37.hwmEVx/qSP6GAYhm%Larry.Finger@lwfinger.net>
User-Agent: Mutt/1.5.14 (2007-02-12)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 13, 2007 at 11:46:47PM -0500, Larry Finger wrote:
> In commit 7eff2e7a8b65c25920207324e56611150eb1cd9a, the calling sequence
> for add_uevent_var was changed, but the ssb driver was not modified, which
> leads to a "Unable to handle kernel paging request" oops. This patch fixes
> the problem.

Sorry, Al Viro got a patch merged before I got to yours!

Thanks anyway!

John
-- 
John W. Linville
linville@tuxdriver.com
