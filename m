Return-Path: <linux-kernel-owner+w=401wt.eu-S1755166AbYH0Jhx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755166AbYH0Jhx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2008 05:37:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754058AbYH0Jhj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Aug 2008 05:37:39 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:59100 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753147AbYH0Jhi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2008 05:37:38 -0400
Message-ID: <48B5205C.9000804@garzik.org>
Date: Wed, 27 Aug 2008 05:37:32 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.16 (X11/20080723)
MIME-Version: 1.0
To: Jay Cliburn <jacliburn@bellsouth.net>
CC: netdev@vger.kernel.org, linux-kernel@vger.kernel.org, link@miggy.org,
       ian@jeffray.co.uk, csnook@redhat.com, jie.yang@atheros.com,
       m@fhloston.org
Subject: Re: [PATCH] atl1: disable TSO by default
References: <20080818192813.0d0dc1fd@osprey.hogchain.net>
In-Reply-To: <20080818192813.0d0dc1fd@osprey.hogchain.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.5 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jay Cliburn wrote:
> The atl1 driver is causing stalled connections and file corruption
> whenever TSO is enabled.  Two examples are here:
> 
> http://lkml.org/lkml/2008/7/15/325
> http://lkml.org/lkml/2008/8/18/543
> 
> Disable TSO by default until we can determine the source of the
> problem.
> 
> Signed-off-by: Jay Cliburn <jacliburn@bellsouth.net>
> cc: stable@kernel.org
> ---
> 
> Jeff, I've been trying to find the source of this problem in my
> spare time for a few weeks now, but haven't been successful.  We
> turned on TSO by default in 2.6.26 after fixing a nasty performance
> bug in it, but there's apparently another bug lurking.
> 
> This patch needs to be also applied to 2.6.26, hence the cc to
> stable.
> 
>  drivers/net/atlx/atl1.c |    1 -
>  1 files changed, 0 insertions(+), 1 deletions(-)

applied


