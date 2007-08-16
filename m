Return-Path: <linux-kernel-owner+w=401wt.eu-S1761225AbXHPNTY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761225AbXHPNTY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Aug 2007 09:19:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755058AbXHPNTO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Aug 2007 09:19:14 -0400
Received: from hellhawk.shadowen.org ([80.68.90.175]:1264 "EHLO
	hellhawk.shadowen.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753767AbXHPNTN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Aug 2007 09:19:13 -0400
From: Andy Whitcroft <apw@shadowen.org>
To: linux-kernel@vger.kernel.org
Cc: Randy Dunlap <rdunlap@xenotime.net>, Andrew Morton <akpm@osdl.org>,
       Andy Whitcroft <apw@shadowen.org>
Subject: [PATCH 0/6] checkpatch checks for trailing semicolons on conditionals
Message-ID: <exportbomb.1187270320@pinky>
Date: Thu, 16 Aug 2007 14:18:40 +0100
X-SPF-Guess: neutral
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

A couple of people suggested adding checks to checkpatch for trailing
semicolons on conditionals, where the conditional block may not be
actually conditional:

	if (err);
		return err;

While regression testing the changes, I ran these checks across the
whole of 2.6.23-rc3 and there appear to be 5 places where this is
occurs (above and beyond the IPv6 one which triggered this effort)
and a benign use which could be confused later which it seems safest
to fix.

Following this email are 6 patches for these issues, relevant
maintainers cc'd.  All against 2.6.23-rc3

-apw
