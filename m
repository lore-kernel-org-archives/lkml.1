Return-Path: <linux-kernel-owner+w=401wt.eu-S1765426AbXLOPt7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765426AbXLOPt7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Dec 2007 10:49:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758759AbXLOPtt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 15 Dec 2007 10:49:49 -0500
Received: from einhorn.in-berlin.de ([192.109.42.8]:57973 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758630AbXLOPtt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Dec 2007 10:49:49 -0500
X-Envelope-From: stefanr@s5r6.in-berlin.de
Message-ID: <4763F771.10105@s5r6.in-berlin.de>
Date: Sat, 15 Dec 2007 16:49:05 +0100
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.9) Gecko/20071122 SeaMonkey/1.1.6
MIME-Version: 1.0
To: Arjan van de Ven <arjan@linux.intel.com>
CC: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation>, protasnb@gmail.com
Subject: Re: Top kernel oopses/warnings this week
References: <4762CF8C.90808@linux.intel.com>
In-Reply-To: <4762CF8C.90808@linux.intel.com>
X-Enigmail-Version: 0.95.3
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arjan van de Ven wrote:
> The http://www.kerneloops.org website collects kernel oops and warning
> reports from various mailing lists and bugzillas;

A few comments:

Report counts may be too high due to duplicate recognition of the very
same report.¹

Reports against 2.6.X-rcY-mmZ are listed in the same category as reports
against 2.6.X-rcY.  To distinguish -mm reports from vanilla reports, one
has to look into the details of each bug entry.¹

A general weakness is that it is ultimately impossible to know whether a
report was against an unpatched kernel, unless one drills down to the
individual mailinglist threads.

Reports about tainted kernels have arguably less value.  It would be
good to hide such reports until a report of the same oops in an
untainted kernel was found.

¹) example: http://www.kerneloops.org/oops.php?number=2335
-- 
Stefan Richter
-=====-=-=== ==-- -====
http://arcgraph.de/sr/
