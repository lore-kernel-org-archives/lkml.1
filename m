Return-Path: <linux-kernel-owner+w=401wt.eu-S1753855AbYLNC7y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753855AbYLNC7y (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Dec 2008 21:59:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752139AbYLNC7q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 13 Dec 2008 21:59:46 -0500
Received: from rv-out-0506.google.com ([209.85.198.237]:58696 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751087AbYLNC7p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Dec 2008 21:59:45 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=s4wu2AUsgr06cEhIDwOkGPq9ZiuD7YPU4UDrBkhbgy2xEABRnTqhVCuo/EDYDPuHC5
         xyPWw0ZOedybXq5L1ViHd5cQ0lFECFT88rKSh2EtpYPqECq5D+0QDpok1uUdnJUyxBRT
         wSsMBpBCh2oA5SRuTS5O0t3Uwo8DmEOBm1uqQ=
Message-ID: <41d311580812131859k41f1693lac4872773befe15d@mail.gmail.com>
Date: Sun, 14 Dec 2008 10:59:44 +0800
From: "pl ice" <telent997@gmail.com>
To: "Zwane Mwaikambo" <zwane@infradead.org>
Subject: Re: when interrupt came, the kernel save pt_regs->eip always the same?
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <alpine.DEB.2.00.0812130854380.28394@montezuma.windriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <41d311580812130732u58f480ecgc21cb6f16365d45a@mail.gmail.com>
	 <41d311580812130740k6e0c139kacb5bad33b5b8fd4@mail.gmail.com>
	 <41d311580812130748o262fdb31se647e840977d90a9@mail.gmail.com>
	 <alpine.DEB.2.00.0812130854380.28394@montezuma.windriver.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

And the prototype about irq_handler changed, the 3th parameter "struct
pt_regs" removed,How do i get the struct pt_regs in my interrupt
handler because kernel doesn't deliver to me?

2008/12/14 Zwane Mwaikambo <zwane@infradead.org>:
> On Sat, 13 Dec 2008, pl ice wrote:
>
>> HI,
>>     These day i wanted get cpu context ,when interrupt came.BUT i
>> found when interrupt came kernel saved cpu context in struct pt_regs
>> and delivered to do_IRQ ,and i print the pt_regs->eip,they alway same
>> on the same interrupt?
>>      The interrupt can come anytime,i think the eip will be very
>> different every time.BUT i debug kernel ,print eip in the function
>> do_IRQ,found it didn't run as i thought.Can anybody tell me why?
>
> If the cpu is idle, you have a higher probability that the idle function
> is in regs->eip
>
>        Zwane
>
