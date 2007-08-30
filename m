Return-Path: <linux-kernel-owner+w=401wt.eu-S1760976AbXH3RvH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760976AbXH3RvH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Aug 2007 13:51:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758743AbXH3Ru4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Aug 2007 13:50:56 -0400
Received: from web52012.mail.re2.yahoo.com ([206.190.48.28]:25601 "HELO
	web52012.mail.re2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1758284AbXH3Ru4 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Aug 2007 13:50:56 -0400
X-Greylist: delayed 399 seconds by postgrey-1.27 at vger.kernel.org; Thu, 30 Aug 2007 13:50:55 EDT
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=X-YMail-OSG:Received:X-Mailer:Date:From:Subject:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-ID;
  b=1j7b8+mdVnB1umFk21P1yIoVoxY3KCmdUwHRst55SsrqPac7rHF8sXhhP2j1F/wNQf2gTwDf+gemAtzhB323INZjdXaKD41wOdCDPqxWIS7T5/WP1vOOboVVpoxdQ1YqpYbnwfxvGaVA+ZBtG5Q7y2m5s3zikkacnqgNZJOLQmQ=;
X-YMail-OSG: iLxRIVsVM1knZJzPXK5Q58mEbKIfWZPFesZ19lEx.BntUvkbtFSYG4d9IGTV5_Fckkg9IMtYl0XB68rCJtDPc12fFWcACUo.Qgw54AosEdToVOov.LwPsc8mdnmR2g--
X-Mailer: YahooMailRC/651.48 YahooMailWebService/0.7.134
Date: Thu, 30 Aug 2007 10:44:15 -0700 (PDT)
From: Matti Linnanvuori <mattilinnanvuori@yahoo.com>
Subject: [Bugme-new] [Bug 8957] New: Exported functions and variables
To: linux-kernel@vger.kernel.org
Cc: bugme-daemon@kernel-bugs.osdl.org
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Message-ID: <469780.175.qm@web52012.mail.re2.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

I thought I had seen that bug. Module init function execution does not seem serialized enough, so the init function of one module seems to be able to be called in parallel with several other modules in turn being loaded, executing their init functions and even becoming live first class citizens.
Function sys_init_module in 
Linux 2.6.22.x and 2.6.23-rc4 kernel/module.c does not hold module_mutex when executing the init functions of the modules.




      __________________________________  
Alles was der Gesundheit und Entspannung dient. BE A BETTER MEDIZINMANN! www.yahoo.de/clever
