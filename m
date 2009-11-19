Return-Path: <linux-kernel-owner+w=401wt.eu-S1753529AbZKSRcC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753529AbZKSRcC (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Nov 2009 12:32:02 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753297AbZKSRcB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Nov 2009 12:32:01 -0500
Received: from relay1.sgi.com ([192.48.179.29]:53339 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753212AbZKSRcA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Nov 2009 12:32:00 -0500
From: Robin Holt <holt@sgi.com>
Message-Id: <20091119173157.337874000@alcatraz.americas.sgi.com>
User-Agent: quilt/0.47-1
Date: Thu, 19 Nov 2009 11:31:57 -0600
To: Ingo Molnar <mingo@elte.hu>, tglx@linutronix.de
Cc: Robin Holt <holt@sgi.com>, Jack Steiner <steiner@sgi.com>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: [patch 0/8] x86: UV - XPC fixes with related support functionality V2.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


The UV BIOS has been updated to implement some of our interface
functionality differently than originally expected.  These patches
update us to that working bios and include a few minor bug fixes
which prevent us from doing significant testing on real hardware.

Changes from V1:

- Actually include the patch introducing the gru_read_gpa.  This
  was missed in the V1 submission.

- One additional BIOS change has the OS no longer passing blade
  to the BIOS when registering a message queue watchlist.
