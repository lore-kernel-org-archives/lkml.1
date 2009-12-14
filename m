Return-Path: <linux-kernel-owner+w=401wt.eu-S1756714AbZLNPjh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756714AbZLNPjh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Dec 2009 10:39:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754351AbZLNPjf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Dec 2009 10:39:35 -0500
Received: from stinky.trash.net ([213.144.137.162]:65101 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750713AbZLNPje (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Dec 2009 10:39:34 -0500
Message-ID: <4B265C34.6070205@trash.net>
Date: Mon, 14 Dec 2009 16:39:32 +0100
From: Patrick McHardy <kaber@trash.net>
User-Agent: Mozilla-Thunderbird 2.0.0.22 (X11/20090701)
MIME-Version: 1.0
To: Simon Horman <horms@verge.net.au>
CC: Xiaotian Feng <dfeng@redhat.com>, netdev@vger.kernel.org,
       lvs-devel@vger.kernel.org, linux-kernel@vger.kernel.org,
       Wensong Zhang <wensong@linux-vs.org>, Julian Anastasov <ja@ssi.bg>,
       "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH] ipvs: fix synchronization on connection close
References: <1260434502-14166-1-git-send-email-dfeng@redhat.com> <20091211033542.GA28136@verge.net.au>
In-Reply-To: <20091211033542.GA28136@verge.net.au>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Simon Horman wrote:
> On Thu, Dec 10, 2009 at 04:41:42PM +0800, Xiaotian Feng wrote:
>> commit 9d3a0de makes slaves expire as they would do on the master
>> with much shorter timeouts. But it introduces another problem:
>> When we close a connection, on master server the connection became
>> CLOSE_WAIT/TIME_WAIT, it was synced to slaves, but if master is
>> finished within it's timeouts (CLOSE), it will not be synced to
>> slaves. Then slaves will be kept on CLOSE_WAIT/TIME_WAIT until
>> timeout reaches. Thus we should also sync with CLOSE.
>>
>> Signed-off-by: Xiaotian Feng <dfeng@redhat.com>
>> Cc: Wensong Zhang <wensong@linux-vs.org>
>> Cc: Simon Horman <horms@verge.net.au>
>> Cc: Julian Anastasov <ja@ssi.bg>
>> Cc: David S. Miller <davem@davemloft.net>
> 
> This seems reasonable to me.
> 
> Acked-by: Simon Horman <horms@verge.net.au>

Applied, thanks.

