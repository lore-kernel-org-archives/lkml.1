Return-Path: <linux-kernel-owner+w=401wt.eu-S1760118AbXFQOYB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760118AbXFQOYB (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Jun 2007 10:24:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757785AbXFQOXw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Jun 2007 10:23:52 -0400
Received: from ug-out-1314.google.com ([66.249.92.173]:34180 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755532AbXFQOXv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Jun 2007 10:23:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:user-agent:mime-version:to:subject:content-type:content-transfer-encoding:from;
        b=IkN4aLkZFFgQbmlxXYDprhyLev0MSN6em7oePH+TyV1l1M3Jl9kMHZL3jxRt7M4UuJX4nioBwW1YZbiyDv4/URnBm36JBsaIsdeSay4zjXnT0F+bdRtTqXehIV4K9nXhuSBrkmzK8TLrRcbD6GCgdqai2rjkWwNh2SXQid68Sew=
Message-ID: <467543E1.1060001@googlemail.com>
Date: Sun, 17 Jun 2007 16:23:29 +0200
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Rodrigo Luiz <troops.of.doom@gmail.com>,
       "Darrick J. Wong" <djwong@us.ibm.com>,
       "Siddha, Suresh B" <suresh.b.siddha@intel.com>,
       alsa-devel@alsa-project.org, Takashi Iwai <tiwai@suse.de>,
       Jaroslav Kysela <perex@suse.cz>, Ben Collins <bcollins@ubuntu.com>,
       reiserfs-devel@vger.kernel.org, "Vladimir V. Saveliev" <vs@namesys.com>,
       Randy Dunlap <randy.dunlap@oracle.com>,
       linux-pci@atrey.karlin.mff.cuni.cz, Greg Kroah-Hartman <gregkh@suse.de>,
       Malte Cornils <malte@cornils.net>
Subject: [1/2] 2.6.22-rc5: known regressions
Content-Type: text/plain; charset=ISO-8859-2; format=flowed
Content-Transfer-Encoding: 7bit
From: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

Here is a list of some known regressions in 2.6.22-rc5.

Feel free to add new regressions/remove fixed etc.
http://kernelnewbies.org/known_regressions



Unclassified

Subject    : Kernel hang on CMOS_READ
References : http://lkml.org/lkml/2007/6/3/138
Submitter  : Rodrigo Luiz <troops.of.doom@gmail.com>
Status     : Unknown

Subject    : Device hang when offlining a CPU due to IRQ misrouting
References : http://lkml.org/lkml/2007/5/31/419
Submitter  : Darrick J. Wong <djwong@us.ibm.com>
Handled-By : Siddha, Suresh B <suresh.b.siddha@intel.com>
Status     : problem is being debugged



ALSA

Subject    : snd-aoa causes badness in lib/kref.c:33
References : http://bugzilla.kernel.org/show_bug.cgi?id=8513
Submitter  : Ben Collins <bcollins@ubuntu.com>
Handled-By : Takashi Iwai <tiwai@suse.de>
Status     : Unknown



FS

Subject    : 2.6.22-rc4-git5 reiserfs: null ptr deref.
References : http://lkml.org/lkml/2007/6/13/322
Submitter  : Randy Dunlap <randy.dunlap@oracle.com>
Handled-By : Vladimir V. Saveliev <vs@namesys.com>
Status     : problem is being debugged



PCI

Subject    : PCI setup hangs on Asus Notebook (nolapic helps)
References : http://lkml.org/lkml/2007/6/14/161
Submitter  : Malte Cornils <malte@cornils.net>
Status     : unknown



Regards,
Michal

--
LOG
http://www.stardust.webpages.pl/log/
