Return-Path: <linux-kernel-owner+w=401wt.eu-S1755734AbZLUWoh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755734AbZLUWoh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Dec 2009 17:44:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754907AbZLUWog
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Dec 2009 17:44:36 -0500
Received: from xenotime.net ([72.52.64.118]:56576 "HELO xenotime.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1750848AbZLUWog (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Dec 2009 17:44:36 -0500
Date: Mon, 21 Dec 2009 14:44:32 -0800
From: Randy Dunlap <rdunlap@xenotime.net>
To: Marcel Holtmann <marcel@holtmann.org>
Cc: Henrique de Moraes Holschuh <hmh@hmh.eng.br>, Takashi Iwai <tiwai@suse.de>,
       Xiaotian Feng <xtfeng@gmail.com>, Amerigo Wang <amwang@redhat.com>,
       linux-kernel@vger.kernel.org, Corentin Chary <corentincj@iksaif.net>,
       ibm-acpi-devel@lists.sourceforge.net, Len Brown <len.brown@intel.com>,
       Alan Jenkins <alan-jenkins@tuffmail.co.uk>, akpm@linux-foundation.org,
       helight.xu@gmail.com
Subject: Re: [Patch] thinkpad_acpi: fix a build error
Message-Id: <20091221144432.81702725.rdunlap@xenotime.net>
In-Reply-To: <1261435136.4041.152.camel@localhost.localdomain>
References: <20091218093132.4415.23424.sendpatchset@localhost.localdomain>
	<7b6bb4a50912180142u5e66fa88odb7cd3b6fa1a2ba2@mail.gmail.com>
	<s5hhbrowpty.wl%tiwai@suse.de>
	<20091218142815.GB15898@khazad-dum.debian.net>
	<1261435136.4041.152.camel@localhost.localdomain>
Organization: YPO4
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.12.0; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 21 Dec 2009 14:38:56 -0800 Marcel Holtmann wrote:

> Hi Henrique,
> 
> > > The patch isn't correct (I guess the upstream fix is same?).
> > > 
> > > CONFIG_SOUND is a global config for sound subsystem.  The relevant
> > > functions are ALSA core part, which is CONFIG_SND.
> > > So, the fix should be:
> > > 
> > > 	depends on SND
> > > 
> > > instead.
> > 
> > Indeed.  Ingo already fixed that too.
> > 
> > Although I personally would prefer:
> > select SOUND
> > select SND
> > 
> > But anything that stops the build errors will do for now.
> 
> I still haven't seen this patch in Linus' tree. And you do need select
> SOUND and SND. Otherwise you still get build errors. I have tested this
> on my machine. So can someone please submit a proper patch to get this
> fixed.

Ugh.  Please don't 'select' to build an entire subsystem.

---
~Randy
