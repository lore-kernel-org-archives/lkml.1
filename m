Return-Path: <linux-kernel-owner+w=401wt.eu-S1755369AbYCYNyA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755369AbYCYNyA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Mar 2008 09:54:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754106AbYCYNxx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Mar 2008 09:53:53 -0400
Received: from n5.bullet.mail.ac4.yahoo.com ([76.13.13.27]:48409 "HELO
	n5.bullet.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754099AbYCYNxx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Mar 2008 09:53:53 -0400
X-Greylist: delayed 359 seconds by postgrey-1.27 at vger.kernel.org; Tue, 25 Mar 2008 09:53:52 EDT
X-Yahoo-Newman-Property: ymail-3
X-Yahoo-Newman-Id: 279881.69596.bm@omp100.mail.mud.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.de;
  h=X-YMail-OSG:Received:Date:From:Subject:To:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-ID;
  b=e2cEBaieI4WZFaJiuN//CuKWyP9AP4Lz+i+aanv/dIRc+pZWT9O01C5sGHiL5IQxlrzvCYTQOkcUYD1zxqYO9SptjNWBAP8E9+tvXlwLOHKkG8JOmvkUHX+E05SYJ1rjbhk4EJjU4if26dALoxWgD5gNH7TCuN1Uym4SzUwEZCk=;
X-YMail-OSG: bsm5ucUVM1mdyUoCGkYETukOjRgML47k8NOaYFccUBYlqq0UqooClQmpvBGej_oPhdUYEw7Q3sxsYJfsq8kljFfWworVNj97ISuJQjOBnQVlSdTs4PWLq8tfEfo-
Date: Tue, 25 Mar 2008 14:47:50 +0100 (CET)
From: Michael Meyer <mike65134@yahoo.de>
Subject: performance differences: "maxcpus=1" vs. "echo 0 > /sys/devices/system/cpu/cpu1/online"
To: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Message-ID: <16336.23884.qm@web25814.mail.ukl.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, 

what is the difference between booting a dual core
machine with "maxcpus=1" or by deactivating the second
core at run time with "echo 0 >
/sys/devices/system/cpu/cpu1/online"?

I observed a funny behaviour of apache ant: although
it uses javac which is single threaded, a compile run
with "maxcpus=1" is actually faster than a compile run
with both cores activated. But with the second core
deactivated using "echo 0 >
/sys/devices/system/cpu/cpu1/online" it is even slower
than with both cores.

Is here any method to get the exact same behaviour of
"maxcpus=1" with disabling the second core only
temporarily? So that the second core could be disabled
before the ant execution and enabled after the ant
execution?

Thanks a lot!


      E-Mails jetzt auf Ihrem Handy.
www.yahoo.de/go

