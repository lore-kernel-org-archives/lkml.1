Return-Path: <linux-kernel-owner+w=401wt.eu-S1752651AbZIBINz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752651AbZIBINz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Sep 2009 04:13:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752113AbZIBINy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Sep 2009 04:13:54 -0400
Received: from mail-yx0-f181.google.com ([209.85.210.181]:43973 "EHLO
	mail-yx0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752014AbZIBINx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Sep 2009 04:13:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:subject:message-id:user-agent:x-archive:mime-version
         :content-type;
        b=QtjKQgs8U/xpIHE1FJqZwhaof9rOyztFYYLNpu6DTZp7ByOM2X3TQG+8V2CnoJD674
         K51iiYgA996V5dhMmadpyFqw7u9vT847A1qdhcxN0hij3fMOg/FgQEQDAX4S0me4hf3c
         qVP8Wh21AQc09klvOMjelE7ENO0ANSUSFvREg=
Date: Wed, 2 Sep 2009 05:13:50 -0300 (BRST)
From: "=?ISO-8859-15?Q?Fr=E9d=E9ric_L=2E_W=2E_Meunier?=" 
	<fredlwm@gmail.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: BIOS bug ? "Unlink after no-IRQ?" rebooting from Windows
Message-ID: <alpine.LNX.2.01.0909020503460.12944@pervalidus>
User-Agent: Alpine 2.01 (LNX 1184 2008-12-16)
X-Archive: encrypt
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I bought a Gigabyte GA-MA69VM-S2 more than a year ago. Since 
then, rebooting from Windows directly to Linux makes my USB 
mouse unusable. It just turns out and dmesg displays

"ohci_hcd 0000:00:13.0: Unlink after no-IRQ?  Controller is 
probably using the wrong IRQ."

But I can workaround that. Not booting on Windows (Vista or 7) ? 
Sure. But also going to the BIOS and changing the "USB Mouse" 
option from "Enable" to "Disable", or from "Disable" to 
"Enable" before booting on Linux.

Is there a workaround in the kernel itself ?
