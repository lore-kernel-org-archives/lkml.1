Return-Path: <linux-kernel-owner+w=401wt.eu-S946158AbXHMOD2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S946158AbXHMOD2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 10:03:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S939916AbXHMKzu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 06:55:50 -0400
Received: from web7606.mail.in.yahoo.com ([202.86.4.25]:31220 "HELO
	web7606.mail.in.yahoo.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1762882AbXHMKzs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 06:55:48 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.co.in;
  h=X-YMail-OSG:Received:Date:From:Subject:To:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-ID;
  b=I0MPyVZ5FRW8jtQ2wCsDD/UNY5wnGwBh6D/LqIAfACTkS7bEWhBPYa82WFpzkp1Dw5zy656HA+63bmHvku5sKUieRLYvFj1RkRrFOLGgkYLYICLByQCuwKOmMWGnlKOhtZQH+1gErJ7bIDKPl9nfeo6A6xmU6zrLunKJNB8cLvc=;
X-YMail-OSG: WQavnJoVM1mGnKplKpiqxXmGPVdl.VkdD8EIGRr64M3e5gcDEw84F3uNAX7ZJbtXb0eIgJl6H8NNgzC3_Zp2PLahYLwpQoPU0qRHX8U_77qSugCG4to-
Date: Mon, 13 Aug 2007 11:55:40 +0100 (BST)
From: sk malik <srikrishanmalik@yahoo.co.in>
Subject: why use memcpy when memmove is there?
To: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Message-ID: <977159.24669.qm@web7606.mail.in.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, All

We were looking at  "[kernel]/lib/string.c"
(http://lxr.linux.no/source/lib/string.c#L500)

memcpy copies a part of memory to some other location
but It will not work for all cases of overlapping
blocks.(if the start of destination block falls
between the source block)

while memove copes with overlapping areas.

then why is memcpy present in the sources can't we
simply do

"#define memcpy memmove" in include/linux/string.h

or am I missing something?

Regards
Sri



      Unlimited freedom, unlimited storage. Get it now, on http://help.yahoo.com/l/in/yahoo/mail/yahoomail/tools/tools-08.html/
