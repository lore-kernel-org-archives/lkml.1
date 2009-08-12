Return-Path: <linux-kernel-owner+w=401wt.eu-S1754839AbZHLILK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754839AbZHLILK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Aug 2009 04:11:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754729AbZHLILH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Aug 2009 04:11:07 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:38812 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754497AbZHLILE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Aug 2009 04:11:04 -0400
Date: Wed, 12 Aug 2009 10:10:58 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: gregkh@suse.de, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/7] w35und: Cleanup the mlmetxrx_f.h header file
Message-ID: <20090812081058.GC23832@elf.ucw.cz>
References: <1250064219-7372-1-git-send-email-penberg@cs.helsinki.fi> <1250064219-7372-2-git-send-email-penberg@cs.helsinki.fi> <1250064219-7372-3-git-send-email-penberg@cs.helsinki.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1250064219-7372-3-git-send-email-penberg@cs.helsinki.fi>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed 2009-08-12 11:03:35, Pekka Enberg wrote:
> This patch removes the unused MLMEProcThread and MLMEReturnPacket
> declarations and indents the header file.
> 
> Cc: Pavel Machek <pavel@ucw.cz>
> Signed-off-by: Pekka Enberg <penberg@cs.helsinki.fi>
ACK.

> ---
>  drivers/staging/winbond/mlmetxrx_f.h |   24 ++++++------------------
>  1 files changed, 6 insertions(+), 18 deletions(-)
> 
> diff --git a/drivers/staging/winbond/mlmetxrx_f.h b/drivers/staging/winbond/mlmetxrx_f.h
> index 26cf101..d69da41 100644
> --- a/drivers/staging/winbond/mlmetxrx_f.h
> +++ b/drivers/staging/winbond/mlmetxrx_f.h
> @@ -10,28 +10,16 @@
>  
>  #include "core.h"
>  
> -void
> -MLMEProcThread(
> -     struct wbsoft_priv *    adapter
> -	);
> -
> -void MLME_GetNextPacket(  struct wbsoft_priv * adapter,  PDESCRIPTOR pDes );
> -u8 MLMESendFrame( struct wbsoft_priv * adapter,
> -					u8	*pMMPDU,
> -					u16	len,
> -					 u8	DataType);
> +void MLME_GetNextPacket(struct wbsoft_priv *adapter, PDESCRIPTOR pDes);
> +u8 MLMESendFrame(struct wbsoft_priv *adapter,
> +		 u8 * pMMPDU, u16 len, u8 DataType);
>  
>  void
> -MLME_SendComplete(  struct wbsoft_priv * adapter,  u8 PacketID,  unsigned char SendOK );
> +MLME_SendComplete(struct wbsoft_priv *adapter, u8 PacketID,
> +		  unsigned char SendOK);
>  
> -void
> -MLMEReturnPacket(
> -     struct wbsoft_priv *    adapter,
> -     u8 *          pRxBufer
> -   );
>  #ifdef _IBSS_BEACON_SEQ_STICK_
> -s8 SendBCNullData(struct wbsoft_priv * adapter, u16 wIdx);
> +s8 SendBCNullData(struct wbsoft_priv *adapter, u16 wIdx);
>  #endif
>  
>  #endif
> -

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
