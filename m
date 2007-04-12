Return-Path: <linux-kernel-owner+w=401wt.eu-S1753372AbXDLUkS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753372AbXDLUkS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Apr 2007 16:40:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753398AbXDLUkS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Apr 2007 16:40:18 -0400
Received: from smtp104.plus.mail.re2.yahoo.com ([206.190.53.29]:25496 "HELO
	smtp104.plus.mail.re2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753372AbXDLUkQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Apr 2007 16:40:16 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.de;
  h=Received:X-YMail-OSG:Received:Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:Content-Disposition:User-Agent;
  b=Pw8CoBTqNcdCfhpQvQal655A9feSNQOMSxuJg/GmVCBQh9EJJrH/dd/K06AUl5qf9sgTIXQufgxxAhMjMk2N3pdBxG75lQ+xpWgDgIZrmtDVCSqprM4Zbmia46YDa6WMZPkqucNaSf8/39kNsD9p5nTunpKNjlIEGt9MsLfZ+NE=  ;
X-YMail-OSG: KEUifvYVM1mZFw9dNvE6I1Ipg_eABrDYeBmWiajT3q.yt6T0XiSXRpNEAuXwoGmvs1oEdjug_jFKtY8SBsPg2MWeAaqIPK2wvkwu6WPgFhMpcaNVG5TFlfEcO.bgDeCVt9SX5ZyIzzL1tA--
Date: Thu, 12 Apr 2007 22:38:42 +0200
From: Borislav Petkov <bbpetkov@yahoo.de>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: lkml <linux-kernel@vger.kernel.org>
Subject: [PATCH] [KERNEL-DOC] fix tex error when building pdfdocs
Message-ID: <20070412203842.GA14245@zmei.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

When building pdfdocs, the db2pdf converter bails out because of an
latex-reserved token  - '#' - in the intermediary .tex file which ends up in a
conversion error with the following error message: 

<log>
[15.0.32])
! Incomplete \iffalse; all text was ignored after line 8154.
<inserted text>
                \fi
<*> kernel-hacking.tex
</log>

This is a rather arbitrary fix, so suggest away.

Signed-off-by: Borislav Petkov <bbpetkov@yahoo.de>

Index: 21-rc6/Documentation/DocBook/kernel-hacking.tmpl
===================================================================
--- 21-rc6.orig/Documentation/DocBook/kernel-hacking.tmpl
+++ 21-rc6/Documentation/DocBook/kernel-hacking.tmpl
@@ -1138,7 +1138,7 @@ static struct block_device_operations op
   </sect1>
 
   <sect1 id="conventions-ifdef">
-   <title>&num;if</title>
+   <title>Prepocessor Conditionals</title>
    
    <para>
     It is generally considered cleaner to use macros in header files

