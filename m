Return-Path: <linux-kernel-owner+w=401wt.eu-S1752089AbZEWIZr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752089AbZEWIZr (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 May 2009 04:25:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751694AbZEWIZi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 May 2009 04:25:38 -0400
Received: from mail-bw0-f174.google.com ([209.85.218.174]:33000 "EHLO
	mail-bw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751623AbZEWIZh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 May 2009 04:25:37 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=k2sRS4GZaxUl3/8IdjOOYFG58EcMJ+bvoAZvkoXqYh9GFNlYzZd2lqMDK5LFOzDp3C
         WaHzxpJrMTrRtOMVPV2m9zO2z+xWpQpJLvpfmiPxsFTg7pL4SZW8hf6H19jcGS519ULi
         rMsFvUDeo1uNTeP5elNPNgBXVIvBmYQwdQ0uo=
MIME-Version: 1.0
In-Reply-To: <4A1719DE.4060009@unsolicited.net>
References: <4A1719DE.4060009@unsolicited.net>
Date: Sat, 23 May 2009 11:25:37 +0300
X-Google-Sender-Auth: 114610eb74e77b1f
Message-ID: <84144f020905230125n32e9533dk112db9b31763e15c@mail.gmail.com>
Subject: Re: USB/DVB - Old Technotrend TT-connect S-2400 regression tracked 
	down
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: David <david@unsolicited.net>
Cc: linux-media@vger.kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       dbrownell@users.sourceforge.net, Alan Stern <stern@rowland.harvard.edu>,
       leonidv11@gmail.com, Greg KH <gregkh@suse.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 23, 2009 at 12:32 AM, David <david@unsolicited.net> wrote:
> I reported this DVB-S card breaking between 2.6.26 and 2.6.27. I've
> finally had time to do some digging, and the regression is caused by:
>
>    b963801164618e25fbdc0cd452ce49c3628b46c8 USB: ehci-hcd unlink speedups
>
> ..that was introduced in 2.6.27. Reverting this change in 2.6.29-rc5
> makes the card work happily again.

[ Note: David meant 2.6.30-rc5 here. ]

Thanks for doing the bisect!

On Sat, May 23, 2009 at 12:32 AM, David <david@unsolicited.net> wrote:
> I don't know enough about USB protocols to speculate on whether there
> may be a better fix, but hopefully someone cleverer than me can get to
> the bottom of the problem?

Lets start with cc'ing the right people. :-)

                                Pekka
