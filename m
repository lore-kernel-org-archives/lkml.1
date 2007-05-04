Return-Path: <linux-kernel-owner+w=401wt.eu-S1753075AbXEDLTB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753075AbXEDLTB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 May 2007 07:19:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753250AbXEDLTB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 May 2007 07:19:01 -0400
Received: from nz-out-0506.google.com ([64.233.162.235]:46494 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753075AbXEDLTA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 May 2007 07:19:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:x-priority:message-id:to:cc:subject:in-reply-to:references:mime-version:content-type:content-transfer-encoding;
        b=uCvGnClgthFgOK7DPjtxM0p5IKTbM5qejK55g9R6xeP2+0C+lDqujwycRva/okyS9wZqevSuVNKoCYtLJF8r4iew4iNb6KScz/bjbDb3wYU0cSc9SVj9mYijQJheejRjNWJFxoGcgitPQtJjIilIIH2BBV7ZufbAcgnVXR1LnC4=
Date: Fri, 4 May 2007 14:18:58 +0300
From: Paul Sokolovsky <pmiscml@gmail.com>
X-Priority: 3 (Normal)
Message-ID: <485866756.20070504141858@gmail.com>
To: Greg KH <gregkh@suse.de>
CC: Anton Vorontsov <cbou@mail.ru>, David Woodhouse <dwmw2@infradead.org>,
       <linux-kernel@vger.kernel.org>, <kernel-discuss@handhelds.org>
Subject: Re: [Kernel-discuss] Re: [PATCH 1/8] remove "#if 0" from find_bus function, export it.
In-Reply-To: <20070503231459.GB13626@suse.de>
References: <20070503213121.GA20067@zarina> <20070503231459.GB13626@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Greg,

Friday, May 4, 2007, 2:14:59 AM, you wrote:

> On Fri, May 04, 2007 at 01:31:21AM +0400, Anton Vorontsov wrote:
>> This function were placed in "#if 0" because nobody was using it.
>> We using it now.

> Why?  Shouldn't you just export the pointer you need instead?

>> See http://lwn.net/Articles/210610/

> I don't understand the need for this link, it talks about how the api
> changes all the time, something we all know :)

        No, it talked about how complete APIs regress into random
set of functions, lacking complete coverage of target domain. The
response was that when users for the specific function in question
will be in mainline, it will be resurrected. So, here it comes ;-)

> And if you really want it, and you convince me you really need it, can
> you change it to be "bus_find" to play nicer in the namespace?

> thanks,

> greg k-h


-- 
Best regards,
 Paul                            mailto:pmiscml@gmail.com

