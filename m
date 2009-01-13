Return-Path: <linux-kernel-owner+w=401wt.eu-S1757634AbZAMDQT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757634AbZAMDQT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2009 22:16:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752735AbZAMDP6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Jan 2009 22:15:58 -0500
Received: from netrider.rowland.org ([192.131.102.5]:3673 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1757329AbZAMDP5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2009 22:15:57 -0500
Date: Mon, 12 Jan 2009 22:15:57 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: Greg KH <gregkh@suse.de>
cc: Kernel development list <linux-kernel@vger.kernel.org>,
       <stable@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
       <jburda@email.cz>
Subject: Re: [patch 02/21] usb-storage: update unusual_devs entry for Nokia
 5310
In-Reply-To: <20090113012651.GC4512@kroah.com>
Message-ID: <Pine.LNX.4.44L0.0901122213180.18052-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 12 Jan 2009, Greg KH wrote:

> 2.6.27-stable review patch.  If anyone has any objections, please let us know.
> 
> ------------------
> 
> From: Alan Stern <stern@rowland.harvard.edu>
> 
> commit a4b188095912eee83d065f000dfe06f25919750b upstream.
> 
> This patch (as1179) updates the unusual_devs entry for Nokia's 5310
> phone to include a more recent firmware revision.
> 
> This fixes Bugzilla #12099.
> 
> Signed-off-by: Alan Stern <stern@rowland.harvard.edu>
> Tested-by: Robson Roberto Souza Peixoto <robsonpeixoto@gmail.com>
> Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
> 
> ---
>  drivers/usb/storage/unusual_devs.h |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> --- a/drivers/usb/storage/unusual_devs.h
> +++ b/drivers/usb/storage/unusual_devs.h
> @@ -168,7 +168,7 @@ UNUSUAL_DEV(  0x0421, 0x005d, 0x0001, 0x
>  		US_FL_FIX_CAPACITY ),
>  
>  /* Patch for Nokia 5310 capacity */
> -UNUSUAL_DEV(  0x0421, 0x006a, 0x0000, 0x0591,
> +UNUSUAL_DEV(  0x0421, 0x006a, 0x0000, 0x0701,
>  		"Nokia",
>  		"5310",
>  		US_SC_DEVICE, US_PR_DEVICE, NULL,

Ironically, Bugzilla #12367 (just filed) requires that the 0x0701 above
be increased to 0x0832.

Alan Stern

