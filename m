Return-Path: <linux-kernel-owner+w=401wt.eu-S1755211AbYCJCGV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755211AbYCJCGV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Mar 2008 22:06:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753575AbYCJCGO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Mar 2008 22:06:14 -0400
Received: from 136-022.dsl.labridge.com ([206.117.136.22]:4493 "EHLO
	mail.perches.com" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1753544AbYCJCGN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Mar 2008 22:06:13 -0400
Subject: Re: [PATCH] synclink drivers bool conversion
From: Joe Perches <joe@perches.com>
To: Paul Fulghum <paulkf@microgate.com>
Cc: LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <1205092170.656.59.camel@localhost>
References: <1205046574.656.37.camel@localhost>
	 <47D3FCF6.70908@microgate.com>  <1205092170.656.59.camel@localhost>
Content-Type: text/plain
Date: Sun, 09 Mar 2008 19:05:03 -0700
Message-Id: <1205114703.656.115.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3-1.2mdv2008.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2008-03-09 at 12:49 -0700, Joe Perches wrote:
> diff --git a/drivers/char/synclink.c b/drivers/char/synclink.c
> index ddc74d1..abf3c37 100644
> --- a/drivers/char/synclink.c
> +++ b/drivers/char/synclink.c
> @@ -5413,9 +5410,9 @@ static void usc_process_rxoverrun_sync( struct mgsl_struct *info )
>  
>  		if ( !start_of_frame_found )
>  		{
> -			start_of_frame_found = TRUE;
> +			start_of_frame_found = true;
>  			frame_start_index = end_index;
> -			end_of_frame_found = FALSE;
> +			end_of_frame_found = true;
>  		}
>  
>  		if ( buffer_list[end_index].status )

end_of_frame_found should be false

