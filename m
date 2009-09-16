Return-Path: <linux-kernel-owner+w=401wt.eu-S1760325AbZIPXP1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760325AbZIPXP1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Sep 2009 19:15:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756990AbZIPXP0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Sep 2009 19:15:26 -0400
Received: from g4t0014.houston.hp.com ([15.201.24.17]:18931 "EHLO
	g4t0014.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760253AbZIPXPX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Sep 2009 19:15:23 -0400
From: Bjorn Helgaas <bjorn.helgaas@hp.com>
To: Larry Finger <Larry.Finger@lwfinger.net>
Subject: fixing "pci=use_crs"
Date: Wed, 16 Sep 2009 17:15:23 -0600
User-Agent: KMail/1.9.10
Cc: Gary Hade <garyhade@us.ibm.com>, Jesse Barnes <jbarnes@virtuousgeek.org>,
       Jaswinder Singh Rajput <jaswinder@kernel.org>,
       Yinghai Lu <yhlu.kernel@gmail.com>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
       Len Brown <lenb@kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>, x86@kernel.org,
       linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200909161715.24376.bjorn.helgaas@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The user currently has to boot with "pci=use_crs" to make
hot-add work on some machines.  I think this is a poor
user experience, and I'd like to figure out a better solution.

We tried making "pci=use_crs" the default, which didn't work
because it broke machines like Larry's.  I'd like to look
at that machine in more detail and figure out what it's doing.

Larry, would you mind collecting the output of:

  # dmesg
  # cat /proc/iomem
  # lspci -vv
  # cd /sys/devices/; grep . pnp*/*/{id,resources}

and attaching them here:

    http://bugzilla.kernel.org/show_bug.cgi?id=14183

Thanks,
  Bjorn
