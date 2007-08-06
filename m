Return-Path: <linux-kernel-owner+w=401wt.eu-S934064AbXHFXin@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934064AbXHFXin (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2007 19:38:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933201AbXHFXie
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Aug 2007 19:38:34 -0400
Received: from smtpq2.tilbu1.nb.home.nl ([213.51.146.201]:47463 "EHLO
	smtpq2.tilbu1.nb.home.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933197AbXHFXid (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2007 19:38:33 -0400
Message-ID: <46B7B045.5070607@gmail.com>
Date: Tue, 07 Aug 2007 01:35:33 +0200
From: Rene Herman <rene.herman@gmail.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070728)
MIME-Version: 1.0
To: Mitchell Erblich <erblichs@earthlink.net>
CC: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       "T. J. Brumfield" <enderandrew@gmail.com>
Subject: Re: about modularization
References: <000b01c7d873$76ce03c0$6501a8c0@earthlink.net>
In-Reply-To: <000b01c7d873$76ce03c0$6501a8c0@earthlink.net>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
X-AtHome-MailScanner-Information: Please contact support@home.nl for more information
X-AtHome-MailScanner: Found to be clean
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/06/2007 11:48 PM, Mitchell Erblich wrote:

> Of the uni-processor systems currently that can run Linux, I would not 
> doubt if 99.9999% percent are uni-cores.

s/can// and I would. s/uni-processor// additionally and I'd assure you it's 
untrue. s/uni-cores/non-smt uni-cores/ and I'd do the same.

> It will be probably 3-5 years minimum before the multi-core processors
> will have any decent percentage of systems.

Which is also approximately the same timeframe in which one might consider 
currently developped kernels obsolete for deployment by the way...

> And I am not suggesting not supporting them. I am only suggesting is wrt
> the schedular, bring the system up with a default schedular, and then
> load additional functionality based on the hardware/software requirements
> of the system.

But why? First, look at the number of #ifdef CONFIG_SMP in the scheduler 
code -- the Linux kernel already has seperate UP/SMP schedulers selected 
through CONFIG_SMP. Embedded can certainly use its own !CONFIG_SMP kernels, 
for Linux servers SMP is the norm today and for the desktop/home, SMP 
probably already _also_ is the norm today, what with multi-core and HT 
(which needs different things than real SMP does, but is also certainly not 
UP). And if it isn't, it will be tomorrow and stay that way for the 
forseeable future.

[ snip ]

> IMO, if their is a fault (because of heat, etc) the user would rather 
> bring up the system in a degraded mode. Same reason applies to... boot
> -s..

To what? I don't understand this comment. You are optimizing for the case of 
a dead CPU? Why would the user care if he'd be running the most optimal 
scheduler for the situation when his box is limping along anyway?

Rene.

