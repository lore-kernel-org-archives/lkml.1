Return-Path: <linux-kernel-owner+w=401wt.eu-S1759839AbYETReq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759839AbYETReq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2008 13:34:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755931AbYETReg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 May 2008 13:34:36 -0400
Received: from gate.crashing.org ([63.228.1.57]:41132 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754583AbYETRef (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2008 13:34:35 -0400
Cc: "Scott Wood" <scottwood@freescale.com>, linuxppc-dev@ozlabs.org,
       linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Message-Id: <998DABA0-38B6-43C3-A788-307AA8D52F17@kernel.crashing.org>
From: Kumar Gala <galak@kernel.crashing.org>
To: "Rune Torgersen" <runet@innovsys.com>
In-Reply-To: <DCEAAC0833DD314AB0B58112AD99B93B046E73EC@ismail.innsys.innovsys.com>
Content-Type: text/plain; charset=US-ASCII; format=flowed
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0 (Apple Message framework v919.2)
Subject: Re: Oops in fs_enet driver with preempt-rt
Date: Tue, 20 May 2008 12:33:31 -0500
References: <DCEAAC0833DD314AB0B58112AD99B93B046E728C@ismail.innsys.innovsys.com> <DCEAAC0833DD314AB0B58112AD99B93B046E72C3@ismail.innsys.innovsys.com> <4832F139.1020502@freescale.com> <DCEAAC0833DD314AB0B58112AD99B93B046E73C6@ismail.innsys.innovsys.com> <4832FA80.7060807@freescale.com> <DCEAAC0833DD314AB0B58112AD99B93B046E73EC@ismail.innsys.innovsys.com>
X-Mailer: Apple Mail (2.919.2)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On May 20, 2008, at 11:31 AM, Rune Torgersen wrote:

> Scott Wood wrote:
>> Rune Torgersen wrote:
>>> Hmm.... ttyCPM1 output seems to be kinda garbled... Any ideas?
>>> Incomplete locking between printk and userland use of ttyCPM1 as
>>> console?
>>
>> s/incomplete/nonexistent/ :-P
>>
>> Try acquiring port->lock in cpm_uart_console_write.
>>
>> -Scott
>
> That worked. Console output is sane again.

I'm hoping to see some patches related to these fixes :)

- k
