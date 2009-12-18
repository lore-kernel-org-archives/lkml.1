Return-Path: <linux-kernel-owner+w=401wt.eu-S1754439AbZLRPDd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754439AbZLRPDd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Dec 2009 10:03:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754422AbZLRPDa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Dec 2009 10:03:30 -0500
Received: from out1.smtp.messagingengine.com ([66.111.4.25]:36212 "EHLO
	out1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754419AbZLRPD2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Dec 2009 10:03:28 -0500
X-Sasl-enc: gmI+K0MlsIXwrvdhjOhG3BmMWzQsUzSPHEeAr9d9p0im 1261148607
Date: Fri, 18 Dec 2009 13:03:24 -0200
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Takashi Iwai <tiwai@suse.de>
Cc: Xiaotian Feng <xtfeng@gmail.com>, Amerigo Wang <amwang@redhat.com>,
       linux-kernel@vger.kernel.org, Corentin Chary <corentincj@iksaif.net>,
       ibm-acpi-devel@lists.sourceforge.net, Len Brown <len.brown@intel.com>,
       Alan Jenkins <alan-jenkins@tuffmail.co.uk>, akpm@linux-foundation.org,
       helight.xu@gmail.com
Subject: Re: [Patch] thinkpad_acpi: fix a build error
Message-ID: <20091218150324.GA5383@khazad-dum.debian.net>
References: <20091218093132.4415.23424.sendpatchset@localhost.localdomain>
 <7b6bb4a50912180142u5e66fa88odb7cd3b6fa1a2ba2@mail.gmail.com>
 <s5hhbrowpty.wl%tiwai@suse.de>
 <20091218142815.GB15898@khazad-dum.debian.net>
 <s5h4ono73qx.wl%tiwai@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <s5h4ono73qx.wl%tiwai@suse.de>
X-GPG-Fingerprint: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F
 1CDB 0FE3
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 18 Dec 2009, Takashi Iwai wrote:
> At Fri, 18 Dec 2009 12:28:15 -0200,
> Henrique de Moraes Holschuh wrote:
> > On Fri, 18 Dec 2009, Takashi Iwai wrote:
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
> 
> SND already depends on SOUND, so it's just superfluous.

No, it is not (test it).  Which is the main reason why select can be a pain.

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
