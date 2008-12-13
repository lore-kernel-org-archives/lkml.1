Return-Path: <linux-kernel-owner+w=401wt.eu-S1751592AbYLMQ4Q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751592AbYLMQ4Q (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Dec 2008 11:56:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750853AbYLMQz7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 13 Dec 2008 11:55:59 -0500
Received: from idcmail-mo1so.shaw.ca ([24.71.223.10]:60340 "EHLO
	idcmail-mo1so.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750834AbYLMQz6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Dec 2008 11:55:58 -0500
X-Cloudmark-SP-Filtered: true
X-Cloudmark-SP-Result: v=1.0 c=0 a=aqAbLLq-Bwo4eiGZH8MA:9 a=QJB4N6rcCAJVedhoF2P0fkj8yeIA:4 a=6Mjz-bRUWdkA:10 a=zZfqtP59WncA:10
Date: Sat, 13 Dec 2008 08:55:55 -0800 (PST)
From: Zwane Mwaikambo <zwane@infradead.org>
To: pl ice <telent997@gmail.com>
cc: linux-kernel@vger.kernel.org
Subject: Re: when interrupt came, the kernel save pt_regs->eip always the
 same?
In-Reply-To: <41d311580812130748o262fdb31se647e840977d90a9@mail.gmail.com>
Message-ID: <alpine.DEB.2.00.0812130854380.28394@montezuma.windriver.com>
References: <41d311580812130732u58f480ecgc21cb6f16365d45a@mail.gmail.com> <41d311580812130740k6e0c139kacb5bad33b5b8fd4@mail.gmail.com> <41d311580812130748o262fdb31se647e840977d90a9@mail.gmail.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 13 Dec 2008, pl ice wrote:

> HI,
>     These day i wanted get cpu context ,when interrupt came.BUT i
> found when interrupt came kernel saved cpu context in struct pt_regs
> and delivered to do_IRQ ,and i print the pt_regs->eip,they alway same
> on the same interrupt?
>      The interrupt can come anytime,i think the eip will be very
> different every time.BUT i debug kernel ,print eip in the function
> do_IRQ,found it didn't run as i thought.Can anybody tell me why?

If the cpu is idle, you have a higher probability that the idle function 
is in regs->eip

	Zwane
