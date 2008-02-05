Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753566AbYBEMRs (ORCPT <rfc822;ralf@linux-mips.org>);
	Tue, 5 Feb 2008 07:17:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751550AbYBEMRj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Feb 2008 07:17:39 -0500
Received: from n8b.bullet.mail.tp2.yahoo.com ([203.188.202.120]:26321 "HELO
	n8b.bullet.mail.tp2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751519AbYBEMRi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2008 07:17:38 -0500
X-Greylist: delayed 409 seconds by postgrey-1.27 at vger.kernel.org; Tue, 05 Feb 2008 07:17:37 EST
X-Yahoo-Newman-Property: ymail-5
X-Yahoo-Newman-Id: 989743.72786.bm@omp207.mail.sp1.yahoo.com
X-YMail-OSG: 2j8XjRAVM1kUD7xXKPAwycScf4vcZuoX22e35nG9
Date: Tue, 5 Feb 2008 04:10:42 -0800 (PST)
From: am kara <kara_am@yahoo.com>
Subject: kara_am
To: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Message-ID: <747860.31019.qm@web45912.mail.sp1.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Return-Path: <linux-kernel-owner+ralf=40linux-mips.org-S1753566AbYBEMRs@vger.kernel.org>

I am trying to understand IPsec and found some related
subfolders:
crypto, net/key, net/xfrm, net/netlink
and it may be more folders and files involved in the
process.

Would anyone please tell me how is the flow of
network(internet) information(traffic) from a user
process to the deepest layers of the kernel only by
the name of the most important files and folders in
case of IPsec and a typical TCP, IP(and IPsec) and
Ethernet adaptor senario?

For example: 
setkey(shell command)--> ....(some intermediate
processes)-->crypto(setkey method)  

I guess it should be:
net/ipv4-->net/key-->net/xfrm-->crypto
net/ipv4-->net/core-->net/core/dev.c

What is netlink, is it a kind of socket? how does it
become connected to IPsec? 






      ____________________________________________________________________________________
Be a better friend, newshound, and 
know-it-all with Yahoo! Mobile.  Try it now.  http://mobile.yahoo.com/;_ylt=Ahu06i62sR8HDtDypao8Wcj9tAcJ 


