Return-Path: <linux-kernel-owner+w=401wt.eu-S1758339AbZFPPmF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758339AbZFPPmF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jun 2009 11:42:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754570AbZFPPlz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Jun 2009 11:41:55 -0400
Received: from imta-38.everyone.net ([216.200.145.38]:44725 "EHLO
	omta0106.mta.everyone.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754500AbZFPPly (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jun 2009 11:41:54 -0400
X-Greylist: delayed 1970 seconds by postgrey-1.27 at vger.kernel.org; Tue, 16 Jun 2009 11:41:54 EDT
X-Eon-Dm: dm24
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Message-Id: <20090616080904.CCA17C3A@resin11.mta.everyone.net>
Date: Tue, 16 Jun 2009 08:09:04 -0700
From: "Brad Allen" <braddo@tranceaddict.net>
Reply-To: <braddo@tranceaddict.net>
To: <linux-kernel@vger.kernel.org>
Subject: PAT support (or lack of) for Pentium 3 CPU's
X-Eon-Sig: AQLBoNFKN7WQe6VzuQEAAAAB,a5aa390501a373714302ceb4679f78e5
X-Originating-Ip: [114.75.39.251]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It has come to my attention that PAT support has been disabled for P3 CPU's in kernel versions 2.6.30 and later due to a bug in the CPU. 

I have attempted to get the NVIDIA proprietary drivers working with these kernel versions and 3 different Pentium 3 motherboards, all have failed. The drivers seem to require PAT support in order to work correctly, each board has in fact produced a different error when using only MTRR.

Can a kernel option be added to enable/disable PAT for P3 CPU's? Or is there any possible workaround for the bug?

I'd be interested to hear from Radeon users running a 2.6.30 or later kernel.

For anyone wondering why I still use such an old machine, I require ISA support.

Cheers,

Brad Allen
