Return-Path: <linux-kernel-owner+w=401wt.eu-S1756095AbXJWWwq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756095AbXJWWwq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2007 18:52:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753140AbXJWWwh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Oct 2007 18:52:37 -0400
Received: from gate.crashing.org ([63.228.1.57]:58501 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754811AbXJWWwf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2007 18:52:35 -0400
Mime-Version: 1.0 (Apple Message framework v752.2)
Content-Type: text/plain; charset=US-ASCII; delsp=yes; format=flowed
Message-Id: <CBDE987B-0713-4D62-8122-054183E75410@kernel.crashing.org>
Cc: trond.myklebust@fys.uio.no, nfs@lists.sourceforge.net, neilb@suse.de,
       bfields@fieldses.org, chuck.lever@oracle.com
Content-Transfer-Encoding: 7bit
From: Kumar Gala <galak@kernel.crashing.org>
Subject: LTP ustat01 test fails on NFSROOT
Date: Tue, 23 Oct 2007 17:52:44 -0500
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
X-Mailer: Apple Mail (2.752.2)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

I'm looking into an issue with LTP's ustat01 & ustat02 tests in which  
they report the following:

ustat01     1  FAIL  :  ustat(2) failed and setthe errno to 116 :  
Stale NFS file handle
ustat02     2  FAIL  :  ustat(2) failed to produce expected error;  
14, errno: EFAULT and got 116

It appears sometime between 2.6.21 and 2.6.22-rc1 some changes to NFS  
got introduced that cause this.

was wondering about any ideas while I try to debug what's going on.

thanks

- k
