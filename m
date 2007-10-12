Return-Path: <linux-kernel-owner+w=401wt.eu-S1759638AbXJLUcB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759638AbXJLUcB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Oct 2007 16:32:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754378AbXJLUbx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Oct 2007 16:31:53 -0400
Received: from hpsmtp-eml19.kpnxchange.com ([213.75.38.84]:49482 "EHLO
	hpsmtp-eml19.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755310AbXJLUbx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Oct 2007 16:31:53 -0400
From: Frans Pop <elendil@planet.nl>
To: stable@kernel.org
Subject: 2.6.23 regression: top displaying 9999% CPU usage
Date: Fri, 12 Oct 2007 22:31:50 +0200
User-Agent: KMail/1.9.7
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200710122231.50739.elendil@planet.nl>
X-OriginalArrivalTime: 12 Oct 2007 20:31:51.0070 (UTC) FILETIME=[EB6F43E0:01C80D0E]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Please consider this patch for 2.6.23.2
http://lkml.org/lkml/2007/10/4/389

tested by me in
http://lkml.org/lkml/2007/10/5/150

to fix the regression first reported in
http://lkml.org/lkml/2007/10/3/123

Cause of the wrong display in top is the value of stime in /proc/<pid>/stat 
decreasing occasionally.

The issue is also registered as:
http://bugzilla.kernel.org/show_bug.cgi?id=9135

Thanks,
Frans Pop
