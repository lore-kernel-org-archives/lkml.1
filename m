Return-Path: <linux-kernel-owner+w=401wt.eu-S932768AbXHFWwe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932768AbXHFWwe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2007 18:52:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763112AbXHFWwY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Aug 2007 18:52:24 -0400
Received: from smtp102.sbc.mail.re2.yahoo.com ([68.142.229.103]:24306 "HELO
	smtp102.sbc.mail.re2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1761867AbXHFWwW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2007 18:52:22 -0400
X-Greylist: delayed 396 seconds by postgrey-1.27 at vger.kernel.org; Mon, 06 Aug 2007 18:52:22 EDT
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=sbcglobal.net;
  h=Received:X-YMail-OSG:Mime-Version:Content-Type:Message-Id:Cc:Content-Transfer-Encoding:From:Subject:Date:To:X-Mailer;
  b=piU05yk8ih2NNcBU9woND9jFs1uqfuvFrfii8uNtaMVz37dZ8GMbV/FdUQri2zeVHStfVdkvpzOW9UgNfS4xUI4uNeOluyRNyBrtsnaU0d8zTQNGIaffLiX5ZAiB9AvumL1gpiZl5j58r8itQUBN/8KaAA70GOEtYavqNmXY3wY=  ;
X-YMail-OSG: 93go8o0VM1l7hbRJGmtI_D2u.AueoupBDPr8JflDSsVCw7vMdQHkzdTIz_IWfjFjQhgocHpjLbG96cujlbnPjYiz3jMNtjmz3D6mLI8Bo9M5Fg--
Mime-Version: 1.0 (Apple Message framework v752.2)
Content-Type: text/plain; charset=US-ASCII; delsp=yes; format=flowed
Message-Id: <35B9865F-38B4-4603-A2B7-F4ABACE5520F@sbcglobal.net>
Cc: Linux-kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Transfer-Encoding: 7bit
From: Kevin K <k_krieser@sbcglobal.net>
Subject: sending raw packets via PPP
Date: Mon, 6 Aug 2007 17:45:39 -0500
To: linux-ppp@vger.kernel.org
X-Mailer: Apple Mail (2.752.2)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Is it possible to send raw packets via ppp under Linux?

More specifically, in 2.4 series kernels such as RH's 2.4.21-47 kernel?

I've trying to modify the DHCP 3.0.1 code provided with RH 3 so I can  
send requests via a PPP connection (standard RS-232), and it is just  
being dropped by the stack according to ifconfig and debug statements  
in ppp_generic.c.

Thanks,
Kevin
