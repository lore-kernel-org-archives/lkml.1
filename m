Return-Path: <linux-kernel-owner+w=401wt.eu-S932321AbYDVWKr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932321AbYDVWKr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2008 18:10:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757699AbYDVWKk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Apr 2008 18:10:40 -0400
Received: from animx.eu.org ([216.98.75.249]:59678 "EHLO animx.eu.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757573AbYDVWKj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2008 18:10:39 -0400
Date: Tue, 22 Apr 2008 18:10:35 -0400
From: Wakko Warner <wakko@animx.eu.org>
To: linux-kernel@vger.kernel.org
Subject: AIC94xx SAS question.
Message-ID: <20080422221035.GA7976@animx.eu.org>
Mail-Followup-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.6+20040907i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Please keep me in CC.

This is a general question and probably doesn't matter which kernel
(although the one in question is 2.6.23 vanilla)

I know that this device requires firmware to operate which has to be loaded
when the driver is loaded.

I'd like to have this driver compiled into the kernel.  My question is:

Can either of these be done:
1) Embed the firmware into the driver so that it can be used before the
rootfs id mounted.
2) Can the firmware be loaded in an initr{d,amfs}?  I personnaly despise
initr{d,amfs} and if this option is used, I'd prefer it not to be kernel
specific (as in having the driver for the card in the initr{d,amfs}) this
way a kernel upgrade wouldn't change the initr{d,amfs}.  I know there are
tools for this kind of thing, but I find it quite pointless to have the
driver in 2 places (in the init{r,amfs} and in /lib/modules)  I also realize
that "disks are cheap" blah blah, but that's not the point.

I sent this to the linux-scsi list but didn't get too many helpful responces

-- 
 Lab tests show that use of micro$oft causes cancer in lab animals
 Got Gas???
