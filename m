Return-Path: <linux-kernel-owner+w=401wt.eu-S1758626AbZDNS2h@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758626AbZDNS2h (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Apr 2009 14:28:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758100AbZDNS1o
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Apr 2009 14:27:44 -0400
Received: from e8.ny.us.ibm.com ([32.97.182.138]:36818 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758542AbZDNS1m (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Apr 2009 14:27:42 -0400
Subject: [BUILD FAILURE 03/04] Next April 14 : x86 randconfig
	[sound/oss/sequencer.c]
From: Subrata Modak <subrata@linux.vnet.ibm.com>
Reply-To: subrata@linux.vnet.ibm.com
To: Ingo Molnar <mingo@elte.hu>, Hannu Savolainen <hannu@voxware.pp.fi>,
       Takashi Iwai <tiwai@suse.de>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>,
       linux-next <linux-next@vger.kernel.org>,
       sachinp <sachinp@linux.vnet.ibm.com>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Alexander Beregalov <a.beregalov@gmail.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>
Content-Type: text/plain; charset=utf-8
Organization: IBM
Date: Tue, 14 Apr 2009 23:57:33 +0530
Message-Id: <1239733654.5344.71.camel@subratamodak.linux.ibm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-8.el5_2.2) 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Observed the following build error:
---
CC [M]  sound/oss/sequencer.o
sound/oss/sequencer.c: In function ‘sequencer_ioctl’:
sound/oss/sequencer.c:1325: warning: ‘err’ may be used uninitialized in
this function
  CC [M]  sound/oss/sound_timer.o
  CC [M]  sound/oss/sys_timer.o
  LD [M]  sound/oss/sound.o
  CC [M]  sound/oss/aedsp16.o
make[2]: *** No rule to make target `/etc/sound/dsp001.ld', needed by
`sound/oss/pss_boot.h'.  Stop.
make[1]: *** [sound/oss] Error 2
make: *** [sound] Error 2
---

Regards--
Subrata


