Return-Path: <linux-kernel-owner+w=401wt.eu-S933889AbXG3OGG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933889AbXG3OGG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jul 2007 10:06:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761529AbXG3OFy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jul 2007 10:05:54 -0400
Received: from terminus.zytor.com ([198.137.202.10]:54114 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761226AbXG3OFx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jul 2007 10:05:53 -0400
Message-ID: <46ADF02F.7010800@zytor.com>
Date: Mon, 30 Jul 2007 07:05:35 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.5 (X11/20070719)
MIME-Version: 1.0
To: bbpetkov@yahoo.de
CC: Xudong Guan <xudong.guan@gmail.com>, linux-kernel@vger.kernel.org,
       Chuck Ebbert <cebbert@redhat.com>
Subject: Re: 2.6.23-rc1: no setup signature found...
References: <20070726150854.GA7034@xguan-laptop> <46A8BB6C.6050903@zytor.com> <20070726163053.GA4570@gollum.tnic> <46A8E3F9.5070809@zytor.com> <20070727013615.GC4570@gollum.tnic> <46A9753A.1010206@zytor.com> <20070729085059.GA10758@gollum.tnic> <20070729092402.GA2272@xguan-laptop> <20070729103706.GA16780@gollum.tnic> <46AC9B28.6060906@zytor.com> <20070729191528.GA5166@gollum.tnic>
In-Reply-To: <20070729191528.GA5166@gollum.tnic>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Borislav Petkov wrote:
> Breakpoint 4, 0x00040200 in ?? ()
> 1: x/i ($cs << 4) + $eip  0x40300:      lea    (%si),%dx
> (gdb) p/x $ds
> $1 = 0x18


This isn't the setup code, it's doing something else.

Could you try this again, but when you get to this point, if the 
instruction displayed isn't a "jmp" instruction, and $ds doesn't have 
the right value, enter "c" and see if you hit the proper break later.

Sorry,

	-hpa
