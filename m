Return-Path: <linux-kernel-owner+w=401wt.eu-S1755419AbYKZUld@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755419AbYKZUld (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2008 15:41:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752960AbYKZUlW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Nov 2008 15:41:22 -0500
Received: from gw.goop.org ([64.81.55.164]:47344 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753034AbYKZUlW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2008 15:41:22 -0500
Message-ID: <492DB46D.9000105@goop.org>
Date: Wed, 26 Nov 2008 12:41:17 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.18 (X11/20081119)
MIME-Version: 1.0
To: Greg KH <greg@kroah.com>
CC: Ian Campbell <ijc@hellion.org.uk>,
       =?ISO-8859-1?Q?Daniel_Schr=F6der?= <mail@dschroeder.info>,
       Ingo Molnar <mingo@elte.hu>, Yinghai Lu <yinghai@kernel.org>,
       Stable Kernel <stable@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [stable] Change 5c371b31be3203 in stable breaks Xen
References: <492C6D8D.3040600@goop.org> <1227654364.27529.3.camel@localhost.localdomain> <492C897E.1010509@goop.org> <20081126000340.GB1091@kroah.com>
In-Reply-To: <20081126000340.GB1091@kroah.com>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greg KH wrote:
>> Ah, yes, that looks like the right fix.  I'll see if it helps.
>>     
>
> If so, let us know and we will add it to the next -stable release.

Yep.  Cherry-picking 5dc64a3442b98eaa0e3730c35fcf00cf962a93e7 onto 
2.6.27.7 fixes the bug.

Thanks,
    J

