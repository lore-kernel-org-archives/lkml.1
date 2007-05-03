Return-Path: <linux-kernel-owner+w=401wt.eu-S1161815AbXECK3u@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161815AbXECK3u (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2007 06:29:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161819AbXECK3u
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 May 2007 06:29:50 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:60857
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1161775AbXECK3s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2007 06:29:48 -0400
Date: Thu, 03 May 2007 03:29:49 -0700 (PDT)
Message-Id: <20070503.032949.65795400.davem@davemloft.net>
To: dhowells@redhat.com
Cc: akpm@osdl.org, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       netdev@vger.kernel.org, kaber@trash.net
Subject: Re: [PATCH 5/5] AFS: Adjust the new netdevice scanning code
From: David Miller <davem@davemloft.net>
In-Reply-To: <20070503095336.26912.55434.stgit@warthog.cambridge.redhat.com>
References: <20070503095315.26912.24270.stgit@warthog.cambridge.redhat.com>
	<20070503095336.26912.55434.stgit@warthog.cambridge.redhat.com>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Howells <dhowells@redhat.com>
Date: Thu, 03 May 2007 10:53:36 +0100

> Adjust the new netdevice scanning code provided by Patrick McHardy:
> 
>  (1) Restore the function banner comments that were dropped.
> 
>  (2) Rather than using an array size of 6 in some places and an array size of
>      ETH_ALEN in others, pass a pointer instead and pass the array size
>      through so that we can actually check it.
> 
>  (3) Do the buffer fill count check before checking the for_primary_ifa
>      condition again.  This permits us to skip that check should maxbufs be
>      reached before we run out of interfaces.
> 
> Signed-off-by: David Howells <dhowells@redhat.com>

Applied, thanks.
