Return-Path: <linux-kernel-owner+w=401wt.eu-S1755874AbYDFEK1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755874AbYDFEK1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Apr 2008 00:10:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752322AbYDFEKP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Apr 2008 00:10:15 -0400
Received: from web52504.mail.re2.yahoo.com ([206.190.48.187]:22184 "HELO
	web52504.mail.re2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752193AbYDFEKP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Apr 2008 00:10:15 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=X-YMail-OSG:Received:Date:From:Subject:To:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-ID;
  b=XAqAxeCZhTQlYONla+amIosapIVLwqPnUYW3Lusgib9nTpAynB4iFqcozpG1tOUHPD4+tJFuYO7DzfYDIZFnWCEmqaOMVbxpogBrbIP60W53reSuiC91uPm9Z1ZRPs8P/xqQkI8GJ7Iz42WxrDoN1oNyPvTGI2PwpRp0sVtTHFE=;
X-YMail-OSG: osrT1XkVM1mnZJmHc2C06HqPamu9Rwyypvfl0S80z5f2S4g_zvyH22GNT9NGSPuugf51cgjVq8K.9ey3iXW_6MTqfMJzSX88cK.F3kXc2053ksZMA55WDnq1qi8UzA--
Date: Sat, 5 Apr 2008 21:10:13 -0700 (PDT)
From: Marc Perkel <mperkel@yahoo.com>
Subject: tee question [OT]
To: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Message-ID: <96637.86039.qm@web52504.mail.re2.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Just wondering if any of you experts know how to do
this. I want to take an imput stream and produce two
output streams to feed into two different pipes.

echo "1 2 3 4 5" | tee ...
| cut -d \  -f -4 >> file1.txt
| cut -d \  -f 1,2,5- >> file2.txt

The idea being that file1.txt would get "1 2 3 4" and
file2.txt would get "1 2 5"

How do I do it? Tee wants a file as an argument and I
want that file to be a process. Anyhow - I'm not very
smart. 

Thanks in advance.




Marc Perkel
Junk Email Filter dot com
http://www.junkemailfilter.com


      ____________________________________________________________________________________
You rock. That's why Blockbuster's offering you one month of Blockbuster Total Access, No Cost.  
http://tc.deals.yahoo.com/tc/blockbuster/text5.com
