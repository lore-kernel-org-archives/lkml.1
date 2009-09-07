Return-Path: <linux-kernel-owner+w=401wt.eu-S1752151AbZIGIOm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752151AbZIGIOm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Sep 2009 04:14:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752036AbZIGIOl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Sep 2009 04:14:41 -0400
Received: from mail-yx0-f175.google.com ([209.85.210.175]:64265 "EHLO
	mail-yx0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752017AbZIGIOk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Sep 2009 04:14:40 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:subject:message-id:x-mailer:mime-version:content-type
         :content-transfer-encoding;
        b=qe1cWxQ0oxtBuY0ZksPMo94D6KShZ+2TxfB0DaXgN0e+gsXzoeQc8UtmrT3B5o5xW4
         zV1Uw+laTA34yi4CXpEiXinadtlqYgxFCS8I219HjuywWduLQaIIS4LWRRaT/KxeWTo9
         JDlYLEc7wntV7xzOAJedEBY1GcMHPLRVfwE6M=
Date: Mon, 7 Sep 2009 16:14:37 +0800
From: "lookeylam" <lookeylam@gmail.com>
To: "linux-kernel" <linux-kernel@vger.kernel.org>
Subject: About CPU's Load Balance and CFS functions
Message-ID: <200909071614346093582@gmail.com>
X-mailer: Foxmail 6, 15, 201, 22 [cn]
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello:
         I am  not sure this  is the right maillist to ask this question. I just have a try.
         I have a test on Dell 1950 with 8 cpus on board for testing the apache by ab command. And I find that in 
         linux 2.6.18. The processes forked by apache are not well distributed on these 8 cpus.
         linux 2.6.23 is a little better than 2.6.18, but still some cpus are running busy and some cpus remains idle.
         While in  2.6.30, these 8 cpus are well used and the percentage of each cpu is nearly the same. And when I 
         start the control group with cpuset type with sched_relax_domain_level( with value 3,4,5). The result of ab is 50ms better than test results without control group. 
        
         I attribute this situation to to load_balance but not CFS, because CFS is just a scheduler for orgnizing the process inside one cpu, while load_balance is the main character to control the process and load between different cpus.
         But when i give out this conclusion, I confuse about the differences of these three kernels of load_balance.
         
         My questions are the above conclusion  is right or not? How would these situation happen and why? I read the code of the kernel but I am still not sure.
        
        Thanks.
 				

