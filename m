Return-Path: <linux-kernel-owner+w=401wt.eu-S933702AbXIBK5x@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933702AbXIBK5x (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Sep 2007 06:57:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755423AbXIBK5m
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Sep 2007 06:57:42 -0400
Received: from stinky.trash.net ([213.144.137.162]:46385 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754702AbXIBK5l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Sep 2007 06:57:41 -0400
Message-ID: <46DA96CC.3080402@trash.net>
Date: Sun, 02 Sep 2007 12:56:12 +0200
From: Patrick McHardy <kaber@trash.net>
User-Agent: Mozilla-Thunderbird 2.0.0.0 (X11/20070601)
MIME-Version: 1.0
To: Herbert Xu <herbert@gondor.apana.org.au>
CC: link@miggy.org, linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       netdev@vger.kernel.org, bugme-daemon@bugzilla.kernel.org
Subject: Re: [Bugme-new] [Bug 8961] New: BUG triggered by oidentd in netlink
 code
References: <E1IRghZ-0004EL-00@gondolin.me.apana.org.au>
In-Reply-To: <E1IRghZ-0004EL-00@gondolin.me.apana.org.au>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Herbert Xu wrote:
> Patrick McHardy <kaber@trash.net> wrote:
>   
>> Thanks. I'm not sure either, it would require two concurrent requests
>> to be processed, but AFAICS oidentd only uses a single netlink socket.
>> Perhaps multiple running instances or something else using the inet_diag
>> interface?
>>     
>
> Since identd serves requests from the outside world it is
> quite possible for two identd instances to run simultaneously
> serving two requests.
>
> I'm not familiar with oidentd but this is certainly pidentd
> works.

Right, I forgot about inetd. Thanks Herbert :)

