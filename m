Return-Path: <linux-kernel-owner+w=401wt.eu-S1754562AbYEYElR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754562AbYEYElR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 May 2008 00:41:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751568AbYEYElG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 May 2008 00:41:06 -0400
Received: from ti-out-0910.google.com ([209.85.142.184]:28234 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751545AbYEYElE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 May 2008 00:41:04 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=P/DxVvtBiBQ1Tqz8RKUZ4wnPsLQHdIPwULBzebXPTJ1/Lac5fM/WcnAp5DBK9K3oOXMgcfjzQRHlIMehi4hGw+Ok4a7ZbWE67W4H51Kcnm3cbCshIYVqrTbadwuXNDg/t6khkFPH/bsCphrU7fL3fHKvZy9BfROj9qpPzHjBs8U=
Message-ID: <438397970805242141l3f07e6e1he5805b09d9dbf989@mail.gmail.com>
Date: Sat, 24 May 2008 21:41:00 -0700
From: "Kallol Biswas" <nucleodyne@gmail.com>
To: "Takashi Iwai" <tiwai@suse.de>
Subject: Re: HDMI Audio Support in ALSA
Cc: "Clemens Ladisch" <clemens@ladisch.de>,
       "Lee Revell" <rlrevell@joe-job.com>, linux-kernel@vger.kernel.org,
       "Xiaogeng Jin" <xiaogeng.jin@yahoo.com>
In-Reply-To: <s5hod6xuvq3.wl%tiwai@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <438397970805190904i2656337dh26a3257fe52aa29d@mail.gmail.com>
	 <75b66ecd0805190916r7ce21667laf19783dfa47cdd7@mail.gmail.com>
	 <438397970805190938t195d9a8ejfd5b0ca1409714ab@mail.gmail.com>
	 <48328771.4030804@ladisch.de>
	 <438397970805211252u1d228ad8wcb1a6ef9b1251478@mail.gmail.com>
	 <483568BD.4040701@ladisch.de> <s5hod6xuvq3.wl%tiwai@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Takashi,
                   I have been reading the pci/hda code, and now not
sure if I have the answer to my original question.

The routine snd_hda_calc_stream_format() calls snd_pcm_format_width()
to find if the format is supported and the width.

The array holds pcm_format[] holds all the supported formats. However,
in this array
there is no entry for IEC 60958 or IEC 61937. How does it work? How
does the hda code
handles the above frames?

It seems that snd_hda_calc_stream_format() is going to print "invalid
format width < val>" for HDMI audio frames.

Kallol

On 5/23/08, Takashi Iwai <tiwai@suse.de> wrote:
> At Thu, 22 May 2008 14:36:13 +0200,
>
> Clemens Ladisch wrote:
>  >
>  > > However, SNDRV_PCM_FMTBIT_IEC958_SUBFRAME is supported.
>  >
>  > This is only for some early revisions of the CMI8738 chip which require
>  > software to generate the preamble/channel status/subcode/parity bits
>  > for each subframe.
>
>
> Some ATIIXP boards need it, too.  HD-audio controllers can do also
>  this kind of things, but not needed.
>
>
>
>  Takashi
>
