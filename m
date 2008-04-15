Return-Path: <linux-kernel-owner+w=401wt.eu-S1763880AbYDOLvX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763880AbYDOLvX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2008 07:51:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758679AbYDOLvO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Apr 2008 07:51:14 -0400
Received: from e28smtp05.in.ibm.com ([59.145.155.5]:46466 "EHLO
	e28smtp05.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758601AbYDOLvO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2008 07:51:14 -0400
Date: Tue, 15 Apr 2008 17:20:58 +0530
From: "K. Prasad" <prasad@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: tglx@linutronix.de, a.p.zijlstra@chello.nl, mingo@elte.hu,
       mathieu.desnoyers@polymtl.ca
Subject: [RFC PATCH 0/2] Debugging infrastructure for Futexes using Markers
Message-ID: <20080415115058.GA6788@in.ibm.com>
Reply-To: prasad@linux.vnet.ibm.com
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi All,
	The following set of patches a)Implant marker probes in futex.c
and b)define a sample use-case for the markers in futex.

The marker handler patches also make use of the enhancements proposed to
the 'trace' infrastructure i.e. debugfs_printk() interface.
http://lkml.org/lkml/2008/4/15/117

The patches are generated over 2.6.25-rc8-mm1 and have been tested on an
i386 machine.
 
Thanks,
K.Prasad

