Return-Path: <linux-kernel-owner+w=401wt.eu-S1752654AbYANSlo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752654AbYANSlo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jan 2008 13:41:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751082AbYANSlg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Jan 2008 13:41:36 -0500
Received: from ms-smtp-03.nyroc.rr.com ([24.24.2.57]:55487 "EHLO
	ms-smtp-03.nyroc.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751008AbYANSlf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jan 2008 13:41:35 -0500
Subject: 2.6.24-rc7-rt2
From: Steven Rostedt <rostedt@goodmis.org>
To: LKML <linux-kernel@vger.kernel.org>, RT <linux-rt-users@vger.kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>
Content-Type: text/plain
Date: Mon, 14 Jan 2008 13:41:20 -0500
Message-Id: <1200336080.318.8.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We are pleased to announce the 2.6.24-rc7-rt2 tree, which can be
downloaded from the location:

  http://rt.et.redhat.com/download/

Information on the RT patch can be found at:

  http://rt.wiki.kernel.org/index.php/Main_Page

Changes since 2.6.24-rc7-rt1

  - Several merge fixes reported by:
	Mariusz Kozloski

  - Removal of kvm-rt.patch (it's so old it is now bogus)

  - PPC compile fix (reported by: Robert Schwebel)

  - Remove of running softirq by hardirq (too dangerous)

  - Changed BUG_ON in filemap from atomic to pagefault disabled
       (Steven Rostedt)

Note: There are still some fixes that are not incorporated here yet.


to build a 2.6.24-rc7-rt2 tree, the following patches should be applied:

  http://www.kernel.org/pub/linux/kernel/v2.6/linux-2.6.23.tar.bz2
  http://www.kernel.org/pub/linux/kernel/v2.6/testing/patch-2.6.24-rc7.bz2
  http://rt.et.redhat.com/download/patch-2.6.24-rc7-rt2.bz2


And like always, my RT version of Matt Mackall's ketchup will get this
for you nicely:

  http://people.redhat.com/srostedt/rt/tools/ketchup-0.9.8-rt3


The broken out patches are also available.

-- Steve



