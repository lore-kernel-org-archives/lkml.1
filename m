Return-Path: <linux-kernel-owner+w=401wt.eu-S1757654AbZAOCln@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757654AbZAOCln (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2009 21:41:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752814AbZAOCle
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Jan 2009 21:41:34 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:33268 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751765AbZAOCld (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2009 21:41:33 -0500
Date: Thu, 15 Jan 2009 11:40:26 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Randy Dunlap <randy.dunlap@oracle.com>, linux-kernel@vger.kernel.org,
       a.zummo@towertech.it
Subject: Re: mmotm 2009-01-13-16-38 uploaded (rtc-cmos)
Message-Id: <20090115114026.8f3bbafd.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20090114103554.ba1f99b5.akpm@linux-foundation.org>
References: <200901140038.n0E0cIPd013916@imap1.linux-foundation.org>
	<20090114090741.fcb5d335.randy.dunlap@oracle.com>
	<20090114103554.ba1f99b5.akpm@linux-foundation.org>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 14 Jan 2009 10:35:54 -0800
Andrew Morton <akpm@linux-foundation.org> wrote:

> On Wed, 14 Jan 2009 09:07:41 -0800 Randy Dunlap <randy.dunlap@oracle.com> wrote:
> 
> > On Tue, 13 Jan 2009 16:38:17 -0800 akpm@linux-foundation.org wrote:
> > 
> > > The mm-of-the-moment snapshot 2009-01-13-16-38 has been uploaded to
> > > 
> > >    http://userweb.kernel.org/~akpm/mmotm/
> > > 
> > > and will soon be available at
> > > 
> > >    git://git.zen-sources.org/zen/mmotm.git
> > 
> > 
> > no HPET enabled:
> > 
> > mmotm-2009-0113-1638/drivers/rtc/rtc-cmos.c:97: error: redefinition of 'is_hpet_enabled'
> > mmotm-2009-0113-1638/arch/x86/include/asm/hpet.h:110: error: previous definition of 'is_hpet_enabled' was here
> > 
> 
> Caused by rtc-cumulative-style-fixes-fix-fix.patch:
> 
> From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> 
> This was necessary for hpet* functions.
> 
Ouch. Sorry. 

-Kame

> Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> Cc: Alessandro Zummo <a.zummo@towertech.it>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> ---
> 
>  drivers/rtc/rtc-cmos.c |    1 +
>  1 file changed, 1 insertion(+)
> 
> diff -puN drivers/rtc/rtc-cmos.c~rtc-cumulative-style-fixes-fix-fix drivers/rtc/rtc-cmos.c
> --- a/drivers/rtc/rtc-cmos.c~rtc-cumulative-style-fixes-fix-fix
> +++ a/drivers/rtc/rtc-cmos.c
> @@ -39,6 +39,7 @@
>  
>  /* this is for "generic access to PC-style RTC" using CMOS_READ/CMOS_WRITE */
>  #include <asm-generic/rtc.h>
> +#include <asm/hpet.h>
>  
>  struct cmos_rtc {
>  	struct rtc_device	*rtc;
> _
> 
> 
> alas, we don't know what that fix fixed so I don't know what will break
> when I drop it.
> 
> 

