Return-Path: <linux-kernel-owner+w=401wt.eu-S1759374AbXJDKTP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759374AbXJDKTP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Oct 2007 06:19:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757202AbXJDKS7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Oct 2007 06:18:59 -0400
Received: from web8408.mail.in.yahoo.com ([202.43.219.156]:32396 "HELO
	web8408.mail.in.yahoo.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1757571AbXJDKS6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Oct 2007 06:18:58 -0400
X-Greylist: delayed 399 seconds by postgrey-1.27 at vger.kernel.org; Thu, 04 Oct 2007 06:18:57 EDT
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.co.in;
  h=X-YMail-OSG:Received:Date:From:Subject:To:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-ID;
  b=mDS6HF5YgniWNe6qHchj1YFWcg1Cx3Z/oa1B0ZMTAyO+/sxhZ9EPYawAOIcs1Ihn1jE06qg9HWEZk+C5jcnD7CN151IytMSZ3TpBBk7iJmlKBSxW9x+PZFNCKmAHH7TSYHZHImqcJthYcaw5Vrm6BWnPLriQabvpLaLNKFkiJ7w=;
X-YMail-OSG: Et3xM6gVM1lBqhII.7EvY_7.97tfd61BpJw358sR8E1VXPZsXZTlxTgQpSU59V1rm.XT7M5yrLz5yCyy9uoFikPsBbj9y9Kvq9duyE9sa.6qF0P9AINd7xBeEz1gKQ--
Date: Thu, 4 Oct 2007 11:12:16 +0100 (BST)
From: veerasena reddy <veerasena_b@yahoo.co.in>
Subject: unresoved symbol _gp_disp
To: linux-mips <linux-mips@linux-mips.org>,
       "linux-kernel.org" <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Message-ID: <230962.51223.qm@web8408.mail.in.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

  I am using buildroot to build toolchain (GCC ver
3.4.3, binutil-1.15 and ucLibc-0.9.28, linux-2.6.18
kernel) for MIPS processor with soft float option
enabled.

I have written a loadble module ( which gets complied
along with kernel) which does some floating point
operation.
 
When i try to load the module i get the following
error
"unresoved symbol _gp_disp".
===================================================
below is from MIPS FAQ which also doesn't help:

Insmod complains about the _gp_disp symbol being
undefined
_gp_disp is a magic symbol used with PIC code on MIPS.
Be happy, this error message saved you from crashing
your system. You should use the same compiler options
to compile a kernel module as the kernel makefiles do.
In particular the options -mno-pic -mno-abicalls -G 0
are important.
===================================================
 
In fact i tried with -mno-abicalls -fno-pic  compiler
options still i see the same problem.
 
Could you please give me some pointers on this issue.
BTW, How to compile libgcc.a with "-G 0" options.
In which file of buildroot i shoul added these options
to get effective.
 
Thanks in advance.
 
Regards,
Veerasena.


      Unlimited freedom, unlimited storage. Get it now, on http://help.yahoo.com/l/in/yahoo/mail/yahoomail/tools/tools-08.html/
