Return-Path: <linux-kernel-owner+w=401wt.eu-S1758601AbYEKU2s@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758601AbYEKU2s (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 May 2008 16:28:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753441AbYEKU2l
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 May 2008 16:28:41 -0400
Received: from mailgw.infracomspa.it ([217.12.183.244]:4219 "EHLO
	svkmg019i.infracomspa.it" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751601AbYEKU2k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 May 2008 16:28:40 -0400
Message-ID: <482756F0.8020609@infracom.it>
Date: Sun, 11 May 2008 22:28:32 +0200
From: Roberto Oppedisano <roberto.oppedisano@infracom.it>
User-Agent: Mozilla-Thunderbird 2.0.0.12 (X11/20080420)
MIME-Version: 1.0
To: Stas Sergeev <stsp@aknet.ru>
CC: LKML <linux-kernel@vger.kernel.org>, Takashi Iwai <tiwai@suse.de>
Subject: Re: 2.6.26-rc1 regression: e5e1d3cb20034a3cbcfff1f0bae12201aa2ce17e
 breaks artsd
References: <482737BE.20502@infracom.it> <4827415A.7060101@aknet.ru>
In-Reply-To: <4827415A.7060101@aknet.ru>
X-Enigmail-Version: 0.95.0
X-MIMETrack: Itemize by SMTP Server on Venere/InfracomSpA/IT(Release 6.5.6|March 06, 2007) at
 05/11/2008 10:28:33 PM,
	Serialize by Router on Bacco/InfracomSpA/IT(Release 6.5.6|March 06, 2007) at
 11/05/2008 22.28.39,
	Serialize complete at 11/05/2008 22.28.39
X-TM-AS-Product-Ver: <SMD>-<3.0.1.3628>-<5.5.1026>-<15894>
X-TM-AS-Result: <No>-<-10009.581>-<5.0>-<99000>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

Stas Sergeev wrote:
> Hello.
>
> Roberto Oppedisano wrote:
>   
>> artsd (kde sound daemon) is broken on current git for my system.
>>
>> git-bisect reveals the following patch as the culprit:
>>
>> commit e5e1d3cb20034a3cbcfff1f0bae12201aa2ce17e
>> Author: Stas Sergeev <stsp@aknet.ru>
>> Date:   Wed May 7 12:39:56 2008 +0200
>>
>>     pcspkr: fix dependancies
>>     
> []
>   
>> More info on request.
>>     
> cat /proc/asound/cards
>   
 0 [pcsp           ]: PC-Speaker - pcsp
                      Internal PC-Speaker at port 0x61
 1 [I82801DBICH4   ]: ICH4 - Intel 82801DB-ICH4
                      Intel 82801DB-ICH4 with AD1981B at irq 10
 2 [Modem          ]: ICH-MODEM - Intel 82801DB-ICH4 Modem
                      Intel 82801DB-ICH4 Modem at irq 10
> I guess you simply got the pc-speaker driver
> loaded first and became your primary sound
> driver, which is not what you want.
>   
yes, that's true. Anyway in this case the sound server crashes with a
signal 6.
Passing -D dsp1 to artsd avoids the crash, but I can't hear sound coming out
from the speakers (this could be my fault, have to investigate a little
bit more).

Kind regards
R
