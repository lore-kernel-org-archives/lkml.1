Return-Path: <linux-kernel-owner+w=401wt.eu-S1761240AbZCXQES@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761240AbZCXQES (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Mar 2009 12:04:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758030AbZCXQEB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Mar 2009 12:04:01 -0400
Received: from mail-bw0-f169.google.com ([209.85.218.169]:38864 "EHLO
	mail-bw0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754581AbZCXQD7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Mar 2009 12:03:59 -0400
Message-ID: <49C9046A.6060708@petalogix.com>
Date: Tue, 24 Mar 2009 17:03:54 +0100
From: Michal Simek <michal.simek@petalogix.com>
Reply-To: michal.simek@petalogix.com
User-Agent: Thunderbird 2.0.0.17 (X11/20081001)
MIME-Version: 1.0
To: monstr@monstr.eu
CC: linux-kernel@vger.kernel.org, john.williams@petalogix.com,
       Peter Korsgaard <jacmet@sunsite.dk>, linux-serial@vger.kernel.org
Subject: Re: [PATCH 57/57] microblaze_v7: Uartlite for Microblaze
References: <1237408284-8674-1-git-send-email-monstr@monstr.eu> <1e1dc8ccd5abc4e51272f52465c6b9e5f847f947.1237407249.git.monstr@monstr.eu> <14c123f2bae10a8b5fb76cd059ba105c212776ef.1237407249.git.monstr@monstr.eu> <4947b1131c14c1526b81493f461606018bd0f090.1237407249.git.monstr@monstr.eu> <46bc9a74719cb3c21dfdd558b93bec8c5b5675d8.1237407249.git.monstr@monstr.eu> <d3f49195b8f675db48d2eda4f09fddb51af6f946.1237407249.git.monstr@monstr.eu> <34c2f9e50610e147be556607e482b88fd674b887.1237407249.git.monstr@monstr.eu> <15f6f10873f7c6f4f3b06f9d4d5af3ee9714f873.1237407249.git.monstr@monstr.eu> <e5b88f50c39aa95431f5ecdb032c6676399ae198.1237407249.git.monstr@monstr.eu> <50253611a0770c1ae6a63702208cfb9f96cd1f1a.1237407249.git.monstr@monstr.eu> <28a81149bf51571cbc898a672efff4770fbc1efe.1237407249.git.monstr@monstr.eu> <55868bc389e07d10d00e92a1da65f31256a26f4c.1237407249.git.monstr@monstr.eu> <57d096a05c22f5b3dd1070e9ecd6e8e05b22e9b3.1237407249.git.monstr@monstr.eu>
In-Reply-To: <57d096a05c22f5b3dd1070e9ecd6e8e05b22e9b3.1237407249.git.monstr@monstr.eu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

Here is the small part of code which enable uartlite and serial of code
driver for Microblaze cpu.

Peter: I got ack from you in past. I believe that I still have it. Could
I keep your ACK there?

Thanks,
Michal
> From: Michal Simek <monstr@monstr.eu>
>
>
> Signed-off-by: Michal Simek <monstr@monstr.eu>
> ---
>  drivers/serial/Kconfig |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/serial/Kconfig b/drivers/serial/Kconfig
> index 7d7f576..131901b 100644
> --- a/drivers/serial/Kconfig
> +++ b/drivers/serial/Kconfig
> @@ -833,7 +833,7 @@ config SERIAL_IMX_CONSOLE
>  
>  config SERIAL_UARTLITE
>  	tristate "Xilinx uartlite serial port support"
> -	depends on PPC32
> +	depends on PPC32 || MICROBLAZE
>  	select SERIAL_CORE
>  	help
>  	  Say Y here if you want to use the Xilinx uartlite serial controller.
> @@ -1319,7 +1319,7 @@ config SERIAL_NETX_CONSOLE
>  
>  config SERIAL_OF_PLATFORM
>  	tristate "Serial port on Open Firmware platform bus"
> -	depends on PPC_OF
> +	depends on PPC_OF || MICROBLAZE
>  	depends on SERIAL_8250 || SERIAL_OF_PLATFORM_NWPSERIAL
>  	help
>  	  If you have a PowerPC based system that has serial ports
>   


-- 
Michal Simek, Ing. (M.Eng)
PetaLogix - Linux Solutions for a Reconfigurable World
w: www.petalogix.com p: +61-7-30090663,+42-0-721842854 f: +61-7-30090663

