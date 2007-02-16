Return-Path: <linux-kernel-owner+w=401wt.eu-S932367AbXBPO2m@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932367AbXBPO2m (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Feb 2007 09:28:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932368AbXBPO2l
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Feb 2007 09:28:41 -0500
Received: from cacti.profiwh.com ([85.93.165.66]:42813 "EHLO cacti.profiwh.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932367AbXBPO2l (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Feb 2007 09:28:41 -0500
Message-ID: <45D5BF9E.4030903@gmail.com>
Date: Fri, 16 Feb 2007 15:28:46 +0100
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Thunderbird 2.0b2 (X11/20070116)
MIME-Version: 1.0
To: Mockern@yandex.ru
Cc: linux-kernel@vger.kernel.org
Subject: Re: bloc_til_ready in tty driver
References: <45D5A1E0.000004.21866@tide.yandex.ru> <45D5A7FE.7010309@gmail.com> <45D5B600.000007.30983@camay.yandex.ru>
In-Reply-To: <45D5B600.000007.30983@camay.yandex.ru>
Content-Type: text/plain; charset=KOI8-R; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Mockern napsal(a):
> Thanx for your respond,
> 
> I did not implement this function in my tty driver.
> 
> Does it help to work my driver with cat Linux operation?
> (e.g. cat < ttyS10)

Help in which way? If you haven't implemented it, it'll behave like there was 
O_NONBLOCK passed to open() call or TIOCSSOFTCAR ioctl with nonzero param was 
invoked.

regards,
-- 
http://www.fi.muni.cz/~xslaby/            Jiri Slaby
faculty of informatics, masaryk university, brno, cz
e-mail: jirislaby gmail com, gpg pubkey fingerprint:
B674 9967 0407 CE62 ACC8  22A0 32CC 55C3 39D4 7A7E
