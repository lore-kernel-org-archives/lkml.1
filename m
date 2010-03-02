Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751486Ab0CBF0V (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Mar 2010 00:26:21 -0500
Received: from ksp.mff.cuni.cz ([195.113.26.206]:39518 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750830Ab0CBF0U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Mar 2010 00:26:20 -0500
Date: Tue, 2 Mar 2010 06:26:11 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: greg@kroah.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 02/26] w35und: Remove unused struct _EVENTLOG
Message-ID: <20100302052611.GB19335@elf.ucw.cz>
References: <1267455868-4533-1-git-send-email-penberg@cs.helsinki.fi>
 <1267455868-4533-2-git-send-email-penberg@cs.helsinki.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1267455868-4533-2-git-send-email-penberg@cs.helsinki.fi>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon 2010-03-01 17:04:04, Pekka Enberg wrote:
> Cc: Pavel Machek <pavel@ucw.cz>
> Signed-off-by: Pekka Enberg <penberg@cs.helsinki.fi>

ACK.

> ---
>  drivers/staging/winbond/localpara.h |    9 ---------
>  1 files changed, 0 insertions(+), 9 deletions(-)
> 
> diff --git a/drivers/staging/winbond/localpara.h b/drivers/staging/winbond/localpara.h
> index 5626a76..bdce73c 100644
> --- a/drivers/staging/winbond/localpara.h
> +++ b/drivers/staging/winbond/localpara.h
> @@ -110,13 +110,6 @@
>  // 20061108 WPS IE buffer
>  #define MAX_IE_APPEND_SIZE					256 + 4 // Due to [E id][Length][OUI][Data] may 257 bytes
>  
> -typedef struct _EVENTLOG
> -{
> -	u16		Count;			//Total count from start
> -	u16		index;			//Buffer index, 0 ~ 63
> -	u32		EventValue[64];	//BYTE 3~2 : count, BYTE 1 : Event, BYTE 0 : reason
> -} Event_Log, *pEvent_Log;
> -
>  typedef struct _ChanInfo
>  {
>  	u8		band;
> @@ -264,8 +257,6 @@ typedef struct LOCAL_PARA
>      u32         bToSelfPacketReceived;
>      u32         WepKeyDetectTimerCount;
>  
> -	Event_Log	EventLog;
> -
>  	u16		SignalLostTh;
>  	u16		SignalRoamTh;
>  

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
