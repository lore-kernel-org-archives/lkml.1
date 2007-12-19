Return-Path: <linux-kernel-owner+w=401wt.eu-S1756865AbXLSUBU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756865AbXLSUBU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Dec 2007 15:01:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753550AbXLSUBA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Dec 2007 15:01:00 -0500
Received: from ug-out-1314.google.com ([66.249.92.168]:42739 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753236AbXLSUA7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Dec 2007 15:00:59 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=user-agent:date:from:to:cc:subject:mime-version:x-mailer:content-transfer-encoding:sender:message-id;
        b=ARlyGaVKElUU1oXCYSq/iZN+Q1qfnGP0NV4vJ9zSyJAr5GU5rebwhgzFRqOLdJ+F+vEMI/to6tOlNN++XFG5ZlXwNcehM0KgOlp0uq9hMUt9VMf3cBXtwLIgiXUGWJqkS5v80p2Q6ED4SVSUazhJggAOfBC+UWE4zZdhHZatfvU=
User-Agent: quilt/0.46-1
Date: Wed, 19 Dec 2007 20:45:51 +0100
From: Remy Bohmer <linux@bohmer.net>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
       Ingo Molnar <mingo@elte.hu>, Juergen Beisert <jbe@pengutronix.de>,
       Darren Hart <dvhltc@us.ibm.com>, linux-rt-users@vger.kernel.org,
       Sven-Thorsten Dietrich <sdietrich@novell.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [patch 0/3] add kernel-cmdline support for interrupt thread
	priorities (repost:CC to LKML)
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 (2.12.1-3.fc8) 
Content-Transfer-Encoding: 7bit
Message-ID: <47697877.08aa420a.4404.ffff8bed@mx.google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello All,

Back in August we had a discussion about the default priorities of
IRQ-threads and softirqs, and the lack of a mechanism to configure them from
within the kernel.
(see http://www.mail-archive.com/linux-rt-users@vger.kernel.org/msg01022.html)

Here is a patchset that implements such a nice feature from the kernel cmdline,
similar to what we all agreed on, back then.

The set exist of 3 parts:
1) add a generic routine to the kernel commandline-parse-library to parse the
format of the map as we agreed on.
2) Add a __setup(irq_pmap=) routine to kernel/irq/manage.c
3) Add a __setup(sirq_pmap=) routine to kernel/softirq.c

I hope you can find the time to review this set.


Kind Regards,

Remy Bohmer
-- 

