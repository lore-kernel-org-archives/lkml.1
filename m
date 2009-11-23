Return-Path: <linux-kernel-owner+w=401wt.eu-S1756845AbZKWLBO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756845AbZKWLBO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Nov 2009 06:01:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756891AbZKWLBL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Nov 2009 06:01:11 -0500
Received: from znsun1.ifh.de ([141.34.1.16]:61650 "EHLO znsun1.ifh.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756489AbZKWLBB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Nov 2009 06:01:01 -0500
Date: Mon, 23 Nov 2009 12:01:00 +0100 (CET)
From: Patrick Boettcher <pboettcher@kernellabs.com>
X-X-Sender: pboettch@pub1.ifh.de
To: linux-kernel@vger.kernel.org
cc: Martin Habets <errandir_news@mph.eclipse.co.uk>
Subject: PATCH [0/2] - CHECKSTACK: sparc-stack-size and formatting
Message-ID: <alpine.LRH.2.00.0911231148441.14263@pub1.ifh.de>
User-Agent: Alpine 2.00 (LRH 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=US-ASCII
X-Spam-Report: ALL_TRUSTED,AWL,BAYES_00
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I shamelessly stole the checkstack-script for a project of mine and now 
want to contribute what I changed:

1) CHECKSTACK: sparc: fix regex to match all stacksizes
2) CHECKSTACK: simplify text-formatting for displaying the stacksize

For 1): as there are no comments in the script as to why the regex was 
limiting the detection of stacksizes to less 300 bytes and if I understood 
it correctly, to a maximum of 1000, I simply removed it.

best regards,
--

Patrick Boettcher - Kernel Labs
http://www.kernellabs.com/
