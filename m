Return-Path: <linux-kernel-owner+w=401wt.eu-S1755417AbXKWIaS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755417AbXKWIaS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Nov 2007 03:30:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752318AbXKWIaG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Nov 2007 03:30:06 -0500
Received: from web51602.mail.re2.yahoo.com ([206.190.38.207]:36256 "HELO
	web51602.mail.re2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752107AbXKWIaF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Nov 2007 03:30:05 -0500
X-Greylist: delayed 401 seconds by postgrey-1.27 at vger.kernel.org; Fri, 23 Nov 2007 03:30:05 EST
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=X-YMail-OSG:Received:Date:From:Subject:To:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-ID;
  b=Gm5/Bh5dD6IzMJOmIJuTdjaVde0kH12q/md5TGTcBoCIjs7zgZQbg88o4FZ7Zb9gFZ/7G+KKF+geWCpqev+O5poTO4VfcqCXO1uYJHKk0qlRSHbYO67W597tU1WFoEShei8Zr+GSLNDfNwxqTyDPWnpSwXnk59MgsyE9Yu1j8bI=;
X-YMail-OSG: 9eAJzZ8VM1kbJhOf88JcNmykmedKio4Au_ScVyCelxhS8Hhwo8e82BctivQCHJC1XbANDIJ1FIxHgOc5y82ozLB7tgKhSOGVXrCZ0KCDI9kYg.90xZ6X8Uyz81eaT5kvy3kHnq8cl5l38q8-
Date: Fri, 23 Nov 2007 00:23:23 -0800 (PST)
From: Durand <titetan@yahoo.com>
Subject: [patch/backport] CFS scheduler, -v24, for v2.6.24-rc3, v2.6.23.8, v2.6.22.13, v2.6.21.7
To: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Message-ID: <248019.51681.qm@web51602.mail.re2.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo,

Just applied this patch to 2.6.22.13 and 2.6.22.14. Compiles and runs fine but
on my laptop, it prevents suspending and hibernating with "one tasks refuses to
freeze" load_balance_mo.

Reverting back to sched-cfs-2.6.22.9-v22 solves this problem. If you need more
details, CC me with a reply as I lurk on the mailing list every 2 days or so.


-- 
Thanks,

Durand



      ____________________________________________________________________________________
Get easy, one-click access to your favorites. 
Make Yahoo! your homepage.
http://www.yahoo.com/r/hs 
