Return-Path: <linux-kernel-owner+w=401wt.eu-S1761422AbYEGSPO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761422AbYEGSPO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2008 14:15:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765400AbYEGSOu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 May 2008 14:14:50 -0400
Received: from web32607.mail.mud.yahoo.com ([68.142.207.234]:24448 "HELO
	web32607.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754335AbYEGSOs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2008 14:14:48 -0400
X-YMail-OSG: Eq1A9kkVM1l1_Q4lg2SyJFksgfEP.2kL2VsbgGo8mTRznJUZCPVDvM1H8a8GG1RDYrjE14z61GbewIQXduy5HEWViJ6cGDOqjw--
X-Mailer: YahooMailRC/975.23 YahooMailWebService/0.7.185
Date: Wed, 7 May 2008 11:14:47 -0700 (PDT)
From: Martin Knoblauch <spamtrap@knobisoft.de>
Subject: Re: 2.6.25.2 - Jiffies/Time jumping back and forth (Regereesion from 2.6.24)
To: john stultz <johnstul@us.ibm.com>
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <572961.18046.qm@web32607.mail.mud.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

----- Original Message ----

> From: john stultz <johnstul@us.ibm.com>
> To: Martin Knoblauch <spamtrap@knobisoft.de>
> Cc: linux-kernel@vger.kernel.org
> Sent: Wednesday, May 7, 2008 7:07:49 PM
> Subject: Re: 2.6.25.2 - Jiffies/Time jumping back and forth (Regereesion from 2.6.24)
> 
> On Wed, May 7, 2008 at 5:42 AM, Martin Knoblauch wrote:
> > Hi,
> >
> >   any news on the one below? I upgraded to 2.6.25.2 and the problem still 
> persists. Would adding a bugzilla actually help ? :-)
> >
> >
> >  http://www.ussg.iu.edu/hypermail/linux/kernel/0804.2/1144.html
> 
> With this issue you're seeing is only the printk timestamps jumping
> back, correct?
>

 correct.

> For example, you're not seeing the output from gettimeofday() or the
> actual jiffies value (as seen from maybe a driver) jump backward? Is
> that right?
> 

 correct again. As far as I can see, other time related things seem to be OK, including gettimeofday.

> The printk timestamps may jump around a bit at bootup,  especially if
> you have unsynced TSCs, so that is a known issue. However its not
> known to have any actual negative effect other then maybe causing the
> dmesg log to be a bit confusing.
> 

 the problem, is not just at bootup and the jumping. During the *complete* lifetime of the kernel I see:

a) the dmesg timestamps jumping back and forth
b) the values are much to small and have absolutely no relation to "seconds after bootup", as they have with 2.6.24 and before.

 But you are right, it might not be a jiffie problem, but a "dmesg timestamp" thing.

Cheers
Martin

