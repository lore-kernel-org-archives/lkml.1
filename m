Return-Path: <linux-kernel-owner+w=401wt.eu-S1946705AbXBQNFQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946705AbXBQNFQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Feb 2007 08:05:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946707AbXBQNFQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Feb 2007 08:05:16 -0500
Received: from soapbox.mail.yandex.net ([213.180.223.94]:53363 "EHLO
	soapbox.mail.yandex.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1946705AbXBQNFO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Feb 2007 08:05:14 -0500
Date: Sat, 17 Feb 2007 16:05:03 +0300 (MSK)
From: "Mockern" <Mockern@yandex.ru>
Message-Id: <45D6FD7F.000001.17083@soapbox.yandex.ru>
MIME-Version: 1.0
X-Mailer: Yamail [ http://yandex.ru ]
To: jirislaby@gmail.com
Cc: linux-kernel@vger.kernel.org
Subject: Re: Linux tty driver question
X-MsgDayCount: 4
X-BornDate: 1134853200
In-Reply-To: <45D6FB5F.8000108@gmail.com>
Reply-To: Mockern@yandex.ru
References: <45D6D3A3.000001.04520@tide.yandex.ru> <45D6E094.8030006@gmail.com> <45D6E6B7.000003.09194@mfront8.yandex.ru> <45D6FB5F.8000108@gmail.com>
X-Source-Ip: 84.185.244.133
Content-Type: text/plain;
  charset="KOI8-R"
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

The problem is (probably???) that I did not implement ready_til_block
in my driver. 

OK, thank you, i need to investigate it with strace.
 
>Mockern napsal(a):
>> Thank you, 
>> 
>> I have no problem with my tty driver, except one thing: it does not work with cat (but there are no problems to write,read from user space application). I'll try to follow your adwise to support cat. 
>
>And where does it stuck? use ptrace (e.g. strace) to investigate.
>
>regards,

-- 
Яндекс.Почта: объем почтового ящика не ограничен! http://mail.yandex.ru/monitoring/
