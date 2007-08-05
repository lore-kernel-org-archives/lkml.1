Return-Path: <linux-kernel-owner+w=401wt.eu-S1759564AbXHETtc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759564AbXHETtc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Aug 2007 15:49:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757008AbXHETtZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 5 Aug 2007 15:49:25 -0400
Received: from nf-out-0910.google.com ([64.233.182.185]:50231 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756991AbXHETtZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Aug 2007 15:49:25 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding:from;
        b=CeR5ztdzdzaRyCtn27vcPXSGwbYjNd7lvbhn6jPTC8rtN56iALr3KSyO0GPPAP3KvZY9Y/4ZKuGWKfWBV6A6ldQlZ3qGwtNUAYMC5IWpZ8ofmP1CJ0+eXz40QkL+FP5jfwgtTOtQ6i5zM7pu9CHk4zZnr7XHEzsGMRWpVwlgbBs=
Message-ID: <46B6297C.900@googlemail.com>
Date: Sun, 05 Aug 2007 21:48:12 +0200
User-Agent: Thunderbird 2.0.0.5 (X11/20070719)
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       linux-pm@lists.linux-foundation.org, Pavel Machek <pavel@ucw.cz>,
       Meelis Roos <mroos@linux.ee>
Subject: Re: [2/3] 2.6.23-rc2: known regressions
References: <46B5F74D.7010708@googlemail.com> <46B5FA32.50208@googlemail.com> <200708051858.12404.rjw@sisk.pl>
In-Reply-To: <200708051858.12404.rjw@sisk.pl>
X-Enigmail-Version: 0.95.3
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
From: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Rafael J. Wysocki pisze:
> On Sunday, 5 August 2007 18:26, Michal Piotrowski wrote:
>> Hi all,
>>
>> Here is a list of some known regressions in 2.6.23-rc2.
>>
>> Feel free to add new regressions/remove fixed etc.
>> http://kernelnewbies.org/known_regressions
>>
>  
>> Power management
>>
>> Subject         : Kconfig: 'SUSPEND_SMP' refers to undefined symbol 'HOTPLUG_CPU'
>> References      : http://lkml.org/lkml/2007/8/4/39
>> Last known good : ?
>> Submitter       : Meelis Roos <mroos@linux.ee>
>> Caused-By       : ?
>> Handled-By      : Rafael J. Wysocki <rjw@sisk.pl>
>> Status          : unknown
> 
> Is being debugged.
> 
> Frankly, I don't know what to think about that.  With the Meelis' .config
> SUSPEND_SMP can't even be set ...

Meelis, have you used a "make randconfig" without "make oldconfig"?

Regards,
Michal

-- 
LOG
http://www.stardust.webpages.pl/log/
