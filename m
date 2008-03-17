Return-Path: <linux-kernel-owner+w=401wt.eu-S1754322AbYCQL7f@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754322AbYCQL7f (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Mar 2008 07:59:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752686AbYCQL70
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Mar 2008 07:59:26 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:42906 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753335AbYCQL7Z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Mar 2008 07:59:25 -0400
Message-ID: <47DE5CF7.8040102@pobox.com>
Date: Mon, 17 Mar 2008 07:58:47 -0400
From: Jeff Garzik <jgarzik@pobox.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: Julia Lawall <julia@diku.dk>
CC: jcliburn@gmail.com, csnook@redhat.com, atl1-devel@lists.sourceforge.net,
       linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH 7/7] drivers/net/atl1/atl1_main.c: remove unused variable
References: <Pine.LNX.4.64.0803151704400.24178@ask.diku.dk>
In-Reply-To: <Pine.LNX.4.64.0803151704400.24178@ask.diku.dk>
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
> The variable update_rx is initialized but never used otherwise.
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
>  drivers/net/atl1/atl1_main.c |    3 ---
>  1 file changed, 3 deletions(-)

applied


