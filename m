Return-Path: <linux-kernel-owner+w=401wt.eu-S1756230AbYLJXeq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756230AbYLJXeq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2008 18:34:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754011AbYLJXei
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Dec 2008 18:34:38 -0500
Received: from mtaout02-winn.ispmail.ntl.com ([81.103.221.48]:37977 "EHLO
	mtaout02-winn.ispmail.ntl.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752603AbYLJXeh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2008 18:34:37 -0500
Message-ID: <494051A1.6090906@gentoo.org>
Date: Wed, 10 Dec 2008 23:32:49 +0000
From: Daniel Drake <dsd@gentoo.org>
User-Agent: Thunderbird 2.0.0.18 (X11/20081121)
MIME-Version: 1.0
To: zach@vmware.com, gentoo@thebacks.co.uk
CC: kernel@gentoo.org, linux kernel <linux-kernel@vger.kernel.org>,
       "Dyks, Axel (XL)" <xl@xlsigned.net>
Subject: VMI not initializing in certain configurations
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Cloudmark-Analysis: v=1.0 c=1 a=EaJRSiWPJ40A:10 a=7mOBRU54AAAA:8 a=tRXJAk--zTB33xVnwDAA:9 a=_omX2OlgEl97mWh1wHUA:7 a=SRedMBL7QD9MpgD000WDpbzsMPYA:4 a=50e4U0PicR4A:10
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Zach,

Thanks for your help on the VMI-related 2.6.27.x regression. I'm hoping
to now pick your mind on a similar but unrelated issue:

Norman has found that with certain kernel configurations, 2.6.27 (plain,
as released by Linus) does not initialize VMI properly, witnessed as
missing initialization messages in the kernel logs. Other configurations
work fine. These are the messages that go missing:

    VMI: Found VMware, Inc. Hypervisor OPROM, API version 3.0, ROM 
version 1.0
    vmi: registering clock event vmi-timer. mult=12582912 shift=22
    Booting paravirtualized kernel on vmi

Do you have any immediate ideas as to what the responsible config 
option(s) might be? It may well be a configuration error, but if that's 
the case then perhaps we could produce a CONFIG_VMI documentation patch 
for that.

Here is the bug report:
https://bugs.gentoo.org/show_bug.cgi?id=250094

Here is the working config:
https://bugs.gentoo.org/attachment.cgi?id=174901&action=view

and here is the broken config:
https://bugs.gentoo.org/attachment.cgi?id=174870&action=view

If you don't have any immediate ideas, say so and hopefully Norman will 
then be able to spend some time "bisecting" the config differences.

cheers
Daniel

