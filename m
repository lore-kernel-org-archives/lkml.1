Return-Path: <linux-kernel-owner+w=401wt.eu-S1761603AbYBAEh7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761603AbYBAEh7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2008 23:37:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754158AbYBAEhu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Jan 2008 23:37:50 -0500
Received: from nwd2mail10.analog.com ([137.71.25.55]:37409 "EHLO
	nwd2mail10.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752201AbYBAEht (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2008 23:37:49 -0500
X-IronPort-AV: E=Sophos;i="4.25,288,1199682000"; 
   d="scan'208";a="61353425"
Subject: Re: [PATCH] [BLACKFIN] Remove duplicate line discipline definitions
From: Bryan Wu <bryan.wu@analog.com>
Reply-To: bryan.wu@analog.com
To: Tilman Schmidt <tilman@imap.cc>
Cc: Bryan Wu <bryan.wu@analog.com>, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org
In-Reply-To: <20080131220646.4A561110050@xenon.ts.pxnet.com>
References: <20080131220646.4A561110050@xenon.ts.pxnet.com>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Organization: Analog Devices, Inc.
Date: Fri, 01 Feb 2008 12:37:49 +0800
Message-Id: <1201840669.7044.3.camel@roc-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
X-OriginalArrivalTime: 01 Feb 2008 04:37:47.0351 (UTC) FILETIME=[31C8EE70:01C8648C]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Thu, 2008-01-31 at 09:51 +0800, Tilman Schmidt wrote:
> The definitions of the line discipline numbers N_* have been moved
> from asm-*/termios.h to linux/tty.h, but the Blackfin architecture
> has somehow evaded that move. Bring it in line with the others.
> 
Thanks a lot.

Acked-by: Bryan Wu <bryan.wu@analog.com>

> Signed-off-by: Tilman Schmidt <tilman@imap.cc>
> ---
> 
> Note: this is untested, as I have no way to build for the Blackfin
> arch.
> It *should* be ok, as it is just what I did for the other archs a year
> ago, but nevertheless it'd better be checked by someone who's able to
> actually build and run a Blackfin kernel before merging.

I've tested it on BF537-STAMP, it's OK. 

Regards,
-Bryan
> 
>  include/asm-blackfin/termios.h |   18 ------------------
>  1 files changed, 0 insertions(+), 18 deletions(-)
> 
> diff --git a/include/asm-blackfin/termios.h
> b/include/asm-blackfin/termios.h
> index e31fe85..d50d063 100644
> --- a/include/asm-blackfin/termios.h
> +++ b/include/asm-blackfin/termios.h
> @@ -39,24 +39,6 @@ struct termio {
> 
>  /* ioctl (fd, TIOCSERGETLSR, &result) where result may be as below */
> 
> -/* line disciplines */
> -#define N_TTY          0
> -#define N_SLIP         1
> -#define N_MOUSE                2
> -#define N_PPP          3
> -#define N_STRIP                4
> -#define N_AX25         5
> -#define N_X25          6       /* X.25 async */
> -#define N_6PACK                7
> -#define N_MASC         8       /* Reserved for Mobitex module
> <kaz@cafe.net> */
> -#define N_R3964                9       /* Reserved for Simatic R3964
> module */
> -#define N_PROFIBUS_FDL 10      /* Reserved for Profibus
> <Dave@mvhi.com> */
> -#define N_IRDA         11      /* Linux IR -
> http://irda.sourceforge.net/ */
> -#define N_SMSBLOCK     12      /* SMS block mode - for talking to GSM
> data cards about SMS messages */
> -#define N_HDLC         13      /* synchronous HDLC */
> -#define N_SYNC_PPP     14      /* synchronous PPP */
> -#define N_HCI          15      /* Bluetooth HCI UART */
> -
>  #ifdef __KERNEL__
> 
>  /*     intr=^C         quit=^\         erase=del       kill=^U
> --
> 1.5.4.rc2-dirty
> 
> 
