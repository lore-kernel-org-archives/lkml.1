Return-Path: <linux-kernel-owner+w=401wt.eu-S1760259AbYEMPlh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760259AbYEMPlh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2008 11:41:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756013AbYEMPla
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 May 2008 11:41:30 -0400
Received: from mailgw.infracomspa.it ([217.12.183.244]:1726 "EHLO
	svkmg019i.infracomspa.it" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756540AbYEMPl3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2008 11:41:29 -0400
Message-ID: <4829B6A1.90707@infracom.it>
Date: Tue, 13 May 2008 17:41:21 +0200
From: Roberto Oppedisano <roberto.oppedisano@infracom.it>
User-Agent: Mozilla-Thunderbird 2.0.0.12 (X11/20080420)
MIME-Version: 1.0
To: Stas Sergeev <stsp@aknet.ru>
CC: LKML <linux-kernel@vger.kernel.org>, Takashi Iwai <tiwai@suse.de>
Subject: Re: 2.6.26-rc1 regression: e5e1d3cb20034a3cbcfff1f0bae12201aa2ce17e
 breaks artsd
References: <482737BE.20502@infracom.it> <4827415A.7060101@aknet.ru> <482756F0.8020609@infracom.it> <48275D8D.10500@aknet.ru> <4827F0A1.9090600@infracom.it> <48288ACC.1020909@aknet.ru> <48299F08.2060702@infracom.it>
In-Reply-To: <48299F08.2060702@infracom.it>
X-Enigmail-Version: 0.95.0
X-MIMETrack: Itemize by SMTP Server on Venere/InfracomSpA/IT(Release 6.5.6|March 06, 2007) at
 05/13/2008 05:41:21 PM,
	Serialize by Router on Bacco/InfracomSpA/IT(Release 6.5.6|March 06, 2007) at
 13/05/2008 17.41.29,
	Serialize complete at 13/05/2008 17.41.29
X-TM-AS-Product-Ver: <SMD>-<3.0.1.3628>-<5.5.1026>-<15894>
X-TM-AS-Result: <No>-<-10014.861>-<5.0>-<99000>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Roberto Oppedisano wrote:
> Stas Sergeev ha scritto, Il 12/05/2008 20.22:
>> Have you made sure that everything
>> is unmuted in alsamixer and the volume
>> is at maximum?
>
> I believe so, but 'till now the speaker is not working.
> I'll try harder.
In alsamixer i see:

Item: PC Speaker [Off]

and I cant' find a way to toggle it.
With kmix I can toggle the mute setting (alsamixer still sees it off), but
no sound comes out from the speaker.
I also tried

echo -e "\a"

without the module loaded (on old kernel), and the speaker is mute.

Probably something is wrong in my env.

>> If everything fails, could you please
>> try the "nforce_wa=1" option to snd-pcsp?
>> Your chipset doesn't seem to be nforce,
>> but who knows, maybe the nforce workaround
>> will help here too...
> Will try this ASAP an report.

I tried also this but without success.
R

