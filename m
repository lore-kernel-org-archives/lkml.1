Return-Path: <linux-kernel-owner+w=401wt.eu-S1759974AbYAaAsX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759974AbYAaAsX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2008 19:48:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752710AbYAaAsP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jan 2008 19:48:15 -0500
Received: from mx1.redhat.com ([66.187.233.31]:59329 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751100AbYAaAsO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2008 19:48:14 -0500
Message-ID: <47A11ACD.1090400@redhat.com>
Date: Wed, 30 Jan 2008 19:48:13 -0500
From: Chris Snook <csnook@redhat.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: Purpose of numa_node?
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

While pondering ways to optimize I/O and swapping on large NUMA machines, I 
noticed that the numa_node field in struct device isn't actually used anywhere. 
  We just have a couple dozen lines of code to conditionally create a sysfs file 
that will always return -1.  Is anyone even working on code to actually use this 
field?  I think it's a good piece of information to keep track of, so I'm not 
suggesting we remove it, but I want to make sure I'm not stepping on toes or 
duplicating effort if I try to make it useful.

	-- Chris
