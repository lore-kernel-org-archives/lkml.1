Return-Path: <linux-kernel-owner+w=401wt.eu-S1752918AbZLVDBJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752918AbZLVDBJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Dec 2009 22:01:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751372AbZLVDAv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Dec 2009 22:00:51 -0500
Received: from senator.holtmann.net ([87.106.208.187]:36379 "EHLO
	mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751210AbZLVDAt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Dec 2009 22:00:49 -0500
Subject: Re: [Patch] thinkpad_acpi: fix a build error
From: Marcel Holtmann <marcel@holtmann.org>
To: "Helight.Xu" <helight.xu@gmail.com>
Cc: Henrique de Moraes Holschuh <hmh@hmh.eng.br>, Takashi Iwai <tiwai@suse.de>,
       Xiaotian Feng <xtfeng@gmail.com>, Amerigo Wang <amwang@redhat.com>,
       linux-kernel@vger.kernel.org, Corentin Chary <corentincj@iksaif.net>,
       ibm-acpi-devel@lists.sourceforge.net, Len Brown <len.brown@intel.com>,
       Alan Jenkins <alan-jenkins@tuffmail.co.uk>, akpm@linux-foundation.org
In-Reply-To: <4B301CA3.1060704@gmail.com>
References: <20091218093132.4415.23424.sendpatchset@localhost.localdomain>
	 <7b6bb4a50912180142u5e66fa88odb7cd3b6fa1a2ba2@mail.gmail.com>
	 <s5hhbrowpty.wl%tiwai@suse.de>
	 <20091218142815.GB15898@khazad-dum.debian.net>
	 <1261435136.4041.152.camel@localhost.localdomain>
	 <4B301CA3.1060704@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 21 Dec 2009 19:00:20 -0800
Message-Id: <1261450820.4041.167.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.0 (2.28.0-2.fc12) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Helight,

> >>> The patch isn't correct (I guess the upstream fix is same?).
> >>>
> >>> CONFIG_SOUND is a global config for sound subsystem.  The relevant
> >>> functions are ALSA core part, which is CONFIG_SND.
> >>> So, the fix should be:
> >>>
> >>> 	depends on SND
> >>>
> >>> instead.
> >>>       
> >> Indeed.  Ingo already fixed that too.
> >>
> >> Although I personally would prefer:
> >> select SOUND
> >> select SND
> >>
> >> But anything that stops the build errors will do for now.
> >>     
> >
> > I still haven't seen this patch in Linus' tree. And you do need select
> > SOUND and SND. Otherwise you still get build errors. I have tested this
> > on my machine. So can someone please submit a proper patch to get this
> > fixed.
> >   
> I think my first patch about this can fix it!
> 
> http://lkml.org/lkml/2009/12/18/141
> 
> I have tested it!

either depends on SND or select SND + SOUND, but one of them has to be
pushed into Linus' tree. Personally I don't care which one.

Regards

Marcel


