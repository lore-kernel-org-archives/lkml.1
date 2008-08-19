Return-Path: <linux-kernel-owner+w=401wt.eu-S1755488AbYHSP5d@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755488AbYHSP5d (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2008 11:57:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753199AbYHSP5Z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Aug 2008 11:57:25 -0400
Received: from one.firstfloor.org ([213.235.205.2]:34481 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751898AbYHSP5Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2008 11:57:25 -0400
Date: Tue, 19 Aug 2008 17:57:22 +0200
From: Andi Kleen <andi@firstfloor.org>
To: roland@redhat.com, oleg@tv-sign.ru, akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, rjw@sisk.pl
Subject: tracehook breaks dhcpcd child processing
Message-ID: <20080819155722.GA25695@basil.nowhere.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


[Rafael, one entry for the regression list]

Roland,

The opensuse 11.0 dhcpcd keeps accumulating zombies of its child scripts
with 2.6.27-rc*. 2.6.26 didn't have this problem. After one night I had more 
zombies than normal processes.

I bisected it down to

commit 2b2a1ff64afbadac842bbc58c5166962cf4f7664
Author: Roland McGrath <roland@redhat.com>
Date:   Fri Jul 25 19:45:54 2008 -0700

    tracehook: death

causing the problem. Please fix.

-Andi
