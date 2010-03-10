Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754780Ab0CJH6s (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Mar 2010 02:58:48 -0500
Received: from mail1.perex.cz ([212.20.107.53]:47529 "EHLO mail1.perex.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751446Ab0CJH6q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Mar 2010 02:58:46 -0500
Date: Wed, 10 Mar 2010 08:58:16 +0100 (CET)
From: Jaroslav Kysela <perex@perex.cz>
To: VDR User <user.vdr@gmail.com>
cc: Wu Fengguang <fengguang.wu@intel.com>, Wei Ni <wni@nvidia.com>,
       Takashi Iwai <tiwai@suse.de>, alsa-devel <alsa-devel@alsa-project.org>,
       Jaroslav Kysela <jkysela@redhat.com>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       akpm <akpm@linux-foundation.org>, Pavel Hofman <pavel.hofman@insite.cz>
Subject: Re: [alsa-devel] [PATCH]Support MCP89 and GT21x hdmi audio
In-Reply-To: <a3ef07921003092142g23b93903v2b4af9c6b691bea0@mail.gmail.com>
Message-ID: <alpine.LNX.2.00.1003100856420.4672@eeebox2.perex-int.cz>
References: <s5h1vg0qrrr.wl%tiwai@suse.de> <s5hwrxspblg.wl%tiwai@suse.de> <6B4D417B830BC44B8026029FD256F7F1C16B1AD556@HKMAIL01.nvidia.com> <s5htyswpb18.wl%tiwai@suse.de> <6B4D417B830BC44B8026029FD256F7F1C16B1AD557@HKMAIL01.nvidia.com> <s5hvddcnlr6.wl%tiwai@suse.de>
 <6B4D417B830BC44B8026029FD256F7F1C16B1AD558@HKMAIL01.nvidia.com> <a3ef07921003071121r24979a0breac27e3b0475bbcb@mail.gmail.com> <6B4D417B830BC44B8026029FD256F7F1C16B1AD562@HKMAIL01.nvidia.com> <20100308044614.GA29026@localhost>
 <a3ef07921003092142g23b93903v2b4af9c6b691bea0@mail.gmail.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="8323584-236765046-1268207896=:4672"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323584-236765046-1268207896=:4672
Content-Type: TEXT/PLAIN; charset=UTF-8; format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE

On Tue, 9 Mar 2010, VDR User wrote:

> On Sun, Mar 7, 2010 at 8:46 PM, Wu Fengguang <fengguang.wu@intel.com> wro=
te:
>> CC Jaroslav, maybe he has some idea on
>>
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0pcm_hw.c: snd_pcm_hw_delay() SNDRV_PCM_IOCTL_=
DELAY failed.
>>
>> On Mon, Mar 08, 2010 at 12:35:37PM +0800, Wei Ni wrote:
>>> Hi,
>>> Because I don't have GT220 card on hand, I didn't test it yet.
>>> So I didn't add this card to the patch file. I think you could add it a=
fter
>>> you test it.
>>>
>>> About the warning messages, I don't know why.
>>> May be some others can answer.
>>>
>>> Thanks
>>> Wei.
>>> nvpublic
>>>
>>> -----Original Message-----
>>> From: VDR User [mailto:user.vdr@gmail.com]
>>> Sent: Monday, March 08, 2010 3:22 AM
>>> To: Wei Ni
>>> Cc: Takashi Iwai; akpm; alsa-devel; Wu Fengguang; linux-kernel; Pavel H=
ofman
>>> Subject: Re: [alsa-devel] [PATCH]Support MCP89 and GT21x hdmi audio
>>>
>>> I think this may be relevant to this subject, if not then my apologies.
>>>
>>> I've just installed a GT220 card and was able to get audio-over-hdmi
>>> working by compiling the snapshot drivers from 20100307 which contain
>>> Wei's new code. =C2=A0I further had to patch the driver to recognize my
>>> card with:
>>>
>>> --- alsa-driver-orig/alsa-kernel/pci/hda/patch_nvhdmi.c 2010-03-06
>>> 18:00:12.000000000 -0800
>>> +++ alsa-driver/alsa-kernel/pci/hda/patch_nvhdmi.c =C2=A0 =C2=A0 =C2=A0=
2010-03-06
>>> 18:02:00.000000000 -0800
>>> @@ -1335,6 +1335,8 @@ static struct hda_codec_preset snd_hda_p
>>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 .patch =3D patch_nvhdmi_8ch_89 },
>>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 { .id =3D 0x10de000b, .name =3D "GT21x HDMI=
",
>>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 .patch =3D patch_nvhdmi_8ch_89 },
>>> + =C2=A0 =C2=A0 =C2=A0 { .id =3D 0x10de000a, .name =3D "GT220 HDMI",
>>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 .patch =3D patch_nvhdmi_8ch_89 },
>>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 { .id =3D 0x10de000d, .name =3D "GT240 HDMI=
",
>>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 .patch =3D patch_nvhdmi_8ch_89 },
>>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 {} /* terminator */
>>> @@ -1347,6 +1349,7 @@ MODULE_ALIAS("snd-hda-codec-id:10de0006"
>>> =C2=A0MODULE_ALIAS("snd-hda-codec-id:10de0007");
>>> =C2=A0MODULE_ALIAS("snd-hda-codec-id:10de0067");
>>> =C2=A0MODULE_ALIAS("snd-hda-codec-id:10de8001");
>>> +MODULE_ALIAS("snd-hda-codec-id:10de000a");
>>> =C2=A0MODULE_ALIAS("snd-hda-codec-id:10de000c");
>>> =C2=A0MODULE_ALIAS("snd-hda-codec-id:10de000b");
>>> =C2=A0MODULE_ALIAS("snd-hda-codec-id:10de000d");
>>>
>>> This seems to work fine when running VDR but if I do anything else
>>> like upgrade packages, compile something, or maybe create a bz2, then
>>> I start to see _a lot_ of the following in my xine log:
>>>
>>> pcm_hw.c: snd_pcm_hw_delay() SNDRV_PCM_IOCTL_DELAY failed.
>>>
>>> With the old code this didn't happen. =C2=A0However, my setup was an 84=
00gs
>>> using SPDIF OUT from my mainboard to SPDIF IN on the card. =C2=A0Then u=
sing
>>> a dvi->hdmi cable into the tv.
>>>
>>> Again, I apologize if I'm posting this in the wrong place.
>>>
>>> Best regards.
>
> So nobody has any ideas at all?  This is turning out to be a big
> problem and I've discovered it will occur even without anything else
> happening on the system.  (originally I thought you needed to do some
> other activity.)  I've checked with some other devs I know and
> everyone has said the problem is with alsa so it would seem there is a
> serious bug somewhere since eventually those errors will happen and
> the audio will start skipping like crazy.
>
> Please let me know if there's anything I can do within my ability to help=
=2E

Could you do strace for ALSA ioctls? At least having the error code might=
=20
help to identify this issue.

 =09=09=09=09=09Jaroslav

-----
Jaroslav Kysela <perex@perex.cz>
Linux Kernel Sound Maintainer
ALSA Project, Red Hat, Inc.

--8323584-236765046-1268207896=:4672--
