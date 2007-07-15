Return-Path: <linux-kernel-owner+w=401wt.eu-S1754639AbXGOEyR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754639AbXGOEyR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Jul 2007 00:54:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751617AbXGOEyG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Jul 2007 00:54:06 -0400
Received: from e34.co.us.ibm.com ([32.97.110.152]:40775 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751109AbXGOEyD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Jul 2007 00:54:03 -0400
Date: Sat, 14 Jul 2007 21:54:00 -0700
From: sukadev@us.ibm.com
To: Andrew Morton <akpm@osdl.org>, linux-kernel@vger.kernel.org
Cc: Pavel Emelianov <xemul@openvz.org>, serue@us.ibm.com, clg@fr.ibm.com,
       haveblue@us.ibm.com, Containers <containers@lists.osdl.org>
Subject: [PATCH 0/5] Misc helper patches for pid namespaces
Message-ID: <20070715045400.GA25053@us.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.2i
X-Operating-System: Linux 2.0.32 on an i486
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Some helper patches to support multiple pid namespaces. These
were discussed earlier on Containers@ mailing list. 

	[PATCH 1/5] Define and use task_active_pid_ns() wrapper
	[PATCH 2/5] Rename child_reaper() function.
	[PATCH 3/5] Use task_pid() to find leader's pid
	[PATCH 4/5] Define is_global_init() and is_container_init().
	[PATCH 5/5] Move alloc_pid() to copy_process()
