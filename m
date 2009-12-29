Return-Path: <linux-kernel-owner+w=401wt.eu-S1751704AbZL2Nqo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751704AbZL2Nqo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Dec 2009 08:46:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751612AbZL2Nqn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Dec 2009 08:46:43 -0500
Received: from rhlx01.hs-esslingen.de ([129.143.116.10]:59163 "EHLO
	rhlx01.hs-esslingen.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751113AbZL2Nqn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Dec 2009 08:46:43 -0500
Date: Tue, 29 Dec 2009 14:46:41 +0100
From: Andreas Mohr <andi@lisas.de>
To: Martin Knoblauch <spamtrap@knobisoft.de>
Cc: linux-kernel@vger.kernel.org, Andreas Mohr <andi@lisas.de>
Subject: Re: 2.6.33-next build errors (x86_64 defconfig) on RHEL-4.3
Message-ID: <20091229134641.GA10515@rhlx01.hs-esslingen.de>
References: <55527.63156.qm@web113308.mail.gq1.yahoo.com> <696574.90670.qm@web113305.mail.gq1.yahoo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <696574.90670.qm@web113305.mail.gq1.yahoo.com>
X-Priority: none
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Tue, Dec 29, 2009 at 01:50:12AM -0800, Martin Knoblauch wrote:
>  Not surprisingly, the problem still exists in next-20091229 :-) But actually, I think it might be even as old as 2.6.31-rc3. See
> 
> http://lkml.org/lkml/2009/7/14/120
> 
> for reference. Different (still older toolchain), but very similar failure.
> 
> @Andreas: did you ever had this resolved? I never saw a followup

Sorry, I don't remember that any more (perhaps removing some CONFIG
fixed it), especially since this problem was then overlayed by
a __udivdi3 problem in the same low-versioned environment:
http://lkml.org/lkml/2009/10/9/230

I thus decommissioned that RHEL3 installation and downgraded to RHEL5
(it managed to do away with any custom kernel builds entirely, among
other things - an interesting approach to fix the problem)

Andreas Mohr
