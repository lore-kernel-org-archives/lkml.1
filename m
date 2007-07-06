Return-Path: <linux-kernel-owner+w=401wt.eu-S1762766AbXGFH5T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762766AbXGFH5T (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jul 2007 03:57:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757967AbXGFH5L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Jul 2007 03:57:11 -0400
Received: from moutng.kundenserver.de ([212.227.126.188]:54633 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757822AbXGFH5K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jul 2007 03:57:10 -0400
Message-ID: <468DF5D9.4040803@anagramm.de>
Date: Fri, 06 Jul 2007 09:57:13 +0200
From: Clemens Koller <clemens.koller@anagramm.de>
User-Agent: Thunderbird 2.0.0.4 (Windows/20070604)
MIME-Version: 1.0
To: Bodo Eggert <7eggert@gmx.de>
CC: linux-kernel@vger.kernel.org
Subject: Re: [RFC][PATCH] introduce panic_gently
References: <Pine.LNX.4.58.0707060034330.18989@be1.lrz>
In-Reply-To: <Pine.LNX.4.58.0707060034330.18989@be1.lrz>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Provags-ID: V01U2FsdGVkX18HMQlzmdGpTAPR4kF2KC/iSITCe50DdQFFbuM
 TZ1piX4HUehb9Kxvc6OYEC4nro/BI5vEQw9wqfWMwvrygf8icb
 JBcye8K6T8LbydW5CS6hw==
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Bodo Eggert schrieb:
> If the boot process failes to find init or the root fs, the cause has 
> usually scrolled off the screen, and because of the panic, it can't be 
> reached anymore.
> 
> This patch introduces panic_gently, which will allow to use the scrollback 
> buffer and to reboot, but it can't be called from unsafe context.

In the case where you introduced panic_gently() there is IMHO no reason
to panic() at all. There is no bug which got hit, the machine just needs
user intervention because of wrong boot parameters (in most cases).

What about asking the user for the correct root= or init= parameters
and just retry/continue the boot process?

The 180seconds reboot timeout also doesn't make sense here. The problem
won't go away after a reboot without user interaction.

Regards,
-- 
Clemens Koller
_______________________________
R&D Imaging Devices
Anagramm GmbH
Rupert-Mayer-Str. 45/1
81379 Muenchen
Germany

http://www.anagramm-technology.com
Phone: +49-89-741518-50
Fax: +49-89-741518-19
