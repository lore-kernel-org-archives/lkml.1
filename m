Return-Path: <linux-kernel-owner+w=401wt.eu-S1755563AbXIXGHF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755563AbXIXGHF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2007 02:07:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751400AbXIXGGy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Sep 2007 02:06:54 -0400
Received: from fk-out-0910.google.com ([209.85.128.191]:18451 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751203AbXIXGGx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2007 02:06:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=AN0ibv9z5EzxtqS/AViZvBP9QCM9+bPkn+E5hk1uLrUPtWMhLgabXmg7z3+7hQAdTAd8TEtP/XQtE9sFvK/gA3hgtGukDT3YJz52il0wwS4ptMTcC6CBHBn6wo/3L0InFZ2kdGjO+nHOghCkF2PBgEK+5noMfgSUSDXG1ygZXPA=
Message-ID: <46F753F5.7060707@gmail.com>
Date: Mon, 24 Sep 2007 08:06:45 +0200
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070728)
MIME-Version: 1.0
To: Valdis.Kletnieks@vt.edu
CC: Matt Mackall <mpm@selenic.com>, Dave Airlie <airlied@gmail.com>,
       Andi Kleen <andi@firstfloor.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: X-freeze after clflush changes [Was: 2.6.23-rc6-mm1]
References: <20070918011841.2381bd93.akpm@linux-foundation.org> <46F10B69.5070008@gmail.com> <46F10DCB.1090302@gmail.com> <46F13938.1070709@gmail.com> <20070919121017.0cbcbc30.akpm@linux-foundation.org> <20070919192453.GB18707@one.firstfloor.org> <21d7e9970709191842h3111390cl8f09745bed6bd8f9@mail.gmail.com> <20070920220604.GA17536@waste.org> <10207.1190394975@turing-police.cc.vt.edu> <46F3FF9C.7040200@gmail.com> <4109.1190403228@turing-police.cc.vt.edu> <46F41DC0.9060407@gmail.com>            <46F41ED8.3020301@gmail.com> <18727.1190604314@turing-police.cc.vt.edu>
In-Reply-To: <18727.1190604314@turing-police.cc.vt.edu>
X-Enigmail-Version: 0.95.3
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/24/2007 05:25 AM, Valdis.Kletnieks@vt.edu wrote:
> On Fri, 21 Sep 2007 21:43:20 +0200, Jiri Slaby said:
>> On 09/21/2007 09:38 PM, Jiri Slaby wrote:
>>> It is rather the other user who adds the page to some other list while bein
> g at
>>> deferred_pages list. Could you try my debug patch
>>> (http://lkml.org/lkml/2007/9/19/141)?
>> or the whitespace non-damaged version:
>> http://www.fi.muni.cz/~xslaby/sklad/pageattr_debug
> 
> Gaak. Is that thing *supposed* to spew zillions of lines of output?

Oh, probably yes.

> Some of the hits we get (I'm wondering if anything after the first makes
> any sense, or if we're just slowly watching the corruption spread - the
> thing ended up near 23K lines long before I gave up and hit the poweroff
> button because there was no end in sight):

Yes. it's not perfect, most of them are false positives (It's OK).

> (If there's something specific you want me to find in the output,
> like "the first time we see XYZ", yell...)

Heh :). The few last before the list corruption BUG (you have to have LIST_DEBUG
enabled) -- but it seems you never reached that phase?

regards,
-- 
Jiri Slaby (jirislaby@gmail.com)
Faculty of Informatics, Masaryk University
