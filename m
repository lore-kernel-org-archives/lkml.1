Return-Path: <linux-kernel-owner+w=401wt.eu-S1759628AbYHIDun@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759628AbYHIDun (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2008 23:50:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753917AbYHIDuc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Aug 2008 23:50:32 -0400
Received: from mx1.redhat.com ([66.187.233.31]:55790 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753037AbYHIDuc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2008 23:50:32 -0400
Message-ID: <489D13F9.4000805@redhat.com>
Date: Fri, 08 Aug 2008 23:50:17 -0400
From: Hideo AOKI <haoki@redhat.com>
User-Agent: Thunderbird 2.0.0.16 (X11/20080723)
MIME-Version: 1.0
To: Herbert Xu <herbert@gondor.apana.org.au>
CC: "Michael S. Tsirkin" <m.s.tsirkin@gmail.com>, linux-kernel@vger.kernel.org,
       davem@davemloft.net, yoshfuji@linux-ipv6.org, netdev@vger.kernel.org
Subject: Re: possible recursive locking in udp4_lib_rcv
References: <20080807234613.GA9598@google.com> <E1KRSxN-0005Ng-00@gondolin.me.apana.org.au> <20080808143741.GA20777@gondor.apana.org.au> <20080808150108.GA21048@gondor.apana.org.au>
In-Reply-To: <20080808150108.GA21048@gondor.apana.org.au>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Herbert,

Herbert Xu wrote:
> On Fri, Aug 08, 2008 at 10:37:41PM +0800, Herbert Xu wrote:
>> Never mind, I see the reason why it's there.  What we should do
>> is drop the lock when we hit an encapsulated socket since they
>> don't need it at all.
> 
> Here is the patch:
> 
> udp: Drop socket lock for encapsulated packets

Thank very much for fixing the bug.

Best regards,
Hideo

-- 
Hitachi Computer Products (America) Inc.
