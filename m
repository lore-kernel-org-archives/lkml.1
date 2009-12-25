Return-Path: <linux-kernel-owner+w=401wt.eu-S1756493AbZLYSjf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756493AbZLYSjf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Dec 2009 13:39:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756348AbZLYSje
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Dec 2009 13:39:34 -0500
Received: from xenotime.net ([72.52.64.118]:45101 "HELO xenotime.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1756282AbZLYSjd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Dec 2009 13:39:33 -0500
Date: Fri, 25 Dec 2009 10:39:32 -0800
From: Randy Dunlap <rdunlap@xenotime.net>
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Cc: Takashi Iwai <tiwai@suse.de>, Len Brown <len.brown@intel.com>,
       Amerigo Wang <amwang@redhat.com>,
       Corentin Chary <corentincj@iksaif.net>,
       Marcel Holtmann <marcel@holtmann.org>, linux-kernel@vger.kernel.org,
       ibm-acpi-devel@lists.sourceforge.net,
       Alan Jenkins <alan-jenkins@tuffmail.co.uk>, helight.xu@gmail.com,
       Xiaotian Feng <xtfeng@gmail.com>, akpm@linux-foundation.org
Subject: Re: [ibm-acpi-devel] [Patch] thinkpad_acpi: fix a build error
Message-Id: <20091225103932.6aed3875.rdunlap@xenotime.net>
In-Reply-To: <20091225134157.GC5891@khazad-dum.debian.net>
References: <20091218093132.4415.23424.sendpatchset@localhost.localdomain>
	<7b6bb4a50912180142u5e66fa88odb7cd3b6fa1a2ba2@mail.gmail.com>
	<s5hhbrowpty.wl%tiwai@suse.de>
	<20091218142815.GB15898@khazad-dum.debian.net>
	<1261435136.4041.152.camel@localhost.localdomain>
	<20091221144432.81702725.rdunlap@xenotime.net>
	<20091222193858.GB1796@khazad-dum.debian.net>
	<s5hhbrimbtw.wl%tiwai@suse.de>
	<20091224185912.GA25861@khazad-dum.debian.net>
	<s5h8wcrmhsn.wl%tiwai@suse.de>
	<20091225134157.GC5891@khazad-dum.debian.net>
Organization: YPO4
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.12.0; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 25 Dec 2009 11:41:57 -0200 Henrique de Moraes Holschuh wrote:

> On Fri, 25 Dec 2009, Takashi Iwai wrote:
> > > "depends on SND || SND = n" takes care of the technical restrictions.
> > 
> > Yep, that's what I mentioned as Kconfig dependency :)
> 
> I think I will do it a bit different, so that you can opt-out ALSA support
> and still have thinkpad-acpi built in, with modular ALSA in that case.
> 
> Which means that, due to the lack of "depends-but-not-hide", the
> "thinkpad-acpi alsa support" kconfig entry will still just disappear due to
> a "depends on SND && SND = THINKPAD_ACPI".
> 
> I really want a depends that leaves the entry still visible, but greyed out
> :-(

That makes sense.  And you can do that with xconfig, by setting
the Show All Options flag in the Option menu, but having that
feature for menuconfig and having those disabled options more
visible does sound good, I agree.


> > > The warning will be there.  Although I don't warn of missing rfkill
> > > functionality if the kernel is missing the rfkill subsystem...
> > 
> > The messages could be KERN_INFO instead of KERN_WARNING, I think.
> 
> It is at KERN_NOTICE right now.


---
~Randy
