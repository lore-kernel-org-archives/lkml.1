Return-Path: <linux-kernel-owner+w=401wt.eu-S1757993AbYFOLqc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757993AbYFOLqc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Jun 2008 07:46:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757282AbYFOLqX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Jun 2008 07:46:23 -0400
Received: from rv-out-0506.google.com ([209.85.198.233]:28956 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757281AbYFOLqW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Jun 2008 07:46:22 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=fM+aWei5SuVJskOPJkVsUx5OR0DEJAWjDO3YP1ctd0aCxeJ1hMLvADsG3q4Juk7sQ2
         /aG2oazUMpsOX79rk5BtWUbLnhZ4hi+8+leWwL+kUKlNrazKnU+txM7IzhrKaIcJdNgd
         UloBwY+t78KvspEhKet76eKX1f5I14vcUyjJc=
Message-ID: <19f34abd0806150446s35ed1ffib9a7ab459f00e870@mail.gmail.com>
Date: Sun, 15 Jun 2008 13:46:21 +0200
From: "Vegard Nossum" <vegard.nossum@gmail.com>
To: "Daniel J Blueman" <daniel.blueman@gmail.com>
Subject: Re: [PATCH] debugobjects: fix lockdep warning
Cc: "Thomas Gleixner" <tglx@linutronix.de>,
       "Christoph Lameter" <clameter@sgi.com>, "Ingo Molnar" <mingo@elte.hu>,
       "Pekka Enberg" <penberg@cs.helsinki.fi>, linux-kernel@vger.kernel.org
In-Reply-To: <6278d2220806150252h10230d2s775913c75d16b793@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080614225826.GA8211@damson.getinternet.no>
	 <6278d2220806150252h10230d2s775913c75d16b793@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 15, 2008 at 11:52 AM, Daniel J Blueman
<daniel.blueman@gmail.com> wrote:
> On Sat, Jun 14, 2008 at 11:58 PM, Vegard Nossum <vegard.nossum@gmail.com> wrote:
>> Hi,
>>
>> I don't know whether this is truly the Right Fix; if it isn't, feel free
>> to re-use my commit template for when the RF appears... ;-)
>>
>> Daniel, is there any chance you can try it out? Thanks.
>
> I get a warning [1] about pool-lock being IRQ-unsafe as-is.
> Additionally promoting pool_lock to be IRQ-safe [2] resolves the
> issue, but this may not be desired. Ping me for further tests and
> thanks!

Ah, yes. Thanks for testing! I thought it might introduce some other
badness. I can't really comment on your new changes (I am not sure
what the implications are exactly), but if it fixes the regression,
then it sounds correct :-)

(I also think this needs Thomas's SOB rather than mine. I am not sure
he's fine with kicking out the retry code :-P)


Vegard

-- 
"The animistic metaphor of the bug that maliciously sneaked in while
the programmer was not looking is intellectually dishonest as it
disguises that the error is the programmer's own creation."
	-- E. W. Dijkstra, EWD1036
