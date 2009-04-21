Return-Path: <linux-kernel-owner+w=401wt.eu-S1754477AbZDUNsU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754477AbZDUNsU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Apr 2009 09:48:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752218AbZDUNsJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Apr 2009 09:48:09 -0400
Received: from web32601.mail.mud.yahoo.com ([68.142.207.228]:32260 "HELO
	web32601.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751370AbZDUNsI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Apr 2009 09:48:08 -0400
Message-ID: <580320.52308.qm@web32601.mail.mud.yahoo.com>
X-YMail-OSG: xwAYUsMVM1m3uo7MSRt1_WKSJMABRXD2r95Oq4IxkSWA0WFUMDjMXZMvjKqH78Am2F9fvuhPxQqxSsyNWrtVKGyGcFMNBqYMA5H_MkUNkn4aTrGWgXp9x67XeOiRp2QKvFvvXhoHB7_Zce8ZmhX57k4AApKETZJmJp9N_qKvP244kDGYK_vvQMPGejFtQYt0lU3H55tOYqb9SPIF18YvP5Q4p8MUL9LVNOSTUBGHdr80XE6LYqcX6QKh.mjmwYvxF2PSyHaYaxv8xJTAcHjKyI3Dted8Gt2XmPdDTIip8gAP72jT2Iwg_2nUPebCkvxAa9AtkVYcApzf9dacMTofehc-
X-RocketYMMF: knobi.rm
X-Mailer: YahooMailRC/1277.35 YahooMailWebService/0.7.289.1
Date: Tue, 21 Apr 2009 06:48:07 -0700 (PDT)
From: Martin Knoblauch <spamtrap@knobisoft.de>
Subject: Re: 2.6.30-rc30-git7 build problem
To: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


----- Original Message ----

> From: Martin Knoblauch <spamtrap@knobisoft.de>
> To: linux-kernel@vger.kernel.org
> Sent: Tuesday, April 21, 2009 3:39:41 PM
> Subject: 2.6.30-rc30-git7 build problem
> 
> Hi,
> 
> when trying to build 2.6.30-rc2-git7 on x86_64 (RHEL-4.3 64-bit userspace) I get 
> at the end of "make":
> 
> 
> Root device is (104, 3)
> Setup is 12664 bytes (padded to 12800 bytes).
> System is 2651 kB
> CRC f247b280
> Kernel: arch/x86/boot/bzImage is ready  (#1)
>   Building modules, stage 2.
>   MODPOST 470 modules
> ERROR: ".L192" [drivers/usb/serial/kl5kusb105.ko] undefined!
> make[1]: *** [__modpost] Error 1
> make: *** [modules] Error 2
> 
> Config was oldconfiged  from a working 2.6.28 setup and is attached
>

 FYI  disabling   CONFIG_USB_SERIAL_KLSI solves it for me (as I really do not need it at all), but it worked on various previous kernel versions.

> Cheers
> Martin
> ------------------------------------------------------
> Martin Knoblauch
> email: k n o b i AT knobisoft DOT de
> www:  http://www.knobisoft.de

