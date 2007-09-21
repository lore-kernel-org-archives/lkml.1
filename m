Return-Path: <linux-kernel-owner+w=401wt.eu-S1759406AbXIURa2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759406AbXIURa2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2007 13:30:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753649AbXIURaL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Sep 2007 13:30:11 -0400
Received: from ug-out-1314.google.com ([66.249.92.175]:40696 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760551AbXIURaI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2007 13:30:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=Q5zquC4ItTWBLrOenFKBR5CE7OLIxuToV2XAElQwvxLfD4Qr0gGxpg8jykJkHWwbLJWnhm9V5nB32ZmI/V7BR1R0vKUKUQ9K5v/4uTxba0O68BWo1WgIKO6ubFGbCEaVmdxOB2wMw5o2n2oeUgw/0NIKyw6j+h97G3jagvCWCPo=
Message-ID: <46F3FF9C.7040200@gmail.com>
Date: Fri, 21 Sep 2007 19:30:04 +0200
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070728)
MIME-Version: 1.0
To: Valdis.Kletnieks@vt.edu
CC: Matt Mackall <mpm@selenic.com>, Dave Airlie <airlied@gmail.com>,
       Andi Kleen <andi@firstfloor.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: X-freeze after clflush changes [Was: 2.6.23-rc6-mm1]
References: <20070918011841.2381bd93.akpm@linux-foundation.org> <46F10B69.5070008@gmail.com> <46F10DCB.1090302@gmail.com> <46F13938.1070709@gmail.com> <20070919121017.0cbcbc30.akpm@linux-foundation.org> <20070919192453.GB18707@one.firstfloor.org> <21d7e9970709191842h3111390cl8f09745bed6bd8f9@mail.gmail.com>            <20070920220604.GA17536@waste.org> <10207.1190394975@turing-police.cc.vt.edu>
In-Reply-To: <10207.1190394975@turing-police.cc.vt.edu>
X-Enigmail-Version: 0.95.3
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/21/2007 07:16 PM, Valdis.Kletnieks@vt.edu wrote:
> On Thu, 20 Sep 2007 17:06:05 CDT, Matt Mackall said:
>> 2.6.23-rc3-mm1: solid lock on X shutdown (noticed when upgrading)
>>       -rc4-mm1: solid lock on X shutdown, random solid locks about
>>                 once every four hours
>>       -rc6-mm1: solid lock on X startup
>>    +your patch: screen goes black, turns off and on a few times during
>>                 startup, can reboot with sysrq-b
> 
> Hmm.. maybe I'm chasing a different bug manifested by the same patch.  For me,
> it's been a solid lockup at X startup since -rc3-mm1, and this patch doesn't
> change matters.

This patch probably changes behaviour how the pages are queued on the list
somehow. Maybe it's insane to suggest everybody with similar problem to try
LIST_DEBUG, but just give it a try after having one of the patches applied ;).
(Or have you tried yet?)

regards,
-- 
Jiri Slaby (jirislaby@gmail.com)
Faculty of Informatics, Masaryk University
