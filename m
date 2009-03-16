Return-Path: <linux-kernel-owner+w=401wt.eu-S1758058AbZCPQEU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758058AbZCPQEU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Mar 2009 12:04:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752924AbZCPQEI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Mar 2009 12:04:08 -0400
Received: from minas.ics.muni.cz ([147.251.4.40]:47594 "EHLO minas.ics.muni.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754857AbZCPQEH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Mar 2009 12:04:07 -0400
Date: Mon, 16 Mar 2009 17:03:57 +0100
From: Jan Kasprzak <kas@fi.muni.cz>
To: Jiri Slaby <jirislaby@gmail.com>
Cc: linux-kernel@vger.kernel.org, alan@lxorguk.ukuu.org.uk
Subject: Re: [PATCH] drivers/char/mxser.c: Fix reference counting
Message-ID: <20090316160357.GZ7301@fi.muni.cz>
References: <20090316154817.GX7301@fi.muni.cz> <49BE77E7.5030107@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <49BE77E7.5030107@gmail.com>
User-Agent: Mutt/1.4.2.2i
X-Muni-Spam-TestIP: 147.251.48.3
X-Muni-Envelope-From: kas@fi.muni.cz
X-Muni-Virus-Test: Clean
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (minas.ics.muni.cz [147.251.4.35]); Mon, 16 Mar 2009 17:03:59 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jiri Slaby wrote:
: On 16.3.2009 16:48, Jan Kasprzak wrote:
: >In drivers/char/mxser.c:mxser_check_modem_status() there is a call
: >to tty_port_tty_get without a corresponding tty_put() call. This causes
: >the device to return -EIO on the second open(2) call.
: 
: I was faster :P:
: http://lkml.org/lkml/2009/3/16/159

	OK, sorry for not checking out lkml first :-)

-Yenya

-- 
| Jan "Yenya" Kasprzak  <kas at {fi.muni.cz - work | yenya.net - private}> |
| GPG: ID 1024/D3498839      Fingerprint 0D99A7FB206605D7 8B35FCDE05B18A5E |
| http://www.fi.muni.cz/~kas/    Journal: http://www.fi.muni.cz/~kas/blog/ |
>>  If you find yourself arguing with Alan Cox, you’re _probably_ wrong.  <<
>>     --James Morris in "How and Why You Should Become a Kernel Hacker"  <<
