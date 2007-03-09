Return-Path: <linux-kernel-owner+w=401wt.eu-S1767358AbXCIQS4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767358AbXCIQS4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2007 11:18:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1767360AbXCIQS4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Mar 2007 11:18:56 -0500
Received: from mx1.redhat.com ([66.187.233.31]:34658 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1767358AbXCIQSz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2007 11:18:55 -0500
Message-ID: <45F188ED.7030202@redhat.com>
Date: Fri, 09 Mar 2007 11:18:53 -0500
From: Chuck Ebbert <cebbert@redhat.com>
Organization: Red Hat
User-Agent: Thunderbird 1.5.0.9 (X11/20070212)
MIME-Version: 1.0
To: "Eric W. Biederman" <ebiederm@xmission.com>
CC: linux-kernel <linux-kernel@vger.kernel.org>
Subject: "No handler for vector" patches don't work on some systems
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

[sorry for the dup: this time to the right recipient]

So far I've tried the simple "survive having no handler
for a vector" patch and the preliminary 3-patch series
that was in -mm for a while, and neither work on the
Dell PowerEdge 29xx and 19xx systems. These servers
have the Intel 5000X chipset with the 6700PXH PCI Hub
with dual independent PCI-X busses, each with its own
I/OxAPIC with 24 interrupts. The fixes do work on
"simple" systems but not on these high-end ones.
