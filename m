Return-Path: <linux-kernel-owner+w=401wt.eu-S933583AbYDVXuL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933583AbYDVXuL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2008 19:50:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752896AbYDVXt6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Apr 2008 19:49:58 -0400
Received: from swan.nt.tuwien.ac.at ([128.131.67.158]:58741 "EHLO
	swan.nt.tuwien.ac.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751162AbYDVXt5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2008 19:49:57 -0400
X-Greylist: delayed 428 seconds by postgrey-1.27 at vger.kernel.org; Tue, 22 Apr 2008 19:49:57 EDT
Date: Wed, 23 Apr 2008 01:42:47 +0200
From: Thomas Zeitlhofer <tzeitlho+lkml@nt.tuwien.ac.at>
To: linux-kernel@vger.kernel.org
Subject: 2.6.25: racoon does not work without ipv6 any more
Message-ID: <20080422234246.GA17735@swan.nt.tuwien.ac.at>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

commit df9dcb4588aca9cc243cf1f3f454361a84e1cbdb breaks racoon if the
kernel is compiled _without_ ipv6 support. 

In this case, racoon fails in phase 2 with:

	racoon: ERROR: pfkey UPDATE failed: Protocol not supported
	racoon: ERROR: pfkey ADD failed: Protocol not supported

Up to 2.6.24, racoon worked fine without ipv6 support in the kernel and
reverting the commit above restores the old behavior.

Regards,

Thomas
