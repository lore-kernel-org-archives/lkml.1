Return-Path: <linux-kernel-owner+w=401wt.eu-S932565AbYCGDmR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932565AbYCGDmR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2008 22:42:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757079AbYCGDmB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Mar 2008 22:42:01 -0500
Received: from gherkin.frus.com ([192.158.254.49]:37441 "EHLO gherkin.frus.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756865AbYCGDmA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2008 22:42:00 -0500
Subject: [regression]2.6.25-rc4: boot panic on alpha
To: linux-kernel@vger.kernel.org
Date: Thu, 6 Mar 2008 21:41:55 -0600 (CST)
CC: linux-alpha@vger.kernel.org
X-Mailer: ELM [version 2.4ME+ PL82 (25)]
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=US-ASCII
Message-Id: <20080307034155.A8C6EDBA2@gherkin.frus.com>
From: rct@frus.com (Bob Tracy)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The regression is relative to 2.6.25-rc1 + timer fixes (added when
I reported the problems with 2.6.25-rc1 relative to 2.6.24).  I haven't
tried -rc2 or -rc3.

Might be related to similar reports I've seen, but wanted to add the
Alpha platform to the list.  The -rc4 kernel boots, but at some point
following initialization of the SCSI layer, there's a panic with enough
diagnostic output that a 50-line screen can't hold it all.  Unfortunately,
the system logging isn't active, so nothing gets captured.

The panic is completely reproducible.  The "Code" line at the bottom
of the panic output is

44220001 4821f621 4821b681 4821f62b f420004f 00000081 <0000009b> 0066c012

The first line of the "Trace" section is

 [<fffffc000031a41f>] iommu_arena_alloc+0x64/0xe0

Platform is an Alpha PWS 433au.  gcc is version 4.1.2 (Debian 4.1.1-21).

-- 
------------------------------------------------------------------------
Bob Tracy          |  "I was a beta tester for dirt.  They never did
rct@frus.com       |   get all the bugs out." - Steve McGrew on /.
------------------------------------------------------------------------
