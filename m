Return-Path: <linux-kernel-owner+w=401wt.eu-S1030839AbXCNJ5x@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030839AbXCNJ5x (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Mar 2007 05:57:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030836AbXCNJ5x
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Mar 2007 05:57:53 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:38933 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030839AbXCNJ5w (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Mar 2007 05:57:52 -0400
Message-ID: <45F7C718.8020503@pobox.com>
Date: Wed, 14 Mar 2007 05:57:44 -0400
From: Jeff Garzik <jgarzik@pobox.com>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Al Viro <viro@ftp.linux.org.uk>
CC: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 14/17] atl1 trivial endianness misannotations
References: <E1HRPeU-0003a3-2G@ZenIV.linux.org.uk>
In-Reply-To: <E1HRPeU-0003a3-2G@ZenIV.linux.org.uk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.3 (----)
X-Spam-Report: SpamAssassin version 3.1.8 on srv5.dvmed.net summary:
	Content analysis details:   (-4.3 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Al Viro wrote:
> NB: driver is choke-full of code that will break on big-endian; as long
> as the hardware is onboard-only we can live with that, but sooner or
> later that'll need fixing.
> 
> Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
> ---
>  drivers/net/atl1/atl1_main.c |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)

ACK


