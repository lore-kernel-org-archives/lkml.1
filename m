Return-Path: <linux-kernel-owner+w=401wt.eu-S1754132AbZDKAY4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754132AbZDKAY4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Apr 2009 20:24:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752192AbZDKAYm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Apr 2009 20:24:42 -0400
Received: from mail-fx0-f158.google.com ([209.85.220.158]:47790 "EHLO
	mail-fx0-f158.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752038AbZDKAYl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Apr 2009 20:24:41 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=xRkjY9dcOhyTuGWYHS+QvuJgfnKnZ7LBcqXGDmSG1wwkDdsjazpi9qd0CKcCb84+d0
         9ZbDMoPx3LQGOYHl8cchM7sYEmW5Wo9okqCjsr9Jz9uAI63mNXHuDv6T1J51TBX9Qx9c
         EZmbNP6yWOikrhnojbZDYJm12u8bP4PNTns/o=
Message-ID: <49DFE345.3010109@gmail.com>
Date: Sat, 11 Apr 2009 04:24:37 +0400
From: Alexey Starikovskiy <aystarik@gmail.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090319)
MIME-Version: 1.0
To: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
CC: linux-acpi@vger.kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>
Subject: Re: Regression: 20 ACPI interrupts per second on EEEPC 4G
References: <49DF6835.9040501@tuffmail.co.uk>
In-Reply-To: <49DF6835.9040501@tuffmail.co.uk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Alan,

This patch looks to be a suspect: 34ff4dbccccce54c83b1234d39b7ad9e548a75dd,
Please check if reversing it helps

Regards,
Alex.

Alan Jenkins wrote:
> On latest git, powertop shows 20 ACPI interrupts per second.  
> Previously, this was closer to 1 per second.  See attached output (a 
> vs b, "a" is from 2.6.29-rc8).
>
> This is from a pretty sparse KDE desktop.  Normally I run 
> gnome-power-manager, but I killed it to make sure that wasn't causing 
> any problems.
>
> alan@alan-eeepc:/sys/firmware/acpi/interrupts$ grep -v "invalid" *
> error:       0
> ff_gbl_lock:       0    enabled
> ff_pwr_btn:       0     enabled
> ff_rt_clk:       0      disabled
> gpe03:       0  disabled
> gpe04:       0  disabled
> gpe05:       0  disabled
> gpe09:       0  disabled
> gpe0B:       0  disabled
> gpe0C:       0  disabled
> gpe0D:       0  disabled
> gpe0E:       0  disabled
> gpe18:   60975  enabled
> gpe_all:   60975
> sci:   60975
>
> which I presume means lots of EC interrupts.
>
> [    0.134068] ACPI: EC: GPE = 0x18, I/O: command/status = 0x66, data 
> = 0x62
>
> Any ideas?
>
> Thanks
> Alan

