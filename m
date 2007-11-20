Return-Path: <linux-kernel-owner+w=401wt.eu-S1756199AbXKTJvT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756199AbXKTJvT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2007 04:51:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752443AbXKTJvK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Nov 2007 04:51:10 -0500
Received: from mx2.suse.de ([195.135.220.15]:46949 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752358AbXKTJvJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2007 04:51:09 -0500
Subject: [PATCH 0/3] PNP cleanups
From: Thomas Renninger <trenn@suse.de>
Reply-To: trenn@suse.de
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: akpm <akpm@linux-foundation.org>, Bjorn Helgaas <bjorn.helgaas@hp.com>,
       "Li, Shaohua" <shaohua.li@intel.com>,
       Rene Herman <rene.herman@keyaccess.nl>,
       "yakui.zhao" <yakui.zhao@intel.com>
Content-Type: text/plain
Organization: Novell/SUSE
Date: Tue, 20 Nov 2007 10:51:06 +0100
Message-Id: <1195552267.23700.163.camel@queen.suse.de>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I wonder whether these rather large cleanups can already be added to
some mainline branch.

There should be no functional change.

This could make life easier for me (not that bad, there were not that
much changes in the past), but mainly make it easier for others to test
the real patch, that should reduce memory waste in pnp layer and I
expect some testing (especially on older isa machines) will be
necessary...

The intend is to unify the pnp_{port,mem,dma,irq}_... macros exposed in
include/linux/pnp.h and make use of them more consequently.

The patches apply on 2.6.24-rc2-mm1

Thanks,

   Thomas

