Return-Path: <linux-kernel-owner+w=401wt.eu-S1764601AbYEARhR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764601AbYEARhR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 May 2008 13:37:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758835AbYEARg7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 May 2008 13:36:59 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:51877 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758838AbYEARg7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 May 2008 13:36:59 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Message-ID: <4819FF99.6020504@s5r6.in-berlin.de>
Date: Thu, 01 May 2008 19:36:25 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.13) Gecko/20080419 SeaMonkey/1.1.9
MIME-Version: 1.0
To: Samuel Thibault <samuel.thibault@ens-lyon.org>
CC: Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
       akpm@osdl.org, torvalds@osdl.org
Subject: Re: This month's price for the most useless new Kconfig help text
 ...
References: <20080501120959.GA16700@basil.nowhere.org> <20080501131900.GL4797@implementation.uk.xensource.com>
In-Reply-To: <20080501131900.GL4797@implementation.uk.xensource.com>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Samuel Thibault wrote:
> --- linux/drivers/accessibility/Kconfig.orig	2008-05-01 14:13:03.000000000 +0100
> +++ linux/drivers/accessibility/Kconfig	2008-05-01 14:12:50.000000000 +0100
> @@ -3,6 +3,13 @@
>  	---help---
>  	  Enable a submenu where accessibility items may be enabled.
>  
> +	  Accessibility handles all special kinds of hardware devices or
> +	  software adapters which help people with disabilities (e.g.
> +	  blindness) to use computers.
> +
> +	  That includes braille devices, speech synthesis, keyboard
> +	  remapping, etc.
> +
>  	  If unsure, say N.

Would you mind replacing also the first sentence by something which 
indicates whether this option alone already changes the kernel build?

Look at the help texts of other menuconfig option items.  Random pick: 
NETDEV_1000:
	[...]
	Say Y here to get to see options for Gigabit Ethernet drivers.
	This option alone does not add any kernel code.
	[...]
	If you say N, all options in this submenu will be skipped and
	disabled.
-- 
Stefan Richter
-=====-==--- -=-= ----=
http://arcgraph.de/sr/
