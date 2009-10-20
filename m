Return-Path: <linux-kernel-owner+w=401wt.eu-S1752622AbZJTWr5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752622AbZJTWr5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Oct 2009 18:47:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751591AbZJTWr4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Oct 2009 18:47:56 -0400
Received: from smtp2.caviumnetworks.com ([209.113.159.134]:9323 "EHLO
	smtp2.caviumnetworks.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751319AbZJTWr4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Oct 2009 18:47:56 -0400
Message-ID: <4ADE3D3C.1070608@caviumnetworks.com>
Date: Tue, 20 Oct 2009 15:44:12 -0700
From: David Daney <ddaney@caviumnetworks.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Linus Walleij <linus.ml.walleij@gmail.com>
CC: Thomas Gleixner <tglx@linutronix.de>,
       Linus Walleij <linus.walleij@stericsson.com>,
       linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
       linux-mips@linux-mips.org, Mikael Pettersson <mikpe@it.uu.se>,
       Ralf Baechle <ralf@linux-mips.org>
Subject: Re: [PATCH] Make MIPS dynamic clocksource/clockevent clock code 
 generic
References: <1255819715-19763-1-git-send-email-linus.walleij@stericsson.com>	 <alpine.LFD.2.00.0910200454300.2863@localhost.localdomain>	 <4ADE3225.5050001@caviumnetworks.com> <63386a3d0910201516r71100657y92e3e6c2fab38db9@mail.gmail.com>
In-Reply-To: <63386a3d0910201516r71100657y92e3e6c2fab38db9@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 20 Oct 2009 22:44:12.0399 (UTC) FILETIME=[D81B27F0:01CA51D6]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Walleij wrote:
> 2009/10/20 David Daney <ddaney@caviumnetworks.com>:
> 
>>> Please do not make that functions inline. They are too large and there
>>> is no benefit of inlining them.
>> If that is the case, then perhaps they should not be defined in a header
>> file.
> 
> Of course not. There are apropriate places to put them, but as stated
> I think the use as it is today warrants having them inlined.
> 

I wasn't trying to imply that they shouldn't be inlined, only that if 
you  choose (as you did) to define them in a header file, that they 
*should* be inline.

David Daney
