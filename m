Return-Path: <linux-kernel-owner+w=401wt.eu-S1760746AbXLTNLR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760746AbXLTNLR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2007 08:11:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756746AbXLTNLF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Dec 2007 08:11:05 -0500
Received: from public.id2-vpn.continvity.gns.novell.com ([195.33.99.129]:43746
	"EHLO public.id2-vpn.continvity.gns.novell.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755726AbXLTNLE convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2007 08:11:04 -0500
Message-Id: <476A780C.76E4.0078.0@novell.com>
X-Mailer: Novell GroupWise Internet Agent 7.0.2 HP
Date: Thu, 20 Dec 2007 13:11:24 +0000
From: "Jan Beulich" <jbeulich@novell.com>
To: <linux-kernel@vger.kernel.org>
Subject: [PATCH 0/4] add task handling notifier
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With more and more sub-systems/sub-components leaving their footprint
in task handling functions, it seems reasonable to add notifiers that
these components can use instead of having them all patch themselves
directly into core files.

Patch 1 introduces the base definitions and hooks for task creation
and deletion.
Patch 2 switches delayacct to make use of the notifier.
Patch 3 makes the procevents/connector use the infrastructure and adds
additional notifiers needed there.
Patch 4 makes the security keys handling use this, too.

Signed-off-by: Jan Beulich <jbeulich@novell.com>


