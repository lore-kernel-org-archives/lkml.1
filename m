Return-Path: <linux-kernel-owner+w=401wt.eu-S1757190AbYEZO7H@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757190AbYEZO7H (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 May 2008 10:59:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755990AbYEZO6x
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 May 2008 10:58:53 -0400
Received: from courier.cs.helsinki.fi ([128.214.9.1]:34499 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755959AbYEZO6w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 May 2008 10:58:52 -0400
Date: Mon, 26 May 2008 17:58:51 +0300 (EEST)
From: "=?ISO-8859-1?Q?Ilpo_J=E4rvinen?=" <ilpo.jarvinen@helsinki.fi>
X-X-Sender: ijjarvin@wrl-59.cs.helsinki.fi
To: Ingo Molnar <mingo@elte.hu>
cc: LKML <linux-kernel@vger.kernel.org>, Netdev <netdev@vger.kernel.org>,
       "David S. Miller" <davem@davemloft.net>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [bug] stuck localhost TCP connections, v2.6.26-rc3+
In-Reply-To: <20080526141252.GA31352@elte.hu>
Message-ID: <Pine.LNX.4.64.0805261745010.16829@wrl-59.cs.helsinki.fi>
References: <20080526115628.GA31316@elte.hu> <Pine.LNX.4.64.0805261550340.16829@wrl-59.cs.helsinki.fi>
 <20080526135940.GB24870@elte.hu> <20080526141252.GA31352@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 26 May 2008, Ingo Molnar wrote:

> there's a hung distcc task on the system, waiting for socket action 
> forever:
> 
>   [root@europe ~]# strace -fp 19578
>   Process 19578 attached - interrupt to quit
>   select(5, NULL, [4], [4], {82, 90000} <unfinished ...>

Hmm, readfds is NULL isn't it?!? Are you sure you straced the right 
process?

> disturbing that task via strace did not change the state of the socket - 
> and that's not unexpected as it's a select(). [TCP state might be 
> affected if strace impacted a recvmsg or a sendmsg wait directly.]

I fail to understand this paragraph due to excessive negation... :-)



-- 
 i.
