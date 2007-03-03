Return-Path: <linux-kernel-owner+w=401wt.eu-S1030275AbXCCObn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030275AbXCCObn (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Mar 2007 09:31:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030278AbXCCObn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Mar 2007 09:31:43 -0500
Received: from cacti.profiwh.com ([85.93.165.66]:44228 "EHLO cacti.profiwh.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030275AbXCCObn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Mar 2007 09:31:43 -0500
Message-ID: <45E986E2.3010203@gmail.com>
Date: Sat, 03 Mar 2007 15:32:02 +0100
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Thunderbird 2.0b2 (X11/20070116)
MIME-Version: 1.0
To: Mockern@yandex.ru
Cc: linux-kernel@vger.kernel.org
Subject: Re: Question: 20 microseconds  delay
References: <45E98415.000002.30135@webmail9.yandex.ru>
In-Reply-To: <45E98415.000002.30135@webmail9.yandex.ru>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Mockern napsal(a):
> Hi,
> 
> I have a question.
> 
> I need to use 20 microsecond delay in my driver.
> What exact jiffies value I should define to get 20 microseconds?

It's subjiffy delay unless you use 50000 HZ :). Use udelay.

regards,
-- 
http://www.fi.muni.cz/~xslaby/            Jiri Slaby
faculty of informatics, masaryk university, brno, cz
e-mail: jirislaby gmail com, gpg pubkey fingerprint:
B674 9967 0407 CE62 ACC8  22A0 32CC 55C3 39D4 7A7E

Hnus <hnus@fi.muni.cz> is an alias for /dev/null
