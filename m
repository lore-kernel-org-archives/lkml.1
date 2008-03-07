Return-Path: <linux-kernel-owner+w=401wt.eu-S1759860AbYCGPPW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759860AbYCGPPW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2008 10:15:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754324AbYCGPPL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Mar 2008 10:15:11 -0500
Received: from sovereign.computergmbh.de ([85.214.69.204]:37752 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752758AbYCGPPK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2008 10:15:10 -0500
Date: Fri, 7 Mar 2008 16:15:09 +0100 (CET)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: "linux-os (Dick Johnson)" <linux-os@analogic.com>
cc: Marc Perkel <mperkel@yahoo.com>, linux-kernel@vger.kernel.org
Subject: Re: What does a Kernel Error 4 mean?
In-Reply-To: <Pine.LNX.4.61.0803071001280.23974@chaos.analogic.com>
Message-ID: <Pine.LNX.4.64.0803071612150.26142@fbirervta.pbzchgretzou.qr>
References: <521608.73353.qm@web52503.mail.re2.yahoo.com>
 <Pine.LNX.4.64.0803062307170.26142@fbirervta.pbzchgretzou.qr>
 <Pine.LNX.4.61.0803071001280.23974@chaos.analogic.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Mar 7 2008 10:03, linux-os (Dick Johnson) wrote:
>> On Mar 6 2008 13:59, Marc Perkel wrote:
>>>
>>> What does a Kernel Error 4 mean? I'm getting this
>>> running 64 bit Exim. Just trying to track it down and
>>> wondering what an "Error 4" is?
>>
>> Full error message please.
>
>Interrupted system call?

No, there is also

	"%s%s[%d]: segfault at %lx ip %08lx sp %08lx error %lx",

and an error code of 4 indicates PF_USER.
That is why it is *important* to provide an *exact* error message
and not just some hear-and-tell number.
