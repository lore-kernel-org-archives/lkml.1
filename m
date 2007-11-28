Return-Path: <linux-kernel-owner+w=401wt.eu-S1756492AbXK1IQl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756492AbXK1IQl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2007 03:16:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752132AbXK1IQd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Nov 2007 03:16:33 -0500
Received: from web36708.mail.mud.yahoo.com ([209.191.85.42]:47213 "HELO
	web36708.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752096AbXK1IQd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2007 03:16:33 -0500
X-Greylist: delayed 402 seconds by postgrey-1.27 at vger.kernel.org; Wed, 28 Nov 2007 03:16:33 EST
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=X-YMail-OSG:Received:Date:From:Subject:To:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-ID;
  b=B15zHbACT55sSKPJrOenBwf6vfRGh4yYOcfHiEDJ/HOqbn7SRIO/qU6NiCc/Te6ka9yqtXf7OKv4uxXkAuooDvOmebDPR3WXQmqOWrMggea1zrIJmX2yhmlFDlIWnkVcRf5aEaYKNFbvMo85JugCITAzqW7lLt8jyIFuVylqpv4=;
X-YMail-OSG: BnFrQ98VM1mFlQNXk26HiItFwExthxUqgd9L24I36Pclg6n5qDro0s58byon3ud.tcnNJf.kbXZyHXDQKBf.odh7SaUVrJLQH5orBhBfsB2e9XuxvFg-
Date: Wed, 28 Nov 2007 00:09:51 -0800 (PST)
From: murtuja bharmal <murtuja_bharmal@yahoo.com>
Subject: Linux 2.6 kernel module compilation without using KBUILD
To: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Message-ID: <299272.92165.qm@web36708.mail.mud.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello All,
   
I want to compile external linux kernel module without
using KBUILD.
I tried to find out whole process of kernel module
compilation using KBUILD after enabling flag 
KBUILD_VERBOSE=1.
   
If we look at 2.6 kernel module building process.
   
1. gcc is making ".hello.o.d" and ".tmp_hello.o"
   from "hello.c" file.
2. Creating "hello.o" file using ".hello.o.d"
   and ".tmp_hello.o". 
3. Running Script "scripts/mod/modpost" to
   create "hello.mod.c" using “hello.o”.
4. gcc is making "hello.mod.o" after compiling 
   "hello-mod.c" file.
5. finally "ld" is linking "hello.o"
   and "hello.mod.o" and making "hello.ko". 
   
Step 2 of above process is not very much cleared, how
it is making hello-2.o from ".hello.o.d" and
".tmp_hello.o".

What is ".tmp_hello.o”.
   
Do we have any document which describe how to make
kernel module without using KBUILD.
   
Any pointer of information is very helpful for me.
   
Thanks 
Murtuja Bharmal



      ____________________________________________________________________________________
Never miss a thing.  Make Yahoo your home page. 
http://www.yahoo.com/r/hs
