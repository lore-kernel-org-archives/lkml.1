Return-Path: <linux-kernel-owner+w=401wt.eu-S1756904AbYAJSRb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756904AbYAJSRb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jan 2008 13:17:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754326AbYAJSRX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jan 2008 13:17:23 -0500
Received: from smtp.witbe.net ([81.88.96.48]:42438 "EHLO smtp.witbe.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754225AbYAJSRW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jan 2008 13:17:22 -0500
Date: Thu, 10 Jan 2008 19:16:58 +0100
From: Paul Rolland <rol@as2917.net>
To: BERTRAND =?ISO-8859-1?Q?Jo=EBl?= <joel.bertrand@systella.fr>
Cc: sparclinux@vger.kernel.org, linux-kernel@vger.kernel.org, rol@witbe.net
Subject: Re: 3Com NIC
Message-ID: <20080110191658.49c49412@tux.DEF.witbe.net>
In-Reply-To: <4786592E.6080303@systella.fr>
References: <4786592E.6080303@systella.fr>
Organization: AS2917.net
X-Mailer: Claws Mail 3.2.0 (GTK+ 2.10.14; i686-pc-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWsjH1VRjFydFciEg3a1tJxUEM6OCB1zdsDAAACcElEQVQ4jV2Tu3LcMAxFEY7SG/KQNYlY2685Zi1rmF5kQteBNcL/f0JAacfZDUscARePK9itY3Q4Qu5vplJKIFsrvI0t7Ii/8/nmQsERtgJpHAtiGW4ggylOAwhXTxPi0xfIcxDrZIc3qhMGD/kfKdwBExZrAf6l5PeC/Al7cAGfAGD+AgvL5yckcsxegVmG+QZRPgnYXnFUMAC8DLd6QZhAxj6dRo6vT/JNkmZQmPyDtoroMkD2VlaVgHsw2QrCAf1jPM+ou2Ju1j/G8+xINfZT+zGDPDjr7H/xnKewgi6SO4D7zloYoRDafSoogmirP0t9YIOJnN2ibDEKK6zDoSEjTIFXDcYYkwizoO/AjkATm3g+JVsSXPOCZIHwj7uBo2Bi97RMOoflJ4n3b3dvS2kVXDQupjvAk7zvaMEJlu0OJDFy4SsCusRbL95jRynY0LIA/rpyxCMkJ1ie+bWoEy+MG7pzDE3k8Z2C1a5eUdxmi0adGi2mdVjyUr2uvamrW9EeuLTCY84/AUjBj40LtqYbbM23vqolA2mpj5g03gparH45DqBgmsBK2hU0x662+QQLVYJLitxTnHB7yf0es4rraS/xqKW/hF1zPg9lOijpmtIBVrWKOQ6oTSkQjh3YtnarHQc0RrtS1XjtbQnScPrLeNKM6iS+6Qz6e9mVoPvaHHPU6eP5aKu1Ifd2QQvp6EA1bLaP3VREwewXY73xgLppBR2tg4LFg9lXzegHQlusWuxwogLCaswJ+qunQ2cyfuziX6B1p0E26nQazR3Qn2jQarRXVVZT9zP3uB5FV6pNjQG+u03ugbalEsEXqo7/AjAH60VpvOMvAAAAAElFTkSuQmCC
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Thu, 10 Jan 2008 18:43:10 +0100
BERTRAND Joël <joel.bertrand@systella.fr> wrote:

> 	ifconfig returns :
> 
> eth2      Link encap:Ethernet  HWaddr 00:04:75:df:1c:6d
>            inet adr:192.168.253.1  Bcast:192.168.253.255 
> Masque:255.255.255.0
>            UP BROADCAST RUNNING MULTICAST  MTU:1500  Metric:1
>            RX packets:1019611 errors:0 dropped:0 overruns:782 frame:0
>            TX packets:1244862 errors:4389 dropped:0 overruns:0 carrier:0
>            collisions:0 lg file transmission:1000
>            RX bytes:111193503 (106.0 MiB)  TX bytes:1119932615 (1.0 GiB)
>            Interruption:17 Adresse de base:0x8000
> 
> 	and dmesg :
> 
> NETDEV WATCHDOG: eth2: transmit timed out
> eth2: transmit timed out, tx_status 00 status 8601.
>    diagnostics: net 0ccc media 8880 dma 0000003a fifo 0000
> eth2: Interrupt posted but not delivered -- IRQ blocked by another device?
>    Flags; bus-master 1, dirty 224(0) current 224(0)
>    Transmit list 00000000 vs. fffff800a05ce200.
>    0: @fffff800a05ce200  length 8000007d status 0001007d
>    1: @fffff800a05ce260  length 8000004e status 0001004e
>    2: @fffff800a05ce2c0  length 8000004a status 0001004a
>    3: @fffff800a05ce320  length 80000048 status 00010048
>    4: @fffff800a05ce380  length 8000004a status 0001004a
>    5: @fffff800a05ce3e0  length 80000042 status 00010042
>    6: @fffff800a05ce440  length 8000004e status 0001004e
>    7: @fffff800a05ce4a0  length 80000042 status 00010042
>    8: @fffff800a05ce500  length 8000004e status 0001004e
>    9: @fffff800a05ce560  length 80000048 status 00010048
>    10: @fffff800a05ce5c0  length 8000004a status 0001004a
>    11: @fffff800a05ce620  length 8000004e status 0001004e
>    12: @fffff800a05ce680  length 80000042 status 00010042
>    13: @fffff800a05ce6e0  length 80000042 status 00010042
>    14: @fffff800a05ce740  length 80000042 status 80010042
>    15: @fffff800a05ce7a0  length 80000052 status 80010052
> eth2: Resetting the Tx ring pointer.
> 
> rayleigh:[~] > cat /proc/interrupts
>             CPU0       CPU2
>    0:  561601936  561601824     <NULL>  timer
>    1:          0          0      sun4u  PSYCHO_PCIERR
>    2:          0          0      sun4u  PSYCHO_UE
>    3:          0          0      sun4u  PSYCHO_CE
>    8:     461146          0      sun4u  su(kbd)
>    9:          0    3350888      sun4u  su(mouse)
>   10:          0          0      sun4u  parport0
>   11:          2          0      sun4u  floppy
>   12:          0          0      sun4u  cs4231(capture)
>   13:     360263          0      sun4u  cs4231(play)
>   14:          0   36484826      sun4u  eth0
>   15:          0   27118288      sun4u  sym53c8xx
>   16:         30          0      sun4u  sym53c8xx
>   17:     906177    1171078      sun4u  eth2
>   18:   19345145          0      sun4u  aic7xxx
>   19:          1     584788      sun4u  ohci_hcd:usb2
>   20:          0          0      sun4u  ohci_hcd:usb3
>   21:          1        467      sun4u  ehci_hcd:usb1
>   22:          0          0      sun4u  PSYCHO_PCIERR
>   24:   27308743          0      sun4u  eth1
> rayleigh:[~] >

Is this only with eth2 ? It seems to be the only one to have interrupts
delivered to CPU0 and CPU2... 

Just my $0.02 ;)

Paul

-- 
Paul Rolland                                E-Mail : rol(at)witbe.net
Witbe.net SA                                Tel. +33 (0)1 47 67 77 77
Les Collines de l'Arche                     Fax. +33 (0)1 47 67 77 99
F-92057 Paris La Defense                    RIPE : PR12-RIPE

Please no HTML, I'm not a browser - Pas d'HTML, je ne suis pas un navigateur 
"Some people dream of success... while others wake up and work hard at it" 

"I worry about my child and the Internet all the time, even though she's too 
young to have logged on yet. Here's what I worry about. I worry that 10 or 15 
years from now, she will come to me and say 'Daddy, where were you when they 
took freedom of the press away from the Internet?'"
--Mike Godwin, Electronic Frontier Foundation 
