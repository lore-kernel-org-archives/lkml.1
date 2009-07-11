Return-Path: <linux-kernel-owner+w=401wt.eu-S1758335AbZGKCNa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758335AbZGKCNa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jul 2009 22:13:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751125AbZGKCNV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Jul 2009 22:13:21 -0400
Received: from elasmtp-masked.atl.sa.earthlink.net ([209.86.89.68]:47147 "EHLO
	elasmtp-masked.atl.sa.earthlink.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751123AbZGKCNV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jul 2009 22:13:21 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=dk20050327; d=earthlink.net;
  b=pB/nSAfYuiUDxja2EsmCvdsdft+5bVNhgdWkT8G/wtMtm+XQdmpXfIviKQW+hoMK;
  h=Received:Message-Id:From:To:Content-Type:Content-Transfer-Encoding:Mime-Version:Subject:Date:X-Mailer:X-ELNK-Trace:X-Originating-IP;
Message-Id: <1C11DCE4-A4EF-42AC-BFB7-5B06190482C4@earthlink.net>
From: Mitchell Erblich <erblichs@earthlink.net>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=US-ASCII; format=flowed; delsp=yes
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0 (Apple Message framework v930.3)
Subject: Suggested code code : simple : keep simple out-of-memory (oom) msg without rate_limits
Date: Fri, 10 Jul 2009 19:13:18 -0700
X-Mailer: Apple Mail (2.930.3)
X-ELNK-Trace: 074f60c55517ea841aa676d7e74259b7b3291a7d08dfec79bf500930249c6baa44670c29e94e7187350badd9bab72f9c350badd9bab72f9c350badd9bab72f9c
X-Originating-IP: 98.234.127.54
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Group,


	Out of memory (oom) process killer is invoked when there is EXTREME  
memory stress.

	With the understanding that anytime we kill a process, a minimal  
amount of information
	about the process should be kept to be able to backtrack why a system  
may be currently
	be running with less than a normal level of functionality.

	Thus, ./mm/oom_kill.c : oom_kill_process()

	This change limits the amount of printing while keeping the coarse  
level of info
	when a process is killed within one function. The later function  
calls generate
	multiple times of output than the one printk that we are keeping.

	move the if (printf_ratelimit() ) { statement to after the printk  
invoked oom-killer

	2ndly, should the not / " ! "  be stated within the ratelimit check?

	Mitchell Erblich
	FYI: This CHANGE is one of a set of simple set of changes AND is my  
"due-dilligence" of what was partially done
	        for a company and due to ... was not submitted back to  
Linux.org. The major section re-writes are not being
	        submitted at this time.
	
	
