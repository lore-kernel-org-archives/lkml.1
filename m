Return-Path: <linux-kernel-owner+w=401wt.eu-S1762689AbYBLLhB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762689AbYBLLhB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2008 06:37:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761476AbYBLLgy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Feb 2008 06:36:54 -0500
Received: from mu-out-0910.google.com ([209.85.134.190]:52229 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761214AbYBLLgx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2008 06:36:53 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-disposition:content-type:content-transfer-encoding:message-id;
        b=Oof3QoqouJusgJeUyCLzEf+SKtxgJc+WVvPfMsMCS2ORcDdJ8YRKyd5FRgbAxk6GhuUvPw/o+2iCRb/J7rqq245NTAsbsdZa3kAdUq7inz7b+UcUF/yg30VVpxTsHQhz99ypBXGLIn2Ls/HdtdMmAq8Qw3uPF0v0A6E7BhyY8lQ=
From: Matej Laitl <strohel@gmail.com>
To: Takashi Iwai <tiwai@suse.de>
Subject: Re: [ALSA] HDA: no sound in headphone-out caused by commit f889fa91ad47e (2.6.25-rc1 regression)
Date: Tue, 12 Feb 2008 12:36:43 +0100
User-Agent: KMail/1.9.7
Cc: Jaroslav Kysela <perex@perex.cz>, alsa-devel <alsa-devel@alsa-project.org>,
       LKML <linux-kernel@vger.kernel.org>
References: <200802112158.41989.strohel@gmail.com> <200802121150.36743.strohel@gmail.com> <s5h7ihav3nr.wl%tiwai@suse.de>
In-Reply-To: <s5h7ihav3nr.wl%tiwai@suse.de>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200802121236.43523.strohel@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Takashi Iwai wrote:
> Thanks.  It seems that your device has two headphone jacks according
> to the BIOS setup, and this seems to be the problem.
>
> Could you show the kernel messages like "autoconfig: line_outs..." for
> both cases?  This appears when build with CONFIG_SND_DEBUG=y.

Kernel with broken sound:
hda_codec: Unknown model for ALC262, trying auto-probe from BIOS...
autoconfig: line_outs=1 (0x14/0x0/0x0/0x0/0x0)
   speaker_outs=0 (0x0/0x0/0x0/0x0/0x0)
   hp_outs=2 (0x1b/0x15/0x0/0x0/0x0)
   mono: mono_out=0x0
   inputs: mic=0x18, fmic=0x19, line=0x0, fline=0x0, cd=0x0, aux=0x0

Kernel with fine sound:
hda_codec: Unknown model for ALC262, trying auto-probe from BIOS...
autoconfig: line_outs=1 (0x14/0x0/0x0/0x0/0x0)
   speaker_outs=0 (0x0/0x0/0x0/0x0/0x0)
   hp_outs=2 (0x15/0x1b/0x0/0x0/0x0)
   mono: mono_out=0x0
   inputs: mic=0x18, fmic=0x19, line=0x0, fline=0x0, cd=0x0, aux=0x0

The machine has just headphone-out and mic-in audio connector, but it is 
equipped with port replicator connector, which may feature additional audio 
ports. (and which I unfortunately do not own)

Thanks, Matej
