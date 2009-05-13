Return-Path: <linux-kernel-owner+w=401wt.eu-S1759601AbZEMQMf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759601AbZEMQMf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 May 2009 12:12:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760213AbZEMQMK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 May 2009 12:12:10 -0400
Received: from e23smtp08.au.ibm.com ([202.81.31.141]:60156 "EHLO
	e23smtp08.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760238AbZEMQMJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 May 2009 12:12:09 -0400
Date: Wed, 13 May 2009 21:42:01 +0530
From: "K.Prasad" <prasad@linux.vnet.ibm.com>
To: Alan Stern <stern@rowland.harvard.edu>,
       Frederic Weisbecker <fweisbec@gmail.com>
Cc: Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Benjamin Herrenschmidt <benh@au1.ibm.com>, maneesh@linux.vnet.ibm.com,
       Roland McGrath <roland@redhat.com>,
       Masami Hiramatsu <mhiramat@redhat.com>
Subject: [Patch 00/12] Hardware Breakpoint interfaces
Message-ID: <20090513161201.GA13911@in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Alan,
	Please find a new set of patches with the following changes.
I am eager to know if you think that they are ready for submission towards
upstream acceptance.

Hi Frederic,
	Please find the changes in ftrace plugin code that moves the 
startup selftest code completely into trace_selftest_startup_ksym() as
per your suggestion.

Changelog
---------

- A new interface modify_user_hw_breakpoint() to change the characteristics
  (such as type/length) of a pre-registered user-space breakpoint is introduced.

- The startup selftest portion of code from ksym_trace_init() is moved
  completely to trace_selftest_startup_ksym(). process_new_ksym_entry() is
  required during the selftest and is no longer marked static.

- HB_NUM is renamed to HBP_NUM (given that the short naming convention for
  hw_breakpoint is hbp).

Thanks,
K.Prasad

