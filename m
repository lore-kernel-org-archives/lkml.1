Return-Path: <linux-kernel-owner+w=401wt.eu-S965451AbXCAR0k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965451AbXCAR0k (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Mar 2007 12:26:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965456AbXCAR0k
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Mar 2007 12:26:40 -0500
Received: from agminet01.oracle.com ([141.146.126.228]:56197 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965451AbXCAR0j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Mar 2007 12:26:39 -0500
Date: Thu, 1 Mar 2007 09:10:59 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
To: "Uwe Bugla" <uwe.bugla@gmx.de>
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
       linux-dvb@linuxtv.org, domi.dumont@free.fr,
       Jiri Slaby <jirislaby@gmail.com>, bunk@stusta.de,
       linux-kernel@vger.kernel.org, Stephane Eranian <eranian@hpl.hp.com>,
       venkatesh.pallipadi@intel.com
Subject: Re: patch 1 / 3: fix broken documentation for bt8xx cards
Message-Id: <20070301091059.cdc837a8.randy.dunlap@oracle.com>
In-Reply-To: <20070301142904.29930@gmx.net>
References: <20070301142904.29930@gmx.net>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.3.1 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Whitelist: TRUE
X-Whitelist: TRUE
X-Brightmail-Tracker: AAAAAQAAAAI=
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 01 Mar 2007 15:29:04 +0100 Uwe Bugla wrote:

> --- a/Documentation/dvb/bt8xx.txt
> +++ b/Documentation/dvb/bt8xx.txt
> @@ -9,9 +9,33 @@
>  Please see Documentation/dvb/cards.txt => o Cards based on the Conexant Bt8xx PCI bridge:
>  
>  Compiling kernel please enable:
> -a.)"Device drivers" => "Multimedia devices" => "Video For Linux" => "BT848 Video For Linux"
> +a.)"Device drivers" => "Multimedia devices" => "Video For Linux" => "Enable Video for Linux API 1 (DEPRECATED)"
> -b.)"Device drivers" => "Multimedia devices" => "Digital Video Broadcasting Devices"
> - => "DVB for Linux" "DVB Core Support" "Bt8xx based PCI Cards"
> +b.)"Device drivers" => "Multimedia devices" => "Video For Linux" => "Video Capture Adapters" => "BT848 Video For Linux"
> +c.)"Device drivers" => "Multimedia devices" => "Digital Video Broadcasting Devices" => "DVB for Linux" "DVB Core Support" "Bt8xx based PCI Cards"
> +
> +Please use the following options with care as deselection of drivers which are in fact necessary
> +may result in DVB devices that cannot be tuned due to lack of driver support:
> +You can save RAM by deselecting every frontend or DST module that your DVB card does not need.

Please limit (prose) text to less than 80 columns.  Thanks.

> +
> +First please remove the static dependency of DVB card drivers on all frontend modules for all possible card variants by enabling:
> +d.) "Device drivers" => "Multimedia devices" => "Digital Video Broadcasting Devices"
> + => "DVB for Linux" "DVB Core Support" "Load and attach frontend modules as needed"
> +
> +If you know the frontend driver that your card needs please enable:
> +e.)"Device drivers" => "Multimedia devices" => "Digital Video Broadcasting Devices"
> + => "DVB for Linux" "DVB Core Support" "Customise DVB Frontends" => "Customise the frontend modules to build"
> + Then please select your card-specific frontend module.
> +
> +Do you use one of the following cards?
> +1. Twinhan DST (FTA and CI) family (DVB-S/C/T/ATSC)
> +2. Pinnacle PCTV SAT CI
> +3. Chaintech DST-1000
> +4. DNTV Live !
> +
> +If not you can save additional RAM by enabling:
> +f.)"Device drivers" => "Multimedia devices" => "Digital Video Broadcasting Devices" => "DVB for Linux" "DVB Core Support"
> + "Bt8xx based PCI Cards" => "Customise DST support" => "Customise DST modules to build"
> + Then please deselect "DST module" and "DST CA module"
>  
>  2) Loading Modules
>  ==================
> @@ -68,7 +92,7 @@
>  	$ modprobe dvb-bt8xx
>  
>  For a full list of card ID's please see Documentation/video4linux/CARDLIST.bttv.
> -In case of further problems send questions to the mailing list: www.linuxdvb.org.
> +In case of further problems please subscribe and send questions to the mailing list: linux-dvb@linuxtv.org.
>  
>  Authors: Richard Walker,
>  	 Jamie Honan,


---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
