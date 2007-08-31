Return-Path: <linux-kernel-owner+w=401wt.eu-S965811AbXHaROg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965811AbXHaROg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Aug 2007 13:14:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965394AbXHaRO3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 31 Aug 2007 13:14:29 -0400
Received: from web52005.mail.re2.yahoo.com ([206.190.49.252]:38587 "HELO
	web52005.mail.re2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S965379AbXHaRO2 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Aug 2007 13:14:28 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=X-YMail-OSG:Received:X-Mailer:Date:From:Subject:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-ID;
  b=RctOGADX9MJbUmxe8qNLcZTo+SVBX46smfhUCdtjOWrJ0qzTaFDKAD44Cdu4Qd2JCPWIRJV09m88jvGLltRPgHw7J0xltOEVzvAnjtS1vYjckaWTFz1kPfwBfw0TDk/FBJG7HqmlOATKYvOINt5NwtUzuMSwG9Q/KTPsntFy4Lc=;
X-YMail-OSG: t4st7ZQVM1mjwWAwKbuXEzsV6oaV9hD0RbseSD444f1DJJpZxJMZnMGAgAs2MWBnDpoEKBgnl1mVKlXBB8r43vMVguvMKcLIeysD5uiXsOssmuV80bfMnj5nwthpxw--
X-Mailer: YahooMailRC/651.50 YahooMailWebService/0.7.134
Date: Fri, 31 Aug 2007 10:14:27 -0700 (PDT)
From: Matti Linnanvuori <mattilinnanvuori@yahoo.com>
Subject: [Bugme-new] [Bug 8957] New: Exported functions and variables
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: bugme-daemon@kernel-bugs.osdl.org
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Message-ID: <116718.45429.qm@web52005.mail.re2.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

It seems to me that kernel/module.c allows the whole kernel to use exported symbols during the execution of the init function if they are weak:
                        /* Ok if weak.  */
                          if (ELF_ST_BIND(sym[i].st_info) == STB_WEAK)
                                  break;
That seems a possible way to produce the scenario of this so-called bug.



      ________ 
Yahoo! Clever: Stellen Sie Fragen und finden Sie Antworten. Teilen Sie Ihr Wissen. www.yahoo.de/clever

