Return-Path: <linux-kernel-owner+w=401wt.eu-S1762773AbXIKR32@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762773AbXIKR32 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Sep 2007 13:29:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752270AbXIKR3V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Sep 2007 13:29:21 -0400
Received: from web52004.mail.re2.yahoo.com ([206.190.49.251]:37103 "HELO
	web52004.mail.re2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752085AbXIKR3U convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Sep 2007 13:29:20 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=X-YMail-OSG:Received:X-Mailer:Date:From:Subject:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-ID;
  b=XFomZ9sPWg5hetFBZsTGSFtdvqrcSUscC6fiGpWYKCmsIk/hOSj4nFPbTYO1+itqeiFjkWobGsW4iFrhyYAZJXIhRlN+OAL1W2n9dQ+8LhkPZcMDumH3BRChPFO0hE1gpkBM5Rnp/eM54Ay3zE7LAhE21E17IJWcMDk+Vm/ZuZs=;
X-YMail-OSG: 2b.cUHEVM1kGTY2OLo7wPRWxeRUYb2gr4i5pJhqEsbMsmki7kkI3CMh3B5tX_8kB6KgeWFPjVZ3nGCA14p63Cz2y8b95MTORo.nKFawLGK0Hr4JbMtgVPBmaAzy42w--
X-Mailer: YahooMailRC/651.50 YahooMailWebService/0.7.134
Date: Tue, 11 Sep 2007 10:29:19 -0700 (PDT)
From: Matti Linnanvuori <mattilinnanvuori@yahoo.com>
Subject: Do not deprecate binary semaphore or do allow mutex in software interrupt contexts
To: Peter Zijlstra <peterz@infradead.org>
Cc: linux-kernel@vger.kernel.org, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       arjan <arjan@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Message-ID: <432622.65445.qm@web52004.mail.re2.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Peter Zijlstra <peterz@infradead.org>:
> Yes it is.

Why do you think it is broken?

> If you have to wait a long time in an atomic context you've done
> something wrong.

I saw an implementation where there were two atomic contexts, one to initiate reading and another to complete the reading. 
That way, there was no busy wait for a long time in an atomic context.

> If you're only reading it from an atomic context you
> might consider storing a copy that can be quickly updated and protect
> that using a spinlock.

You suggested that a user-space task read from the device. 
But that includes more context switching and therefore consumes more resources than reading just from an atomic context.

> Not being too familiar with the timer stuff, it smells wrong what you
> say.

Why?




      Wissenswertes für Bastler und Hobby Handwerker. BE A BETTER HEIMWERKER! www.yahoo.de/clever
