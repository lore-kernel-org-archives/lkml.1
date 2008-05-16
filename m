Return-Path: <linux-kernel-owner+w=401wt.eu-S1757939AbYEPNPm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757939AbYEPNPm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2008 09:15:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752131AbYEPNPf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 May 2008 09:15:35 -0400
Received: from sovereign.computergmbh.de ([85.214.69.204]:33169 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751888AbYEPNPe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2008 09:15:34 -0400
Date: Fri, 16 May 2008 15:15:32 +0200 (CEST)
From: Jan Engelhardt <jengelh@medozas.de>
To: Stas Sergeev <stsp@aknet.ru>
cc: Roberto Oppedisano <roberto.oppedisano@infracom.it>,
       Takashi Iwai <tiwai@suse.de>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: Non-working snd-pcsp
In-Reply-To: <482C9F3E.4050104@aknet.ru>
Message-ID: <alpine.LNX.1.10.0805161514190.15590@fbirervta.pbzchgretzou.qr>
References: <482737BE.20502@infracom.it> <4827415A.7060101@aknet.ru> <482756F0.8020609@infracom.it> <48275D8D.10500@aknet.ru> <4827F0A1.9090600@infracom.it> <48288ACC.1020909@aknet.ru> <48299F08.2060702@infracom.it> <4829B6A1.90707@infracom.it>
 <s5h7idycfmf.wl%tiwai@suse.de> <482A7A17.8070706@infracom.it> <s5hwslxb3t8.wl%tiwai@suse.de> <482C9A3E.3000009@infracom.it> <482C9F3E.4050104@aknet.ru>
User-Agent: Alpine 1.10 (LNX 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Thursday 2008-05-15 22:38, Stas Sergeev wrote:
>> I tried different switch combination with  alsamixer, but no still no
>> sound from the speaker...
>Both no beeps and no PCM?
>Please show us your current full
>mixer config again.
>Please don't forget to try the
>options snd-pcsp nforce_wa=1
>too.
>
>> (I managed to enable the speaker, following Stas suggestion)
>With the master volume at maximum?
>Then I am almost out of ideas... :(

If it does not even beep when issuing Ctrl-G on the shell,
you probably need to modprobe pcspkr, if it is not built-in.
(At least this is with kernels a little less
recent than 2.6.25. )
