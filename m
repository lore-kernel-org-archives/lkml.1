Return-Path: <linux-kernel-owner+w=401wt.eu-S1757315AbYLLKvU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757315AbYLLKvU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Dec 2008 05:51:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752344AbYLLKvL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Dec 2008 05:51:11 -0500
Received: from ping.pong.ch ([212.103.71.101]:49568 "EHLO ping.pong.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752260AbYLLKvK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Dec 2008 05:51:10 -0500
Date: Fri, 12 Dec 2008 11:51:01 +0100
From: Gaudenz Steinlin <gaudenz@debian.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [Bug #12158] commit b1ee26b freezes system on switching from X
	to text console
Message-ID: <20081212105101.GA4915@soziologie.ch>
References: <6VnlupFpCsN.A.2rE.MsEPJB@chimera> <07Xes05z25M.A.OcF.csEPJB@chimera>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <07Xes05z25M.A.OcF.csEPJB@chimera>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi 

On Sun, Dec 07, 2008 at 09:32:56PM +0100, Rafael J. Wysocki wrote:
> The following bug entry is on the current list of known regressions
> from 2.6.27.  Please verify if it still should be listed and let me know
> (either way).
> 
> 
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=12158
> Subject		: commit b1ee26b freezes system on switching from X to text console
> Submitter	: Gaudenz Steinlin <gaudenz@debian.org>
> Date		: 2008-11-25 19:44 (13 days old)
> First-Bad-Commit: http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=b1ee26bab14886350ba12a5c10cbc0696ac679bf
> References	: http://marc.info/?l=linux-kernel&m=122764344231140&w=4
> Handled-By	: Benjamin Herrenschmidt <benh@kernel.crashing.org>

I can confirm, that this regression is worked around by commit 
f3179748a157c21d44d929fd3779421ebfbeaa93 "radeonfb: Disable new color
expand acceleration unless explicitely enabled"

Gaudenz

-- 
Ever tried. Ever failed. No matter.
Try again. Fail again. Fail better.
~ Samuel Beckett ~
