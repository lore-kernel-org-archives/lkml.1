Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755895Ab0CDLiG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Mar 2010 06:38:06 -0500
Received: from hqemgate03.nvidia.com ([216.228.112.145]:1887 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755869Ab0CDLiE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Mar 2010 06:38:04 -0500
X-PGP-Universal: processed;
	by hqnvupgp03.nvidia.com on Thu, 04 Mar 2010 03:38:02 -0800
From: Wei Ni <wni@nvidia.com>
To: "'Takashi Iwai'" <tiwai@suse.de>
CC: "'Pavel Hofman'" <pavel.hofman@insite.cz>,
       "'alsa-devel'" <alsa-devel@alsa-project.org>,
       "'linux-kernel'" <linux-kernel@vger.kernel.org>,
       "'akpm'" <akpm@linux-foundation.org>
Date: Thu, 4 Mar 2010 19:37:52 +0800
Subject: RE: [alsa-devel] [PATCH]Support MCP89 and GT21x hdmi audio
Thread-Topic: [alsa-devel] [PATCH]Support MCP89 and GT21x hdmi audio
Thread-Index: Acq7jkIUtyUJcBcwQA+k2FWh7W2kpAAAGoug
Message-ID: <6B4D417B830BC44B8026029FD256F7F1C16B1AD556@HKMAIL01.nvidia.com>
References: <6B4D417B830BC44B8026029FD256F7F1C068B2BA8B@HKMAIL01.nvidia.com>
	<s5hmxyrp311.wl%tiwai@suse.de>
	<6B4D417B830BC44B8026029FD256F7F1C068B2BA8C@HKMAIL01.nvidia.com>
	<s5heik3ujy0.wl%tiwai@suse.de>
	<6B4D417B830BC44B8026029FD256F7F1C16A89A118@HKMAIL01.nvidia.com>
	<6B4D417B830BC44B8026029FD256F7F1C16A89A11A@HKMAIL01.nvidia.com>
	<s5haaupoqew.wl%tiwai@suse.de>
	<6B4D417B830BC44B8026029FD256F7F1C16A89A11C@HKMAIL01.nvidia.com>
	<s5htysxm5yo.wl%tiwai@suse.de>
	<6B4D417B830BC44B8026029FD256F7F1C16B1AD54C@HKMAIL01.nvidia.com>
	<s5hzl2ol8qu.wl%tiwai@suse.de>
	<6B4D417B830BC44B8026029FD256F7F1C16B1AD554@HKMAIL01.nvidia.com>
	<s5h1vg0qrrr.wl%tiwai@suse.de>
	<6B4D417B830BC44B8026029FD256F7F1C16B1AD555@HKMAIL01.nvidia.com>
 <s5hwrxspblg.wl%tiwai@suse.de>
In-Reply-To: <s5hwrxspblg.wl%tiwai@suse.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Do you mean you will check in my patch first, and then I give you the
additional patch for adding EXPORT_SYMBOL() in hda_eld.c?

-----Original Message-----
From: Takashi Iwai [mailto:tiwai@suse.de] 
Sent: Thursday, March 04, 2010 7:31 PM
To: Wei Ni
Cc: 'Pavel Hofman'; 'alsa-devel'; 'linux-kernel'; 'akpm'
Subject: Re: [alsa-devel] [PATCH]Support MCP89 and GT21x hdmi audio

At Thu, 4 Mar 2010 19:09:29 +0800,
Wei Ni wrote:
> 
> Hi, Takashi
> I test my patch, it build successful when CONFIG_SND_HDA_*=y.
> Could you give me your build error messages?

Sorry, it's CONFIG_SND_HDA*=m.  Then load two modules, so you'll have
two identical objects in different modules.

OTOH, if it's no exported symbol, it might coexist.  Hmm.

If you get no errors with it, then it's fine as an intermediate state.
Please give the additional patch on them for further fixes.


thanks,

Takashi

> 
> Thanks
> Wei.
> nvpublic
> 
> -----Original Message-----
> From: Takashi Iwai [mailto:tiwai@suse.de] 
> Sent: Thursday, March 04, 2010 6:57 PM
> To: Wei Ni
> Cc: 'Pavel Hofman'; 'alsa-devel'; 'linux-kernel'; 'akpm'
> Subject: Re: [alsa-devel] [PATCH]Support MCP89 and GT21x hdmi audio
> 
> At Thu, 4 Mar 2010 18:46:59 +0800,
> Wei Ni wrote:
> > 
> > Hi, Takashi
> > I think we can submit my patch first,
> 
> But your patch breaks the build when CONFIG_SND_HDA_*=y.
> So, it should be fixed in your patch.
> 
> 
> thanks,
> 
> Takashi
> 
> > then generate another patch
> > to add EXPORT_SYMBOL() in hda_eld.c, and change Makefile to remove
> > hda_eld.o from snd-hda-codec-xxhdmi-objs.
> > 
> > Thanks
> > Wei.
> > nvpublic
> > 
> > -----Original Message-----
> > From: Takashi Iwai [mailto:tiwai@suse.de] 
> > Sent: Thursday, March 04, 2010 5:47 PM
> > To: Wei Ni
> > Cc: 'Pavel Hofman'; 'alsa-devel'; 'linux-kernel'; 'akpm'
> > Subject: Re: [alsa-devel] [PATCH]Support MCP89 and GT21x hdmi audio
> > 
> > At Thu, 4 Mar 2010 10:21:39 +0800,
> > Wei Ni wrote:
> > > 
> > > Hi, Takashi
> > > 1. Yes, it can works for all Nvidia controller.
> > 
> > OK.
> > 
> > > 2. The hda_eld.o doesn't export any symbols.
> > > I tried to put hda_eld.o to snd-had-codec-*, and remove had_eldo.o
> > > from snd-had-codec-intelhdmi-objs, but it will build error. It need
> > > to modify hda_eld.c to export symbols, it will add many changes.
> > 
> > Yes, this is unavoidable.  Please add EXPORT_SYMBOL()'s
> > appropriately.
> > 
> > We can reduce them again once after all HDMI stuff is merged into
> > one.
> > 
> > 
> > thanks,
> > 
> > Takashi
> > 
> 
