Return-Path: <linux-kernel-owner+w=401wt.eu-S1754590AbZFUMYp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754590AbZFUMYp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Jun 2009 08:24:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753424AbZFUMYh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 21 Jun 2009 08:24:37 -0400
Received: from smtprelay01.ispgateway.de ([80.67.31.35]:49878 "EHLO
	smtprelay01.ispgateway.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753335AbZFUMYh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Jun 2009 08:24:37 -0400
References: <20090620170835.GA3295@liondog.tnic> <20090620203846.bbe19d0d.peter@piie.net> <20090621060216.GA25786@liondog.tnic>
Message-ID: <cone.1245587130.876104.5395.1000@onepiie>
X-Mailer: http://www.courier-mta.org/cone/
From: Peter Feuerer <peter@piie.net>
To: Borislav Petkov <petkovbb@googlemail.com>
Cc: Andreas Mohr <andi@lisas.de>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Acer Aspire One fan control, simplified and scrubbed
Date: Sun, 21 Jun 2009 14:25:30 +0200
Mime-Version: 1.0
Content-Type: text/plain; format=flowed; charset="US-ASCII"
Content-Disposition: inline
Content-Transfer-Encoding: 7bit
X-Df-Sender: 404094
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Borislav Petkov writes:

> Hi,
> 
> On Sat, Jun 20, 2009 at 08:38:46PM +0200, Peter Feuerer wrote:
>> You removed the feature of controlling the fan from userspace, while the
>> driver is running in kernelmode=off!
>> ( echo 0 > /sys/class/thermal/thermal_zone0/cdev0/cur_state calls also the
>> acerhdf_set_cur_state function )
> 
> I still don't really see the need for this since the module is doing
> pretty good job already. Besides, its not like there is really a need
> for userspace daemon doing heavy calculations and based on those
> controlls the fan - simply turning it on and off based on the current
> temp readings is what is needed and the thermal layer does that just
> fine already :).

Ok, we'll leave this feature out, as the code is really much cleaner and I 
also doubt that anybody will miss it.

> 
>> --
>> 
>> Acerhdf is a driver for Acer Aspire One netbooks. It allows
>> to access the temperature sensor and to control the fan.
>> 
>> Peter:
>> 
>>  - fixed bios table terminator Version string ( 0 to "" )
>>  - added acerhdf_enable_kernelmode
>>  - modified acerhdf_revert_to_bios_mode to disable polling
>>  - modified acerhdf_get_temp to omit the pr_notice (temperature
>>    should not be printed out in verbose mode, when called from
>>    acerhdf_set_cur_state)
> 
> see below for some minor nitpicking.

I'll fix the things you suggested and send then a (hopefully) last acerhdf 
patch to lkml and linus, ok?

Again, thank you very much! I've really learned a lot from you!

regards,
--peter
