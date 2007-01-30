Return-Path: <linux-kernel-owner+w=401wt.eu-S1752118AbXA3QYP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752118AbXA3QYP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jan 2007 11:24:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752125AbXA3QYP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jan 2007 11:24:15 -0500
Received: from ug-out-1314.google.com ([66.249.92.174]:53365 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752118AbXA3QYO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jan 2007 11:24:14 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=rwibha4okkKGsRKf5UFHVxGZ8jwAExj5jfHDatrl58nabKxgRMe7g1qT+9mOzj6y/Og2nuLug0A+UMhx0f7Rgw6Xi9UzpuBXBt9F29zBw2lG7Um4J8MJ5Gg6U4jzU/KWYSj/NhlKsieY58HhTadY+zBOzfFMd9R4hSA8kB78txY=
Message-ID: <671c20540701300824p54dad7dbw43fe916bc8c98d45@mail.gmail.com>
Date: Tue, 30 Jan 2007 11:24:12 -0500
From: "Tom Burns" <tom.i.burns@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: Bug: 2.6.15 Process accounting fails to account for small time slice loads (still)
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

The bug described back in 2004 in the following message still seems to exist:

http://linux.derkeiler.com/Mailing-Lists/Kernel/2004-05/4313.html

Essentially, it appears that if a process sleeps before it uses up a
complete jiffy then no charge is made to its process accounting table.

This problem still exists in the same manner in kernel:

 2.6.15-1.2054_FC5smp #1 SMP Tue Mar 14 16:05:46 EST 2006 i686 i686
i386 GNU/Linux

The linked message above contains the necessary code to easily test
for the problem.  It compiles cleanly, just be sure to include -lrt on
the command line.

Cheers,
Tom Burns
