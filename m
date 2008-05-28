Return-Path: <linux-kernel-owner+w=401wt.eu-S1754878AbYE1NC3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754878AbYE1NC3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2008 09:02:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752049AbYE1NCV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 May 2008 09:02:21 -0400
Received: from burp.tkv.asdf.org ([212.16.99.49]:46636 "EHLO burp.tkv.asdf.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752801AbYE1NCU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2008 09:02:20 -0400
Date: Wed, 28 May 2008 16:02:16 +0300
From: Markku Savela <msa@moth.iki.fi>
Message-Id: <200805281302.m4SD2GGw012289@burp.tkv.asdf.org>
To: linux-kernel@vger.kernel.org
Subject: in_group_p test for another process?
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


If I have a PID and some GID at hand, how do I find whether the OHTER
process identified by PID has the GID in its supplementary set of
groups?

I can find the "in_group_p" test, but that does it only for current process.

Do I have to write my own function that uses the "tasklist_lock",
finds task by "find_task_by_pid", and then calls
"groups_search(task->group_info, gid)"?

Can I do this in a module, or do I have to patch the "kernel/sys.c"
myself for a privately modified version of the kernel?

