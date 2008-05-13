Return-Path: <linux-kernel-owner+w=401wt.eu-S1760382AbYEMOA6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760382AbYEMOA6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2008 10:00:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757195AbYEMOAt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 May 2008 10:00:49 -0400
Received: from mailgw.infracomspa.it ([217.12.183.244]:3536 "EHLO
	svkmg019i.infracomspa.it" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1757841AbYEMOAs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2008 10:00:48 -0400
Message-ID: <48299F08.2060702@infracom.it>
Date: Tue, 13 May 2008 16:00:40 +0200
From: Roberto Oppedisano <roberto.oppedisano@infracom.it>
Organization: Infracom Network Application
User-Agent: Thunderbird 2.0.0.14 (Windows/20080421)
MIME-Version: 1.0
To: Stas Sergeev <stsp@aknet.ru>
CC: LKML <linux-kernel@vger.kernel.org>, Takashi Iwai <tiwai@suse.de>
Subject: Re: 2.6.26-rc1 regression: e5e1d3cb20034a3cbcfff1f0bae12201aa2ce17e
 breaks artsd
References: <482737BE.20502@infracom.it> <4827415A.7060101@aknet.ru> <482756F0.8020609@infracom.it> <48275D8D.10500@aknet.ru> <4827F0A1.9090600@infracom.it> <48288ACC.1020909@aknet.ru>
In-Reply-To: <48288ACC.1020909@aknet.ru>
X-Enigmail-Version: 0.95.6
X-MIMETrack: Itemize by SMTP Server on Venere/InfracomSpA/IT(Release 6.5.6|March 06, 2007) at
 05/13/2008 04:00:41 PM,
	Serialize by Router on Bacco/InfracomSpA/IT(Release 6.5.6|March 06, 2007) at
 13/05/2008 16.00.48,
	Serialize complete at 13/05/2008 16.00.48
X-TM-AS-Product-Ver: <SMD>-<3.0.1.3628>-<5.5.1026>-<15894>
X-TM-AS-Result: <No>-<-10011.680>-<5.0>-<99000>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stas Sergeev ha scritto, Il 12/05/2008 20.22:
> Hello.
> 
> Roberto Oppedisano wrote:
>> With the supplied conf (and without the module option) artsd does not crash
>> anymore (no sound from pc speaker but that's not an issue, my alsa-lib is
>> still 1.0.16).
> That's rather bad. :( With the proper
> config and alsa-lib 1.0.16 it was supposed
> to work...
> Do the speaker beeps work?

I tried the funcionality using "the other OS" and the speaker is working.

> Like those made by
> ---
> echo -e "\a"
> ---
> command.

This is non working.

> Have you made sure that everything
> is unmuted in alsamixer and the volume
> is at maximum?

I believe so, but 'till now the speaker is not working.
I'll try harder.

> If everything fails, could you please
> try the "nforce_wa=1" option to snd-pcsp?
> Your chipset doesn't seem to be nforce,
> but who knows, maybe the nforce workaround
> will help here too...

Will try this ASAP an report.

Kind regards

R

