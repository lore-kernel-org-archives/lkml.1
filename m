Return-Path: <linux-kernel-owner+w=401wt.eu-S1752980AbZAaGsS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752980AbZAaGsS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Jan 2009 01:48:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751265AbZAaGsF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 31 Jan 2009 01:48:05 -0500
Received: from wf-out-1314.google.com ([209.85.200.171]:27055 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751387AbZAaGsD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Jan 2009 01:48:03 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=nWu6RIY3W8uE8OGVr80XuGYZYSVXlgBE/aGWc2neSvQeoYS0DlTrLEBCoT/xcoLlJi
         v4xclzA3C+AznqliTbwlk998TxDZxO3UeHQF3FdvSEyk0+QpHhzpG+uLdC1P9Q3Sxzto
         yHnioGDGmhjmpZtuZBe2GXM+vjCQTJ+zxphGk=
Message-ID: <4983F420.6060407@gmail.com>
Date: Fri, 30 Jan 2009 22:48:00 -0800
From: "Justin P. Mattock" <justinmattock@gmail.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20090103)
MIME-Version: 1.0
To: Soeren Sonnenburg <kernel@nn7.de>
CC: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.29-rc3+git macbook pro1,1 garbled display on resume
References: <1233348609.3707.6.camel@localhost>
In-Reply-To: <1233348609.3707.6.camel@localhost>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Soeren Sonnenburg wrote:
> Hi,
>
> the macbook pro suspends just fine, but even though the machine returns
> to X I see on resume some random garbled output but can still move the
> mouse cursor (which is OK!) and using the keyboard successfully adjust
> the brightness of the display.
>
> However I cannot switch to the console (via ctrl+alt+f1) nor does ctrl
> +alt+backspace do anything....
>
> This is on debian sid with the latest xorg radeon driver from
> experimental, i.e. ii  xserver-xorg-video-radeon
> 1:6.9.0.91-1.
>
> Any ideas?
> Soeren
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
>   
here's the entry for xorg.conf:

Section "ServerFlags"
     Option "AutoAddDevices" "False"
EndSection

regards;

Justin P. Mattock
