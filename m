Return-Path: <linux-kernel-owner+w=401wt.eu-S1758638AbXGCPTq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758638AbXGCPTq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jul 2007 11:19:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754358AbXGCPTj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Jul 2007 11:19:39 -0400
Received: from e3.ny.us.ibm.com ([32.97.182.143]:41195 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753738AbXGCPTj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jul 2007 11:19:39 -0400
Message-ID: <468A690C.4010401@uk.ibm.com>
Date: Tue, 03 Jul 2007 16:19:40 +0100
From: Andy Whitcroft <andyw@uk.ibm.com>
User-Agent: Icedove 1.5.0.9 (X11/20061220)
MIME-Version: 1.0
To: Jan Engelhardt <jengelh@computergmbh.de>
CC: Trilok Soni <soni.trilok@gmail.com>, Andy Whitcroft <APW@uk.ibm.com>,
       linux-kernel@vger.kernel.org
Subject: Re: checkpatch: need space before that '*' (ctx:BxB)
References: <5d5443650706270454v443d1ac7qee6475bc31af844f@mail.gmail.com> <Pine.LNX.4.64.0706271448430.11120@fbirervta.pbzchgretzou.qr>
In-Reply-To: <Pine.LNX.4.64.0706271448430.11120@fbirervta.pbzchgretzou.qr>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jan Engelhardt wrote:
> On Jun 27 2007 17:24, Trilok Soni wrote:
>> In the following case we may not need space before that "(*)". It
>> looks like false positive. Please check.
>>
>> need space before that '*' (ctx:BxB)
>> #1034: FILE: drivers/video/omap/omapfb.c:968:
>> +       omapfb_nb->nb.notifier_call = (int (*)(struct notifier_block *,
>>                                                          ^
> 
> The line, as presented in your mail, is already correct
> Keep the space between "int" and "(*)"  :-)
> [follows how you'd declare a normal variable]
> 
> 
> 	Jan

Yep this was a falsie.  This was fixed in the recent 0.06 release.

-apw
