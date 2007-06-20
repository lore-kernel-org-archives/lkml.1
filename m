Return-Path: <linux-kernel-owner+w=401wt.eu-S1756843AbXFTKtD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756843AbXFTKtD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2007 06:49:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750957AbXFTKsw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Jun 2007 06:48:52 -0400
Received: from mail.gmx.net ([213.165.64.20]:49237 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1750887AbXFTKsv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2007 06:48:51 -0400
X-Authenticated: #5039886
X-Provags-ID: V01U2FsdGVkX1/UKdJUmarUURDSF6Ssh9PVsLsH1iTk3V0Yrh1lmD
	4JDh5EBN0obSKB
Date: Wed, 20 Jun 2007 12:49:07 +0200
From: =?iso-8859-1?Q?Bj=F6rn?= Steinbrink <B.Steinbrink@gmx.de>
To: Stephane Eranian <eranian@hpl.hp.com>, oprofile-list@lists.sourceforge.net,
       wcohen@redhat.com, ak@suse.de, perfmon@napali.hpl.hp.com,
       linux-kernel@vger.kernel.org, levon@movementarian.org,
       akpm@linux-foundation.org, mingo@elte.hu
Subject: [PATCH 0/2] Performance counter allocator separation
Message-ID: <20070620104906.GA25242@atjola.homenet>
Mail-Followup-To: =?iso-8859-1?Q?Bj=F6rn?= Steinbrink <B.Steinbrink@gmx.de>,
	Stephane Eranian <eranian@hpl.hp.com>,
	oprofile-list@lists.sourceforge.net, wcohen@redhat.com, ak@suse.de,
	perfmon@napali.hpl.hp.com, linux-kernel@vger.kernel.org,
	levon@movementarian.org, akpm@linux-foundation.org, mingo@elte.hu
References: <20070612150246.GJ32163@frankl.hpl.hp.com> <20070612190730.GA6978@atjola.homenet> <20070613014136.GA2386@atjola.homenet> <20070613164632.GA8674@atjola.homenet> <20070618095238.GC20759@frankl.hpl.hp.com> <20070618103214.GA12045@atjola.homenet>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20070618103214.GA12045@atjola.homenet>
User-Agent: Mutt/1.5.13 (2006-08-11)
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

[Sorry if anyone gets this mail twice, seems that git-send-email
"forgot" to mask the umlaut in my name for this message, causing a few
servers to reject it.]

These two patches fix the performance counter allocator to work even
when the LAPIC NMI watchdog is disabled. It's split up into two patches
to keep the size of the pure regression fix down and allow the cleanup
to be merged once 2.6.22 is out.

If you prefer an all-in-one patch nevertheless, please let me know.

Thanks,
Björn
