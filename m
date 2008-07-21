Return-Path: <linux-kernel-owner+w=401wt.eu-S1752756AbYGUSKx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752756AbYGUSKx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2008 14:10:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750794AbYGUSKp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Jul 2008 14:10:45 -0400
Received: from web50711.mail.re2.yahoo.com ([206.190.38.163]:48137 "HELO
	web50711.mail.re2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1750763AbYGUSKp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2008 14:10:45 -0400
X-Greylist: delayed 401 seconds by postgrey-1.27 at vger.kernel.org; Mon, 21 Jul 2008 14:10:45 EDT
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=Received:X-Mailer:Date:From:Reply-To:Subject:To:MIME-Version:Content-Type:Message-ID;
  b=rmJYp7rIsIL3YUpAsGBs0xATWknBMMdWSaoIVM6/1n1kogN08C6w17ZI2suE1nvOPjCod+NgX1SWB7322n9i2rr9ZSbF0AAOy59nDQig/i4fTwR5aVrc2OPQEHvYQENm1Ro6bqfIqauS8NmIIaquZAaRBb189epB0sSh6sfNHgk=;
X-Mailer: YahooMailWebService/0.7.218
Date: Mon, 21 Jul 2008 11:04:03 -0700 (PDT)
From: soohoon lee <soohoon_lee@yahoo.com>
Reply-To: soohoon_lee@yahoo.com
Subject: Question: queuing timer interrupts
To: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <105452.56459.qm@web50711.mail.re2.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi,
I like to ask you experts what would be a better way to solve following problem and side effects of my solution.

There is a system and sometimes it should unavoidably block interrupts for critical jobs for couple of 10ms so will lost timer ticks.
But keeping the wall clock is also critical.
I thought about two solutions.
1. update wall clock when OS gets out of the critical section.
2. Add a hardware to count lost timer ticks, it's easy for this system.
   So when the OS is able to process interrupts again, the hardware generates timer interrupts back to back to compensate lost ticks.

Thanks in advance,
Soohoon.



      
