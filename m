Return-Path: <linux-kernel-owner+w=401wt.eu-S1753665AbXD2Brz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753665AbXD2Brz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Apr 2007 21:47:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753699AbXD2Brz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Apr 2007 21:47:55 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:38546 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753570AbXD2Brx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Apr 2007 21:47:53 -0400
Date: Sat, 28 Apr 2007 18:47:44 -0700
From: Paul Jackson <pj@sgi.com>
To: menage@google.com
Cc: akpm@linux-foundation.org, dev@sw.ru, xemul@sw.ru, serue@us.ibm.com,
       vatsa@in.ibm.com, ebiederm@xmission.com, haveblue@us.ibm.com,
       svaidy@linux.vnet.ibm.com, balbir@in.ibm.com,
       ckrm-tech@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       rohitseth@google.com, mbligh@google.com, containers@lists.osdl.org,
       devel@openvz.org
Subject: Re: [PATCH 0/9] Containers (V9): Generic Process Containers
Message-Id: <20070428184744.bc0345a0.pj@sgi.com>
In-Reply-To: <20070427104607.252541000@menage.corp.google.com>
References: <20070427104607.252541000@menage.corp.google.com>
Organization: SGI
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.3; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> - decide whether "Containers" is an acceptable name for the system
> given its usage by some other development groups, or whether something
> else (ProcessSets? ResourceGroups? TaskGroups?) would be better

I place in nomination:

	tasksets

However this would conflict with the taskset utility in Robert Loves
schedutils package.  The 'taskset' command "is used  to set or retrieve
the CPU affinity of a running process given its PID or to launch a new
COMMAND with a given CPU affinity."

The various alternatives you listed all have the advantage of stating
both that we have a container/group/set/collection/... of something,
and -what- that something might be - process/resource/task/...

"tasksets" is the shortest spelling I could think of for such a compond
"Something-Collection" form.

If the conflict with the schedutils utility is a concern, then the
next best alternative would be:

	taskgroups

This is the next shortest way to spell this "Something-Collection" form.

-- 
                  I won't rest till it's the best ...
                  Programmer, Linux Scalability
                  Paul Jackson <pj@sgi.com> 1.925.600.0401
