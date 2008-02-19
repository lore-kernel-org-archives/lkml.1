Return-Path: <linux-kernel-owner+w=401wt.eu-S1764198AbYBTATW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764198AbYBTATW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2008 19:19:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761912AbYBTATG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Feb 2008 19:19:06 -0500
Received: from mfbichi11.ns.itscom.net ([219.110.2.189]:46154 "EHLO
	mfbichi11.ns.itscom.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756057AbYBTATF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2008 19:19:05 -0500
X-Greylist: delayed 3050 seconds by postgrey-1.27 at vger.kernel.org; Tue, 19 Feb 2008 19:19:05 EST
Date: Wed, 20 Feb 2008 08:27:56 +0900
From: Mattia Dongili <malattia@linux.it>
To: Adrian Bunk <bunk@kernel.org>
Cc: Len Brown <len.brown@intel.com>, linux-acpi@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [2.6 patch] sony-laptop.c: fix off-by-one
Message-ID: <20080219232756.GA19495@inferi.kami.home>
References: <20080219225903.GS31955@cs181133002.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080219225903.GS31955@cs181133002.pp.htv.fi>
X-Message-Flag: Cranky? Try Free Software instead!
X-Operating-System: Linux 2.6.24-rc6-1 i686
X-Editor: Vim http://www.vim.org/
X-Disclaimer: Buh!
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 20, 2008 at 12:59:03AM +0200, Adrian Bunk wrote:
> This patch fixes an off-by-one spotted by the Coverity checker.
> 
> Signed-off-by: Adrian Bunk <bunk@kernel.org>

Acked-by: Mattia Dongili <malattia@linux.it>

> ---
> --- linux-2.6/drivers/misc/sony-laptop.c.old	2008-02-20 00:26:21.000000000 +0200
> +++ linux-2.6/drivers/misc/sony-laptop.c	2008-02-20 00:26:38.000000000 +0200
> @@ -314,9 +314,9 @@ static void sony_laptop_report_input_eve
>  		kp.dev = jog_dev;
>  		break;
>  
>  	default:
> -		if (event > ARRAY_SIZE(sony_laptop_input_index)) {
> +		if (event >= ARRAY_SIZE(sony_laptop_input_index)) {
>  			dprintk("sony_laptop_report_input_event, event not known: %d\n", event);
>  			break;
>  		}
>  		if (sony_laptop_input_index[event] != -1) {
> 
> -
> To unsubscribe from this list: send the line "unsubscribe linux-acpi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
-- 
mattia
:wq!
