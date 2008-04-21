Return-Path: <linux-kernel-owner+w=401wt.eu-S1762785AbYDURgQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762785AbYDURgQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2008 13:36:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753708AbYDURgD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Apr 2008 13:36:03 -0400
Received: from terminus.zytor.com ([198.137.202.10]:56131 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753423AbYDURgB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2008 13:36:01 -0400
Message-ID: <480CCEB0.8040401@zytor.com>
Date: Mon, 21 Apr 2008 13:28:16 -0400
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: Pavel Machek <pavel@ucw.cz>
CC: Mathieu Desnoyers <compudj@krystal.dyndns.org>, mingo@elte.hu,
       akpm@osdl.org, Jeremy Fitzhardinge <jeremy@goop.org>,
       Steven Rostedt <rostedt@goodmis.org>,
       "Frank Ch. Eigler" <fche@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH] x86 NMI-safe INT3 and Page Fault (v5)
References: <20080417165839.GA25198@Krystal> <20080417165944.GB25198@Krystal> <20080417201410.GB31616@Krystal> <20080421140054.GB4685@ucw.cz> <480CA337.3090709@zytor.com> <20080421150825.GA4070@Krystal> <480CADD3.3010209@zytor.com> <20080421154756.GA2424@Krystal> <20080421172327.GA32278@elf.ucw.cz>
In-Reply-To: <20080421172327.GA32278@elf.ucw.cz>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pavel Machek wrote:
> 
>> There is also the page fault case. I think putting this test in
>> ret_from_exception would be both safe (it is executed for any
>> exception return) and fast (exceptions are rare).
> 
> Eh? I thought that page fault is one of the hottest paths in kernel
> (along with syscall and packet receive/send)...
> 								Pavel

Yeah, and the concept of handling page faults inside an NMI handler is 
pure fantasy.

	-hpa
