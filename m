Return-Path: <linux-kernel-owner+w=401wt.eu-S1754121AbYKXXUt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754121AbYKXXUt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2008 18:20:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752340AbYKXXUl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Nov 2008 18:20:41 -0500
Received: from e2.ny.us.ibm.com ([32.97.182.142]:49471 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751911AbYKXXUk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2008 18:20:40 -0500
Subject: [Patch 0/3] OProfile SPU event profiling support for IBM Cell
	processor
From: Carl Love <cel@us.ibm.com>
To: Arnd Bergmann <arnd@arndb.de>, linux-kernel <linux-kernel@vger.kernel.org>,
       linuxppc-dev@ozlabs.org, oprofile-list@lists.sourceforge.net,
       cel <cel@linux.vnet.ibm.com>, cbe-oss-dev <cbe-oss-dev@ozlabs.org>
Content-Type: text/plain
Date: Mon, 24 Nov 2008 15:19:41 -0800
Message-Id: <1227568781.6509.198.camel@carll-linux-desktop>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This patch set consists of two kernel patches and one user level patch
to add SPU event based profiling support to OProfile for the IBM Cell
processor.  The first patch in the series is the user level patch that
adds the needed events and event checking to the user tool.  The second
patch is the first of two kernel patches.  It makes some structural
changes to the kernel code to make it easier to add the specific
functions for doing SPU event profiling.  The first kernel patch does
not make any functional changes.  The third patch in the series is the
second kernel patch where the actual SPU event profiling code support is
added to the kernel.

          Carl Love

