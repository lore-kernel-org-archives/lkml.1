Return-Path: <linux-kernel-owner+w=401wt.eu-S933488AbXGWSC0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933488AbXGWSC0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jul 2007 14:02:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757968AbXGWSCT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jul 2007 14:02:19 -0400
Received: from web55613.mail.re4.yahoo.com ([206.190.58.237]:41253 "HELO
	web55613.mail.re4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1761590AbXGWSCS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jul 2007 14:02:18 -0400
X-Greylist: delayed 400 seconds by postgrey-1.27 at vger.kernel.org; Mon, 23 Jul 2007 14:02:18 EDT
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=X-YMail-OSG:Received:Date:From:Subject:To:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-ID;
  b=zFr9rJaRfEOffgmHjVHMNLwiqHhwc902TtCyyC3csG2uiSGfj4MvWNQtpMZwuNm9wVYXGF3Dn2fN/6sZPUDpjQkdgAOarcEyAuibHHXeOvtoy31io742Hz5sgHacK+sSo/auwX4otmACZI2dOJr85SECQ61342pLhLAWynOib5w=;
X-YMail-OSG: oMORcOkVM1l8JsklNDFJXQ8zc1CBctBaVXf0mDJw6mDDiCHvsd5WYdjV6tZIX4vs8Zu0pRt_An63O7j6sE2OjFWJn94pJY6fMlDP0PAz6lgiXZLhIA8mpO61qujj6f0-
Date: Mon, 23 Jul 2007 10:55:36 -0700 (PDT)
From: Amit Choudhary <amit2030@yahoo.com>
Subject: Re: [PATCH] include/linux/slab.h: new KFREE() macro.
To: Linux Kernel <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Message-ID: <705774.678.qm@web55613.mail.re4.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


>Amit Choudhary <amit2030@xxxxxxxxx> wrote:
>> --- Christoph Hellwig <hch@xxxxxxxxxxxxx> wrote:
>>> On Sun, Jan 07, 2007 at 12:46:50AM -0800, Amit Choudhary wrote:

>> Any strong reason why not? x has some value that does not make sense and can
>> create only problems. And as I explained, it can result in longer code too.
>> So, why keep this value around. Why not re-initialize it to NULL.

>1) Because some magic value like 0x23 would be better.
>2) Because it hides bugs like double frees or dangeling references while
>creating a race condition. In the end, you'll get more hard-to-find bugs
>in exchange for papering over some easy-to-spot bugs.

Sorry for spamming the list again but some people may find this useful:

[Dangling pointers are security vulnerability]

http://it.slashdot.org/it/07/07/23/1624203.shtml

Excerpt:
***
Dangling pointers are quite common, but security experts and developers have said for years that
there is no practical way to exploit them, so they've been considered quality-assurance problems
and not security flaws.

But now that has changed.

"The problem before was, you had to override the exact location that the pointer was pointing to.
It was considered impossible. But we discovered a way to do this with generic dangling pointers
and run our own shell code."
***

-Amit



       
____________________________________________________________________________________
Take the Internet to Go: Yahoo!Go puts the Internet in your pocket: mail, news, photos & more. 
http://mobile.yahoo.com/go?refer=1GNXIC
