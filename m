Return-Path: <linux-kernel-owner+w=401wt.eu-S1756378AbZBFOhA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756378AbZBFOhA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Feb 2009 09:37:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752980AbZBFOgw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Feb 2009 09:36:52 -0500
Received: from web52711.mail.re2.yahoo.com ([206.190.48.234]:23371 "HELO
	web52711.mail.re2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752301AbZBFOgw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Feb 2009 09:36:52 -0500
X-Greylist: delayed 399 seconds by postgrey-1.27 at vger.kernel.org; Fri, 06 Feb 2009 09:36:51 EST
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=X-YMail-OSG:Received:X-Mailer:Date:From:Subject:To:MIME-Version:Content-Type:Message-ID;
  b=3ZZ0GqlxcdBVGFj2i0VtRN1mi+necDrSgPyqtlO23Et8UVM0j8ZcPSWzQteDtUp6NHBShJyqbJ5qvlzeiQW7f4TYmumO7gxVew9R3KLRSGEYf6SjXVITnLt5ZGpGECl61mjNGJwpy2QWCRxFA96TJWSjx9deCrkcsJyCZB33jPw=;
X-YMail-OSG: MTmXNh4VM1m794Kpdh7ZL4252ly_NcLnCxsqGhhMbHZyXsbZUnnX8PY6xnA6ctc4TMpgqEQfvqTxF_rJhQCatp0WjgD4WHiD6dTwzW70oMpE5IhwhwQ9mpnXtIAsI6wc569gC9_iEcvyHv_lbv9GB6PWkJ61FfW06t5ENZvnDgVyWQ4AWCFxpuC86IX9
X-Mailer: YahooMailRC/1155.45 YahooMailWebService/0.7.260.1
Date: Fri, 6 Feb 2009 06:30:10 -0800 (PST)
From: Cagri Balkesen <cagribal@yahoo.com>
Subject: gettimeofday() - execution time and underlying implementation details
To: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <917718.10096.qm@web52711.mail.re2.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear all,

I have a question regarding gettimeofday() function on Linux. I wrote a simple benchmark to understand the execution time of gettimeofday() function. I used ACE High Resolution Timer library to measure the timings (which in fact uses rdtsc instruction). My measurements claim that it takes 1.7 usecs as median and 1.8 usecs as mean value. Which is quite big for the scenario that I'm planning to use gettimeofday(). What I want to learn is whether it is doing a system call or reading the value out of a shared mapping in my system? Also I wonder what timer hardware does linux use for gettimeofday. Also I'm getting kernel timestamped datagrams from network layer (using SO_TIMESTAMP option on the socket), so another question is, does it also take around the same time when kernel receives the packets from the network and timestamps them with gettimeofday()?

Here is information about my system: Linux Red Hat 2.6.18-128.el5 #1 SMP x86_64 GNU/Linux

I'd be grateful to anyone who might share knowledge on this issue.

Thanks,

Cagri

p.s. I hope this is an appropriate message for this mailing list.



      
