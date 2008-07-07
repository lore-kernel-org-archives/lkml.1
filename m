Return-Path: <linux-kernel-owner+w=401wt.eu-S1755194AbYGGSxb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755194AbYGGSxb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2008 14:53:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755035AbYGGSxX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Jul 2008 14:53:23 -0400
Received: from relay1.sgi.com ([192.48.171.29]:42899 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754102AbYGGSxX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2008 14:53:23 -0400
Date: Mon, 7 Jul 2008 13:53:22 -0500
From: Dean Nelson <dcn@sgi.com>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org
Subject: [Patch 0/6] sgi-xp: add support for UV systems
Message-ID: <20080707185322.GA657@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patchset adds most of the necessary code to support XPC/XPNET on a SGI UV
system, and as such is still under development. It compiles cleanly as is on
both x86_64 and IA64. And if brought up on anything but ia64-sn2 will return
an -ENODEV.

This patchset depends on the GRU driver which has recently been submitted.
http://marc.info/?l=linux-kernel&m=121512107123657&w=2

