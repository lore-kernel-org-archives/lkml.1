Return-Path: <linux-kernel-owner+w=401wt.eu-S1758996AbXIUNMX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758996AbXIUNMX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2007 09:12:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757361AbXIUNMQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Sep 2007 09:12:16 -0400
Received: from web82106.mail.mud.yahoo.com ([209.191.84.219]:35941 "HELO
	web82106.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1750871AbXIUNMP convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2007 09:12:15 -0400
X-Greylist: delayed 399 seconds by postgrey-1.27 at vger.kernel.org; Fri, 21 Sep 2007 09:12:15 EDT
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=X-YMail-OSG:Received:X-Mailer:Date:From:Subject:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-ID;
  b=wdoGoZ8PIlWR2WIczLppdBRc18OSihJKTKZ+BCzyk05tWKQyMnH3WpUatixs1kqkohG9b6PiOv+/0eM6QJqwOw0y4L2o1TacPzDnRvdDUyXpRIF/ghJqlKZ3KzCZFas/LbbIIphuKUCrOYP57Mgh8hdY9pXV/qspQT5S/ShoxLM=;
X-YMail-OSG: 9qdpgj8VM1nPuCWn5AVkd0I8MxThU.FyAzCmU7OffUFUCqKYJQ7IzG1CgfUQEMpXBA--
X-Mailer: YahooMailRC/651.50 YahooMailWebService/0.7.134
Date: Fri, 21 Sep 2007 06:05:35 -0700 (PDT)
From: Scott Preece <sepreece@yahoo.com>
Subject: Re: [Celinux-dev] Re: [Announce] Linux-tiny project revival
To: Tim Bird <tim.bird@am.sony.com>, Rob Landley <rob@landley.net>
Cc: linux-tiny@selenic.com, linux kernel <linux-kernel@vger.kernel.org>,
       CE Linux Developers List <celinux-dev@tree.celinuxforum.org>,
       Michael Opdenacker <michael@free-electrons.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Message-ID: <498851.95136.qm@web82106.mail.mud.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

----- Original Message ----
From: Tim Bird <tim.bird@am.sony.com>

Rob Landley wrote:


Given that there are about 60,000 printks in the kernel (and that's
not counting wrappers like dprintk() and other locally-defined
functions and macros) it would be a huge task to examine the code
and differentiate strings that really start a new log message
(and thus should have an attached log level) and strings
that don't.
 -- Tim

---

So, if this is a good idea, maybe the new version with the separate argument should have a new name? Then you can mechanically convert the onces that fit the pattern to the new name and form and leave the others to clean up later.

scott



