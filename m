Return-Path: <linux-kernel-owner+w=401wt.eu-S935551AbZDIPoQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935551AbZDIPoQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Apr 2009 11:44:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765010AbZDIPnw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Apr 2009 11:43:52 -0400
Received: from gate.crashing.org ([63.228.1.57]:55812 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1764489AbZDIPnv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Apr 2009 11:43:51 -0400
Message-Id: <0CA2FBE3-C50C-4503-9134-6DA1C6965743@kernel.crashing.org>
From: Kumar Gala <galak@kernel.crashing.org>
To: linux-kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=US-ASCII; format=flowed; delsp=yes
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0 (Apple Message framework v930.3)
Subject: LTP 20080131 causes defunct processes w/2.6.30-rc1 (possible ptrace issue?)
Date: Thu, 9 Apr 2009 10:43:49 -0500
X-Mailer: Apple Mail (2.930.3)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'm seeing some weird behavior in 2.6.30-rc1 that didn't exist in  
2.6.29.  We have a slightly older LTP version (20080131) that we run  
on some embedded PPC boards.  If I run the syscall tests on 2.6.29  
things pass as expected.  W/2.6.30-rc1 I start seeing a slew of  
processes that are "defunct".  I was able to trim down the tests to  
the following ones (the recv01 test will become defunct):

ptrace01 ptrace01
ptrace02 ptrace02
ptrace03 ptrace03

recv01 recv01

I'm able to reproduce this in a simulator, and am working on bisecting  
it down now.

Was wondering if there was anything ptrace related that went in that  
could possible cause this?

- k
