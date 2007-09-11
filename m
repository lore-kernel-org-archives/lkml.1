Return-Path: <linux-kernel-owner+w=401wt.eu-S1763303AbXIKLSQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763303AbXIKLSQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Sep 2007 07:18:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755596AbXIKLSE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Sep 2007 07:18:04 -0400
Received: from e32.co.us.ibm.com ([32.97.110.150]:43106 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751814AbXIKLSC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Sep 2007 07:18:02 -0400
Subject: [LTP] Better ways to generate Stress at Background
From: Subrata Modak <subrata@linux.vnet.ibm.com>
Reply-To: subrata@linux.vnet.ibm.com
To: ltp-list <ltp-list@lists.sourceforge.net>, linux-kernel@vger.kernel.org
Content-Type: text/plain
Organization: IBM
Date: Tue, 11 Sep 2007 16:47:54 +0530
Message-Id: <1189509474.4568.46.camel@subratamodak.linux.ibm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.0 (2.8.0-33.el5) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

LTP has a fair program
(http://ltp.cvs.sourceforge.net/ltp/ltp/tools/genload/stress.c?revision=1.3&view=markup) which is capable of generating:
1) CPU stress,
2) Memory Stress,
3) Hard Disk Stress,
4) IO Bus Stress,
5) Network Stress (through netpipe)

in the Background, before your testcases (LTP) are run. The stress they
generate are wholesome and cannot be discrete. We need to device a
mechanism, where we can generate stress in matters of percentage (%),
say:
1) X% of CPU should be stressed during run,
2) Y% of Memory Stress,
3) Z% of Hard Disk Stress,
4) P% of IO Bus Stress,
5) Q% Network Stress (through netpipe)

And, all these should hold good on both Single CPU vs SMP machines as
well as to NUMA architecture. Can somebody provide some Idea on how to
design such a system ?
We may also face a situation like:
1) On an SMP machine with 8 CPUs, only 2 should be subjected to 60%
stress and others left normal, and lots of other combinations as well
2) On a NUMA machine, only particular node(s) should be stressed and
other left normal.

--Regards--
Subrata--

