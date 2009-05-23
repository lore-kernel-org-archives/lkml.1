Return-Path: <linux-kernel-owner+w=401wt.eu-S1751676AbZEWE3P@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751676AbZEWE3P (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 May 2009 00:29:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750740AbZEWE3B
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 May 2009 00:29:01 -0400
Received: from n6.bullet.re3.yahoo.com ([68.142.237.91]:36490 "HELO
	n6.bullet.re3.yahoo.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1750736AbZEWE3A convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 May 2009 00:29:00 -0400
X-Greylist: delayed 415 seconds by postgrey-1.27 at vger.kernel.org; Sat, 23 May 2009 00:29:00 EDT
X-Yahoo-Newman-Property: ymail-3
X-Yahoo-Newman-Id: 44770.87771.bm@omp103.mail.gq1.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=Message-ID:X-YMail-OSG:Received:X-Mailer:Date:From:Subject:To:MIME-Version:Content-Type:Content-Transfer-Encoding;
  b=3NfNx1Cc4kRwiXNP3Ay5UgYPtSVfCTJbnd/rJqOSFoSQS+lCVo5c6qrX/23l4Q//UcA0Ut1mfQvS/m8IyyhDATdgVYdeE0J/SBO5jLs0FbxVNS/hESVtWx8ESGrOLGe5QRu5PY3ujiEHmbSBv1Twc5RO0XPNJEE0N+8NNw6QWEY=;
Message-ID: <784636.43001.qm@web111109.mail.gq1.yahoo.com>
X-YMail-OSG: Axuz0ZkVM1msgBqL50qSPvBN60fSWObuflb66.WlIyw5T7ph0Ak2H2Pir4S3CPauvOKgU1LIZbURkHQCqLe2hOFoPsZiavbuc2ZHWcfgC2c2duBH_dvUdx49AdeFBCTOTBqwHiFTCN0kUgMPH4umUtnJOpzjNja2r9YG8epUpUWvSF.z4y5ZfGnd9hoPSfhGmsQTqAMiuQQ8JBj_AdFV.RDTwd9t1MoSwpRWuzAUsMJB1sCCgRpFb89ObC2f1AJqXbdd1RAu8Ah8DgpyliA-
X-Mailer: YahooMailClassic/5.3.9 YahooMailWebService/0.7.289.10
Date: Fri, 22 May 2009 21:22:05 -0700 (PDT)
From: Kunsheng Chen <linux_kernel_chan@yahoo.com>
Subject: Why current->uid is not working in 2.6.29 ?
To: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hello everyone,

I am new to kernel module programming and got some problem while compiling some old kernel code. 

The
code is trying to get user id using current->uid,   but it is not
working by reminding me 'task_struct; doesn't contain field uid '.  

I checked the linux source code , uid is not there any more.

The 'current' is of task_struct, so could anyone tell me where is the new place for that uid ?


Thanks in advance,

-Kun  



      

