Return-Path: <linux-kernel-owner+w=401wt.eu-S1756010AbYGUUwP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756010AbYGUUwP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2008 16:52:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752307AbYGUUv5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Jul 2008 16:51:57 -0400
Received: from stinky.trash.net ([213.144.137.162]:47681 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752720AbYGUUv4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2008 16:51:56 -0400
Message-ID: <4884F6E9.6090809@trash.net>
Date: Mon, 21 Jul 2008 22:51:53 +0200
From: Patrick McHardy <kaber@trash.net>
User-Agent: Mozilla-Thunderbird 2.0.0.12 (X11/20080405)
MIME-Version: 1.0
To: David Miller <davem@davemloft.net>
CC: Larry.Finger@lwfinger.net, mingo@elte.hu, ischram@telenet.be,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-wireless@vger.kernel.org, j@w1.fi
Subject: Re: [crash] BUG: unable to handle kernel NULL pointer dereference
 at 0000000000000370
References: <4884E6E6.7010800@lwfinger.net>	<20080721.132100.128525904.davem@davemloft.net>	<4884F3D7.4070604@lwfinger.net> <20080721.134608.75595942.davem@davemloft.net>
In-Reply-To: <20080721.134608.75595942.davem@davemloft.net>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Miller wrote:
> From: Larry Finger <Larry.Finger@lwfinger.net>
> Date: Mon, 21 Jul 2008 15:38:47 -0500
> 
>> David Miller wrote:
>>> No further backtrace?  That will tell us what driver is causing
>>> this.
>> Yes, I have a full backtrace.
>>
>> It starts with possible recursive locking in NetworkManager, and goes directly 
>> into the Warning - this came from a later pull of Linus's tree.
> 
> That helps a lot, I'm looking at this now.

I'm guessing this needs similar lockdep class initializations
to _xmit_lock since it essentially has the same nesting rules.

