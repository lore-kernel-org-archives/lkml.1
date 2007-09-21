Return-Path: <linux-kernel-owner+w=401wt.eu-S1755299AbXIUHIK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755299AbXIUHIK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2007 03:08:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753428AbXIUHH5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Sep 2007 03:07:57 -0400
Received: from ug-out-1314.google.com ([66.249.92.172]:49792 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753420AbXIUHH4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2007 03:07:56 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=WSi1HB+z1twXbiOVsEJ8wZhD+IXasaEZ+vfayIsduF+OD7WmzCx3JwMw0lAjNs9kLQtTh4XX474NSxY7rr6Ual68/JskUQcE0xKskjrYPiHUNWqCC4ikjnNeqz67RQDHRmzGV7LvVpnh1phJp6HfTqMTW96swRIToN4maj51RyY=
Message-ID: <46F36DC8.6080305@gmail.com>
Date: Fri, 21 Sep 2007 09:07:52 +0200
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070728)
MIME-Version: 1.0
To: Matt Mackall <mpm@selenic.com>
CC: Andi Kleen <andi@firstfloor.org>, Dave Airlie <airlied@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: X-freeze after clflush changes [Was: 2.6.23-rc6-mm1]
References: <20070918011841.2381bd93.akpm@linux-foundation.org> <46F10B69.5070008@gmail.com> <46F10DCB.1090302@gmail.com> <46F13938.1070709@gmail.com> <20070919121017.0cbcbc30.akpm@linux-foundation.org> <20070919192453.GB18707@one.firstfloor.org> <21d7e9970709191842h3111390cl8f09745bed6bd8f9@mail.gmail.com> <20070920220604.GA17536@waste.org> <20070920230304.GJ18707@one.firstfloor.org> <20070920233114.GR4219@waste.org>
In-Reply-To: <20070920233114.GR4219@waste.org>
X-Enigmail-Version: 0.95.3
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/21/2007 01:31 AM, Matt Mackall wrote:
> On Fri, Sep 21, 2007 at 01:03:04AM +0200, Andi Kleen wrote:
>>> It's broken for me.
>>>
>>> 2.6.23-rc3-mm1: solid lock on X shutdown (noticed when upgrading)
>>>       -rc4-mm1: solid lock on X shutdown, random solid locks about
>>>                 once every four hours
>>>       -rc6-mm1: solid lock on X startup
>>>    +your patch: screen goes black, turns off and on a few times during
>>>                 startup, can reboot with sysrq-b
>> Does it work with my simple dumb patch instead of Dave's ? 
> 
> Sorry, forgot to mention: your one-liner flush also doesn't work (same
> behavior).

Just an idea, if you enable LIST_DEBUG, it won't spit anything out after the one
of patches applied, right?

regards,
-- 
Jiri Slaby (jirislaby@gmail.com)
Faculty of Informatics, Masaryk University
