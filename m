Return-Path: <linux-kernel-owner+w=401wt.eu-S2993251AbXDSMDG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2993251AbXDSMDG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Apr 2007 08:03:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2993252AbXDSMDG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Apr 2007 08:03:06 -0400
Received: from e2.ny.us.ibm.com ([32.97.182.142]:50367 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S2993251AbXDSMDF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Apr 2007 08:03:05 -0400
Date: Thu, 19 Apr 2007 17:31:31 +0530
From: Gautham R Shenoy <ego@in.ibm.com>
To: Oleg Nesterov <oleg@tv-sign.ru>, "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org, mingo@elte.hu,
       vatsa@in.ibm.com, paulmck@us.ibm.com, pavel@ucw.cz
Subject: [RFC 0/2] Fix Freezer related races.
Message-ID: <20070419120131.GB13435@in.ibm.com>
Reply-To: ego@in.ibm.com
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.12-2006-07-14
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Everyone, 
Oleg had pointed out some subtle races which could lead to the failure
of the process freezer in the patchset which I had posted earlier.

A couple of these problems seem to be present in the latest -mm(2.6.21-rc6-mm1).

This is an attempt to fix them.

Awaiting you feedback, 
Regards
gautham.
-- 
Gautham R Shenoy
Linux Technology Center
IBM India.
"Freedom comes with a price tag of responsibility, which is still a bargain,
because Freedom is priceless!"
