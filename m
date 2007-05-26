Return-Path: <linux-kernel-owner+w=401wt.eu-S1763546AbXEZSrP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763546AbXEZSrP (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 May 2007 14:47:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758212AbXEZSrC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 May 2007 14:47:02 -0400
Received: from static-ip-62-75-166-246.inaddr.intergenia.de ([62.75.166.246]:36294
	"EHLO vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753733AbXEZSrA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 May 2007 14:47:00 -0400
From: Michael Buesch <mb@bu3sch.de>
To: "Benoit Boissinot" <bboissin@gmail.com>
Subject: Re: BUG in 2.6.22-rc2-mm1: NIC module b44.c broken (Broadcom 4400)
Date: Sat, 26 May 2007 20:46:46 +0200
User-Agent: KMail/1.9.6
Cc: "Uwe Bugla" <uwe.bugla@gmx.de>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Maximilian Engelhardt" <maxi@daemonizer.de>,
       linux-wireless@vger.kernel.org,
       linux-kernel <linux-kernel@vger.kernel.org>
References: <20070524195616.234280@gmx.net> <200705261918.09469.mb@bu3sch.de> <40f323d00705261141m7c32d2b8h7059b4b35ed066c9@mail.gmail.com>
In-Reply-To: <40f323d00705261141m7c32d2b8h7059b4b35ed066c9@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200705262046.47252.mb@bu3sch.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 26 May 2007 20:41:09 Benoit Boissinot wrote:
> On 5/26/07, Michael Buesch <mb@bu3sch.de> wrote:
> > On Saturday 26 May 2007 19:04:04 Uwe Bugla wrote:
> > > Yes, sure! But the help text is very unlucky and humble, and it is not clear
> > > enough in the sense of being distinctive enough, just clear and
> > > comprehensive.
> >
> > Why don't you simply submit a patch to change the helptext then?
> 
> Is that ok ?
> 
> Discourage people from deselecting B44_PCI

To me this is ok. But I think I have no voting right here.
Uwe has to decide which helptext he would understand. ;)

> Signed-off-by: Benoit Boissinot <benoit.boissinot@ens-lyon.org>
> 
> --- kernel.orig/drivers/net/Kconfig	2007-05-26 20:38:02.000000000 +0200
> +++ kernel/drivers/net/Kconfig	2007-05-26 20:38:15.000000000 +0200
> @@ -1449,7 +1449,7 @@
>  	help
>  	  Support for b44 PCI devices.
> 
> -	  Say Y
> +	  Unless you know what you are doing, say Y here.
> 
>  config FORCEDETH
>  	tristate "nForce Ethernet support"
> 
> 



-- 
Greetings Michael.
