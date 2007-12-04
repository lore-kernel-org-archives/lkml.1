Return-Path: <linux-kernel-owner+w=401wt.eu-S1752891AbXLDRJZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752891AbXLDRJZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Dec 2007 12:09:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751055AbXLDRJR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Dec 2007 12:09:17 -0500
Received: from palinux.external.hp.com ([192.25.206.14]:58960 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750831AbXLDRJR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Dec 2007 12:09:17 -0500
Date: Tue, 4 Dec 2007 10:09:16 -0700
From: Matthew Wilcox <matthew@wil.cx>
To: linux-kernel@vger.kernel.org
Subject: dmapool patch series, version 2
Message-ID: <20071204170915.GE9405@parisc-linux.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


I posted the original patch series back here:
http://marc.info/?l=linux-kernel&m=119083320718236&w=2

- I now have performance measurements.  It gains us about 0.4% on 'a
  well-known OLTP benchmark'.
- I've addressed Dave/Roland's concerns about patch 3/4 being too big;
  it's now patches 5/7 and 6/7 of this series.
- I've run checkpatch.pl over the file, and fixed all the warnings/errors
  it reported.
- And I've updated it to 2.6.24-rc4.

Patches also available from:
http://git.kernel.org/?p=linux/kernel/git/willy/misc.git;a=shortlog;h=dmapool

I'll send all seven as a followup to this mail.

-- 
Intel are signing my paycheques ... these opinions are still mine
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
