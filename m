Return-Path: <linux-kernel-owner+w=401wt.eu-S1756384AbZA3UIX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756384AbZA3UIX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Jan 2009 15:08:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753984AbZA3UID
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Jan 2009 15:08:03 -0500
Received: from tomts25-srv.bellnexxia.net ([209.226.175.188]:53920 "EHLO
	tomts25-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752811AbZA3UIB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Jan 2009 15:08:01 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AtMEAGzpgklMQWt2/2dsb2JhbACBbslIhBAGhRI
Date: Fri, 30 Jan 2009 15:07:57 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: ltt-dev@lists.casi.polymtl.ca, linux-kernel@vger.kernel.org,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       "Theodore Ts'o" <tytso@mit.edu>,
       Ext4 Developers List <linux-ext4@vger.kernel.org>
Subject: LTTng 0.89 for Linux 2.6.29-rc3
Message-ID: <20090130200757.GA14999@Krystal>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 12:26:10 up 29 days, 17:24,  3 users,  load average: 0.81, 0.57,
	0.46
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I just ported LTTng to the 2.6.29-rc3 kernel. It includes the following
changes :

- Tree RCU instrumentation
- Updated ext4 and jbd2 instrumentation

Please feel free to try it and report any success/problem you may have.
Note that cross-build has been slightly less tested this time because
I'll have to upgrade many of my compilers to a version compatible with
kernel 2.6.29-rc.

It also includes the recently added kprobes support through a simple

echo symbol_name > /mnt/debugfs/ltt/kprobes/enable

It's available at the new LTTng website :

http://www.lttng.org/

Thanks,

Mathieu

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
