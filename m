Return-Path: <linux-kernel-owner+w=401wt.eu-S1753212AbXFYRr3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753212AbXFYRr3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jun 2007 13:47:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751100AbXFYRrW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Jun 2007 13:47:22 -0400
Received: from web63510.mail.re1.yahoo.com ([69.147.97.65]:25761 "HELO
	web63510.mail.re1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1750881AbXFYRrV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jun 2007 13:47:21 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=X-YMail-OSG:Received:Date:From:Subject:To:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-ID;
  b=vLL+BUNJLX7mb+ui9KuwKuRcXEltzUW2vPtvdkQDDISNJe6BjTFA+mYuWJAF6Tq/rAWPnfq1BcnaRPTzAjAAQtUzLrXaH3mFnEjy4HtZK/vI/W9eTsl9XzQwx7wROUQPVC9Wa+MYfaiA4zVQ8s5HPrU5BER7/TlMVmvxRkiL6AI=;
X-YMail-OSG: lK1a9t0VM1lTU0Sp__GOtKQPOrOzz4fOPxKrLwsQLHI2WsbQWO_do.7Lzad7hCOeUtbznY5dE.mKbkAnJoS59UTetiuvnNVDOd06kiACv_Tf_TfrRaffJjR9CnXsaI53h.lLTMqZtDJ7ZuR5yzAC4Qsm
Date: Mon, 25 Jun 2007 10:47:21 -0700 (PDT)
From: Ioannis Barkas <risc4all@yahoo.com>
Subject: [PATCH] VGA-softcursor.txt: Point at the correct directory of vgacon.c
To: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Message-ID: <126518.4255.qm@web63510.mail.re1.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Fixes wrong, outdated path of vgacon.c

Hello we are Ioannis Barkas (risc4all@yahoo.com) and
Nikos Barkas (doubl3nuts@yahoo.com).

VGA-softcursor.txt points to vgacon.c at a wrong
directory so we fix it.

There is the patch(we do not attach it as many people
suggest not to do so) from diff -u:

--- /linux-2.6.21/Documentation/VGA-softcursor.txt
2007-04-26 04:08:32.000000000 -0400
+++ /linux/Documentation/VGA-softcursor.txt	2007-06-25
02:21:23.000000000 -0400
@@ -4,11 +4,11 @@
    Linux now has some ability to manipulate cursor
appearance. Normally, you
 can set the size of hardware cursor (and also work
around some ugly bugs in
 those miserable Trident cards--see #define
TRIDENT_GLITCH in drivers/video/
-vgacon.c). You can now play a few new tricks:  you
can make your cursor look
-like a non-blinking red block, make it inverse
background of the character it's
-over or to highlight that character and still choose
whether the original
-hardware cursor should remain visible or not.  There
may be other things I have
-never thought of.
+console/vgacon.c). You can now play a few new tricks:
 you can make your
+cursor look like a non-blinking red block, make it
inverse background of the
+character it's over or to highlight that character
and still choose whether
+the original hardware cursor should remain visible or
not.  There may be other
+things I have never thought of.
 
    The cursor appearance is controlled by a
"<ESC>[?1;2;3c" escape sequence
 where 1, 2 and 3 are parameters described below. If
you omit any of them,


 
____________________________________________________________________________________
We won't tell. Get more on shows you hate to love 
(and love to hate): Yahoo! TV's Guilty Pleasures list.
http://tv.yahoo.com/collections/265 
