Return-Path: <linux-kernel-owner+w=401wt.eu-S1753546AbYCQL64@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753546AbYCQL64 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Mar 2008 07:58:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752297AbYCQL6s
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Mar 2008 07:58:48 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:41880 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751544AbYCQL6r (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Mar 2008 07:58:47 -0400
Message-ID: <47DE5CEE.5070200@pobox.com>
Date: Mon, 17 Mar 2008 07:58:38 -0400
From: Jeff Garzik <jgarzik@pobox.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: Julia Lawall <julia@diku.dk>
CC: jesse@icplus.com.tw, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org
Subject: Re: [PATCH 6/7] drivers/net/ipg.c: remove unused variable
References: <Pine.LNX.4.64.0803151704150.24178@ask.diku.dk>
In-Reply-To: <Pine.LNX.4.64.0803151704150.24178@ask.diku.dk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.4 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Julia Lawall wrote:
> From: Julia Lawall <julia@diku.dk>
> 
> The variable gig is initialized but never used otherwise.
> 
> The semantic patch that makes this change is as follows:
> (http://www.emn.fr/x-info/coccinelle/)
> 
> // <smpl>
> @@
> type T;
> identifier i;
> constant C;
> @@
> 
> (
> extern T i;
> |
> - T i;
>   <+... when != i
> - i = C;
>   ...+>
> )
> // </smpl>
> 
> Signed-off-by: Julia Lawall <julia@diku.dk>
> ---
>  drivers/net/ipg.c |    3 ---
>  1 file changed, 3 deletions(-)

applied


