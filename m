Return-Path: <linux-kernel-owner+w=401wt.eu-S933801AbXF2RIX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933801AbXF2RIX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jun 2007 13:08:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755105AbXF2RIO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Jun 2007 13:08:14 -0400
Received: from gateway-1237.mvista.com ([63.81.120.155]:14821 "EHLO
	imap.sh.mvista.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753185AbXF2RIN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jun 2007 13:08:13 -0400
Message-ID: <46853CE3.3050907@ru.mvista.com>
Date: Fri, 29 Jun 2007 21:09:55 +0400
From: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Organization: MontaVista Software Inc.
User-Agent: Mozilla/5.0 (X11; U; Linux i686; rv:1.7.2) Gecko/20040803
X-Accept-Language: ru, en-us, en-gb
MIME-Version: 1.0
To: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, linux-ide@vger.kernel.org,
       David Chinner <dgc@sgi.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [1/2] 2.6.22-rc6: known regressions v2
References: <46852187.3080504@googlemail.com>
In-Reply-To: <46852187.3080504@googlemail.com>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

Michal Piotrowski wrote:

> IDE

> Subject    : 2.6.22-rcX: hda: lost interrupt
> References : http://lkml.org/lkml/2007/6/29/121
> Submitter  : David Chinner <dgc@sgi.com>
> Status     : unknown

> Probing IDE interface ide0...
> hda: probing with STATUS(0xa0) instead of ALTSTATUS(0x58)

   Ugh, 0xa0 is the device/head register's value, not the status register's!
I'd suppose that I/O space was borken in some funny way, however, it would be 
hard top expect form x86 which should be prone to endiannes blues...

MBR, Sergei
