Return-Path: <linux-kernel-owner+w=401wt.eu-S1754554AbZHLINs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754554AbZHLINs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Aug 2009 04:13:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754244AbZHLINr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Aug 2009 04:13:47 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:48288 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754216AbZHLINq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Aug 2009 04:13:46 -0400
Date: Wed, 12 Aug 2009 10:13:40 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: gregkh@suse.de, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 5/7] w35und: Remove unused struct _STATISTICS_INFO
Message-ID: <20090812081339.GE23832@elf.ucw.cz>
References: <1250064219-7372-1-git-send-email-penberg@cs.helsinki.fi> <1250064219-7372-2-git-send-email-penberg@cs.helsinki.fi> <1250064219-7372-3-git-send-email-penberg@cs.helsinki.fi> <1250064219-7372-4-git-send-email-penberg@cs.helsinki.fi> <1250064219-7372-5-git-send-email-penberg@cs.helsinki.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1250064219-7372-5-git-send-email-penberg@cs.helsinki.fi>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed 2009-08-12 11:03:37, Pekka Enberg wrote:
> Cc: Pavel Machek <pavel@ucw.cz>
> Signed-off-by: Pekka Enberg <penberg@cs.helsinki.fi>

ACK.

> ---
>  drivers/staging/winbond/mto.h |   49 -----------------------------------------
>  1 files changed, 0 insertions(+), 49 deletions(-)
> 
> diff --git a/drivers/staging/winbond/mto.h b/drivers/staging/winbond/mto.h
> index 56f2465..5990ba3 100644
> --- a/drivers/staging/winbond/mto.h
> +++ b/drivers/staging/winbond/mto.h
> @@ -209,55 +209,6 @@ typedef struct {
>  	u8 tx_retry_rate;
>  } TXRETRY_REC;
>  
> -typedef struct _STATISTICS_INFO {
> -	u32   Rate54M;
> -	u32   Rate48M;
> -	u32   Rate36M;
> -	u32   Rate24M;
> -	u32   Rate18M;
> -	u32   Rate12M;
> -	u32   Rate9M;
> -	u32   Rate6M;
> -	u32   Rate11MS;
> -	u32   Rate11ML;
> -	u32   Rate55MS;
> -	u32   Rate55ML;
> -	u32   Rate2MS;
> -	u32   Rate2ML;
> -	u32   Rate1M;
> -	u32   Rate54MOK;
> -	u32   Rate48MOK;
> -	u32   Rate36MOK;
> -	u32   Rate24MOK;
> -	u32   Rate18MOK;
> -	u32   Rate12MOK;
> -	u32   Rate9MOK;
> -	u32   Rate6MOK;
> -	u32   Rate11MSOK;
> -	u32   Rate11MLOK;
> -	u32   Rate55MSOK;
> -	u32   Rate55MLOK;
> -	u32   Rate2MSOK;
> -	u32   Rate2MLOK;
> -	u32   Rate1MOK;
> -	u32   SQ3;
> -	s32   RSSIAVG;
> -	s32   RSSIMAX;
> -	s32   TXRATE;
> -	s32   TxRetryRate;
> -	s32   BSS_PK_CNT;
> -	s32   NIDLESLOT;
> -	s32   SLOT_CNT;
> -	s32   INTERF_CNT;
> -	s32   GAP_CNT;
> -	s32   DS_EVM;
> -	s32   RcvBeaconNum;
> -	s32   RXRATE;
> -	s32   RxBytes;
> -	s32   TxBytes;
> -	s32   Antenna;
> -} STATISTICS_INFO, *PSTATISTICS_INFO;
> -
>  extern void MTO_Init(struct wbsoft_priv *);
>  extern void MTO_PeriodicTimerExpired(struct wbsoft_priv *);
>  extern void MTO_SetDTORateRange(struct wbsoft_priv *, u8 *, u8);

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
