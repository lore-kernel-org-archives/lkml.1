Return-Path: <linux-kernel-owner+w=401wt.eu-S1754897AbYLVS30@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754897AbYLVS30 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Dec 2008 13:29:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752030AbYLVS2w
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Dec 2008 13:28:52 -0500
Received: from gw.goop.org ([64.81.55.164]:44695 "EHLO abulafia.goop.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751840AbYLVS2v (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Dec 2008 13:28:51 -0500
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: [PATCH 0 of 9] swiotlb: use phys_addr_t for pages
Message-Id: <patchbomb.1229970362@abulafia.goop.org>
Date: Mon, 22 Dec 2008 10:26:02 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Xen-devel <xen-devel@lists.xensource.com>,
       the arch/x86 maintainers <x86@kernel.org>,
       Ian Campbell <ian.campbell@citrix.com>,
       Becky Bruce <beckyb@kernel.crashing.org>,
       FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

Here's a work in progress series whcih does a partial revert of the
previous swiotlb changes, and does a partial replacement with Becky
Bruce's series.

The most important difference is Becky's use of phys_addr_t rather
than page+offset to represent arbitrary pages.  This turns out to be
simpler.

I didn't replicate the map_single_page changes, since I'm not exactly
sure of ppc's requirements here, and it seemed like something that
could be easily added.

Quick testing showed no problems, but I haven't had the chance to do
anything extensive.

I've made some small changes to Becky's patches to make them apply,
but I've separated any functional changes into separate patches with
appropriate authorship.

	 J

