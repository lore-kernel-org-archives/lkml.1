Return-Path: <linux-kernel-owner+w=401wt.eu-S1761627AbYETQbG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761627AbYETQbG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2008 12:31:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933324AbYETQam
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 May 2008 12:30:42 -0400
Received: from smtp.innovsys.com ([66.115.232.196]:21804 "EHLO
	mail.innovsys.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758411AbYETQal convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2008 12:30:41 -0400
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: Oops in fs_enet driver with preempt-rt
Date: Tue, 20 May 2008 11:31:08 -0500
Message-ID: <DCEAAC0833DD314AB0B58112AD99B93B046E73EC@ismail.innsys.innovsys.com>
In-Reply-To: <4832FA80.7060807@freescale.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: Oops in fs_enet driver with preempt-rt
Thread-Index: Aci6lW5AW7RiPnxXRY24USEpaj5ZVQAAVO7g
References: <DCEAAC0833DD314AB0B58112AD99B93B046E728C@ismail.innsys.innovsys.com> <DCEAAC0833DD314AB0B58112AD99B93B046E72C3@ismail.innsys.innovsys.com> <4832F139.1020502@freescale.com> <DCEAAC0833DD314AB0B58112AD99B93B046E73C6@ismail.innsys.innovsys.com> <4832FA80.7060807@freescale.com>
From: "Rune Torgersen" <runet@innovsys.com>
To: "Scott Wood" <scottwood@freescale.com>
Cc: <linux-kernel@vger.kernel.org>, <linuxppc-dev@ozlabs.org>,
       <netdev@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Scott Wood wrote:
> Rune Torgersen wrote:
>> Hmm.... ttyCPM1 output seems to be kinda garbled... Any ideas?
>> Incomplete locking between printk and userland use of ttyCPM1 as
>> console?
> 
> s/incomplete/nonexistent/ :-P
> 
> Try acquiring port->lock in cpm_uart_console_write.
> 
> -Scott

That worked. Console output is sane again.
