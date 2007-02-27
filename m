Return-Path: <linux-kernel-owner+w=401wt.eu-S1161114AbXB0JqY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161114AbXB0JqY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Feb 2007 04:46:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161120AbXB0JqY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Feb 2007 04:46:24 -0500
Received: from cacti.profiwh.com ([85.93.165.66]:38434 "EHLO cacti.profiwh.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161114AbXB0JqY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Feb 2007 04:46:24 -0500
Message-ID: <45E3FDF0.6070206@gmail.com>
Date: Tue, 27 Feb 2007 10:46:24 +0100
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Thunderbird 2.0b2 (X11/20070116)
MIME-Version: 1.0
To: Mockern@yandex.ru
Cc: linux-kernel@vger.kernel.org
Subject: Re: Linux tty driver question
References: <45D6D3A3.000001.04520@tide.yandex.ru> <45D6E094.8030006@gmail.com> <45D6E6B7.000003.09194@mfront8.yandex.ru>
In-Reply-To: <45D6E6B7.000003.09194@mfront8.yandex.ru>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Mockern napsal(a):
> Thank you, 
> 
> I have no problem with my tty driver, except one thing: it does not work with cat (but there are no problems to write,read from user space application). I'll try to follow your adwise to support cat. 

But the read *works* according to the strace output, which you've post in the 
another thread. Just don't send garbage to the discipline, send some chars.

regards,
-- 
http://www.fi.muni.cz/~xslaby/            Jiri Slaby
faculty of informatics, masaryk university, brno, cz
e-mail: jirislaby gmail com, gpg pubkey fingerprint:
B674 9967 0407 CE62 ACC8  22A0 32CC 55C3 39D4 7A7E
