Return-Path: <linux-kernel-owner+w=401wt.eu-S1753397Ab0A0Fh6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753397Ab0A0Fh6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jan 2010 00:37:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751788Ab0A0Fh5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Jan 2010 00:37:57 -0500
Received: from 1wt.eu ([62.212.114.60]:55033 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750841Ab0A0Fh4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jan 2010 00:37:56 -0500
Date: Wed, 27 Jan 2010 06:25:31 +0100
From: Willy Tarreau <w@1wt.eu>
To: Greg KH <gregkh@suse.de>
Cc: linux-kernel@vger.kernel.org, stable@kernel.org,
       Jie Yang <jie.yang@atheros.com>, stable-review@kernel.org,
       akpm@linux-foundation.org, torvalds@linux-foundation.org,
       "David S. Miller" <davem@davemloft.net>, alan@lxorguk.ukuu.org.uk
Subject: Re: [Stable-review] [20/98] atl1c:use common_task instead of reset_task and link_chg_task
Message-ID: <20100127052531.GK20093@1wt.eu>
References: <20100126233950.GA5372@kroah.com> <20100126233923.487128431@mini.kroah.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100126233923.487128431@mini.kroah.org>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 26, 2010 at 03:33:46PM -0800, Greg KH wrote:
> From: Jie Yang <jie.yang@atheros.com>
> 
> commit cb19054697e92a793f336380fd72c588521178ff upstream.
> 
> use common_task instead of reset_task and link_chg_task, so it fix "call cancel_work_sync
> from the work itself".
> 
> Signed-off-by: Jie Yang <jie.yang@atheros.com>
> Signed-off-by: David S. Miller <davem@davemloft.net>
> Cc: Ben Hutchings <ben@decadent.org.uk>
> Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

I'm going to test this one. I'm randomly seeing my ASUS 1005HA
hanging after I replug the network cable. I noticed that the
driver from the Atheros site doesn't have the issue at all. I
spent a week-end trying to eliminate almost all of the diffs
between the two drivers to try to spot the faulty code chunk,
until I realized that I went past the failure point without
noticing in time because the issue was too much random :-(

Clearly a non-bisectable issue. But with just this fix, I'll
be able to tell if the problem is definitely over.

Regards,
Willy

