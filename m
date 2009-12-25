Return-Path: <linux-kernel-owner+w=401wt.eu-S1755339AbZLYNmG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755339AbZLYNmG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Dec 2009 08:42:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753713AbZLYNmB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Dec 2009 08:42:01 -0500
Received: from out1.smtp.messagingengine.com ([66.111.4.25]:44367 "EHLO
	out1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753136AbZLYNmA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Dec 2009 08:42:00 -0500
X-Sasl-enc: YpU8hDGmuC1W3exrbCZ2yAZsQo0EQVkKfsuIoFfmn0dg 1261748519
Date: Fri, 25 Dec 2009 11:41:57 -0200
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Takashi Iwai <tiwai@suse.de>
Cc: Len Brown <len.brown@intel.com>, Amerigo Wang <amwang@redhat.com>,
       Corentin Chary <corentincj@iksaif.net>,
       Marcel Holtmann <marcel@holtmann.org>, linux-kernel@vger.kernel.org,
       ibm-acpi-devel@lists.sourceforge.net,
       Randy Dunlap <rdunlap@xenotime.net>,
       Alan Jenkins <alan-jenkins@tuffmail.co.uk>, helight.xu@gmail.com,
       Xiaotian Feng <xtfeng@gmail.com>, akpm@linux-foundation.org
Subject: Re: [ibm-acpi-devel] [Patch] thinkpad_acpi: fix a build error
Message-ID: <20091225134157.GC5891@khazad-dum.debian.net>
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
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <s5h8wcrmhsn.wl%tiwai@suse.de>
X-GPG-Fingerprint: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F
 1CDB 0FE3
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 25 Dec 2009, Takashi Iwai wrote:
> > "depends on SND || SND = n" takes care of the technical restrictions.
> 
> Yep, that's what I mentioned as Kconfig dependency :)

I think I will do it a bit different, so that you can opt-out ALSA support
and still have thinkpad-acpi built in, with modular ALSA in that case.

Which means that, due to the lack of "depends-but-not-hide", the
"thinkpad-acpi alsa support" kconfig entry will still just disappear due to
a "depends on SND && SND = THINKPAD_ACPI".

I really want a depends that leaves the entry still visible, but greyed out
:-(

> > The warning will be there.  Although I don't warn of missing rfkill
> > functionality if the kernel is missing the rfkill subsystem...
> 
> The messages could be KERN_INFO instead of KERN_WARNING, I think.

It is at KERN_NOTICE right now.

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
