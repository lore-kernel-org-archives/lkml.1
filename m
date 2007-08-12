Return-Path: <linux-kernel-owner+w=401wt.eu-S1762140AbXHLDk2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762140AbXHLDk2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Aug 2007 23:40:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752772AbXHLDkQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 11 Aug 2007 23:40:16 -0400
Received: from smtpq1.tilbu1.nb.home.nl ([213.51.146.200]:34610 "EHLO
	smtpq1.tilbu1.nb.home.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755494AbXHLDkO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Aug 2007 23:40:14 -0400
Message-ID: <46BE804A.8080609@gmail.com>
Date: Sun, 12 Aug 2007 05:36:42 +0200
From: Rene Herman <rene.herman@gmail.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070728)
MIME-Version: 1.0
To: Roland Dreier <rdreier@cisco.com>
CC: Jesper Juhl <jesper.juhl@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@osdl.org>, Ingo Molnar <mingo@elte.hu>
Subject: Re: Are we properly prepared to handle 3 Socket setups?
References: <9a8748490708111808o11d354fr9efa719bc38046c5@mail.gmail.com>	<46BE621E.9090509@gmail.com>	<9a8748490708111852y569a3e18i1c3d192e60eceafe@mail.gmail.com>	<46BE7BB6.2010607@gmail.com> <ada4pj5l9bi.fsf@cisco.com>
In-Reply-To: <ada4pj5l9bi.fsf@cisco.com>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
X-AtHome-MailScanner-Information: Please contact support@home.nl for more information
X-AtHome-MailScanner: Found to be clean
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/12/2007 05:29 AM, Roland Dreier wrote:

>  >         /*
>  >          * Maximum threshold is 125
>  >          */
>  >         threshold = min(125, threshold);
>  > 
>  > as either the comment or the code is wrong and it seems it's the
>  > code.
> 
> What's the problem?  That line sets threshold to the smaller of the
> current value or 125, which is exactly what one would want to do if
> the maximum value is 125.  Just do a couple of examples: eg if threshold
> is 100 going into that line, then the value is left alone; if
> threshold is 150 then it gets set to 125; and that seems exactly correct.

Crap, need bed, sorry (the fls/ilog2 things still stand -- quite possibly 
both not a problem either).

Rene.

