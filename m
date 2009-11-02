Return-Path: <linux-kernel-owner+w=401wt.eu-S1754491AbZKBLLX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754491AbZKBLLX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Nov 2009 06:11:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754385AbZKBLLX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Nov 2009 06:11:23 -0500
Received: from smtprelay02.ispgateway.de ([80.67.31.36]:40207 "EHLO
	smtprelay02.ispgateway.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754358AbZKBLLW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Nov 2009 06:11:22 -0500
X-Greylist: delayed 562 seconds by postgrey-1.27 at vger.kernel.org; Mon, 02 Nov 2009 06:11:22 EST
References: <20091019102116.222ff9c3.peter@piie.net> <9ea470500910191151j370cec68w67ee8e31f42f3303@mail.gmail.com> <cone.1255986667.852662.3188.1000@deskpiie> <20091020072752.GA9326@liondog.tnic>
Message-ID: <cone.1257159721.959115.3271.1000@onepiie>
X-Mailer: http://www.courier-mta.org/cone/
From: Peter Feuerer <pfe@piie.net>
To: Borislav Petkov <petkovbb@googlemail.com>
Cc: Borislav Petkov <petkovbb@gmail.com>, linux-kernel@vger.kernel.org,
       Andreas Mohr <andi@lisas.de>
Subject: Re: [Patch] acerhdf: Return temperature in milidegree
Date: Mon, 02 Nov 2009 12:02:01 +0100
Mime-Version: 1.0
Content-Type: text/plain; format=flowed; charset="US-ASCII"
Content-Disposition: inline
Content-Transfer-Encoding: 7bit
X-Df-Sender: 404094
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Boris,

Borislav Petkov writes:

> On Mon, Oct 19, 2009 at 11:11:07PM +0200, Peter Feuerer wrote:
>> I just had a look at the documentation concerning this topic:
>> 
>> Documentation/thermal/sysfs-api.txt:162
>> 
>> temp           Current temperature as reported by thermal zone (sensor)
>>            Unit: millidegree Celsius
>>            RO
>>            Required
>> 
>> 
>> It is expected to be in millidegree, so I think we should discuss,
>> modify and apply the patch.
> 
> Well well, looka here, it is an interface! I guess the temperature has
> to be in millidegrees for better granularity or similar. Now userspace
> has to do temp / 1000.0 and so on.

This is what the userspace applications like thermal-plugin of xfce-panel 
do.

> 
> In that case, the patch should be applied. I'll give it a run later.

Did you already give it a try?

> 
> Minor nitpick: Add the sysfs-api requirement to the commit message
> instead of "userspace applications."

will change this, when submitting the patch to Andrew.

kind regards,
--peter
