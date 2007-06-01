Return-Path: <linux-kernel-owner+w=401wt.eu-S1761385AbXFAMWl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761385AbXFAMWl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jun 2007 08:22:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761249AbXFAMWa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Jun 2007 08:22:30 -0400
Received: from nz-out-0506.google.com ([64.233.162.230]:15018 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761176AbXFAMW1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jun 2007 08:22:27 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding:from;
        b=bijw+Re56pdaGXom3ZCUBPeEHADWd8HiigPIqQYzHs46RG+ddvW5Rmz+fPQ+inO0SnniHSiaQmDohMTPJVM1J998cDSvQ+CGFDBAO/sC1SCSL0CewbTSt4UIGB5rXrHe23smD2UBhOfJx3s3gwXyO5RUDffEMPpu4w+qiaBOlcc=
Message-ID: <46600F62.5070005@googlemail.com>
Date: Fri, 01 Jun 2007 14:21:54 +0200
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Christoph Lameter <clameter@sgi.com>,
       Andrea Righi <righiandr@users.sourceforge.net>,
       linux-pci@atrey.karlin.mff.cuni.cz, Greg KH <greg@kroah.com>,
       "Mike Miller (OS Dev)" <mikem@beardog.cca.cpqcorp.net>,
       Tom Long Nguyen <tom.l.nguyen@intel.com>, linux-ide@vger.kernel.org,
       Paul Mundt <lethal@linux-sh.org>, Tejun Heo <htejun@gmail.com>,
       Jeff Garzik <jeff@garzik.org>, Alan Cox <alan@redhat.com>,
       Thomas Gleixner <tglx@linutronix.de>, Ian Kumlien <iank@bredband.net>,
       =?ISO-8859-2?Q?Bj=F6rn_Steinbrink?= <B.Steinbrink@gmx.de>
Subject: Re: [2/3] 2.6.22-rc3: known regressions with patches v2
References: <46600D36.7060405@googlemail.com>
In-Reply-To: <46600D36.7060405@googlemail.com>
X-Enigmail-Version: 0.94.1.1
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 8bit
From: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

Here is a list of some known regressions in 2.6.22-rc3
with patches available.

Feel free to add new regressions/remove fixed etc.
http://kernelnewbies.org/known_regressions



Memory management

Subject    : bug in i386 MTRR initialization
References : http://lkml.org/lkml/2007/5/19/93
Submitter  : Andrea Righi <righiandr@users.sourceforge.net>
Status     : patch available



PCI

Subject    : Oops on 2.6.22-rc2 when unloading the cciss driver
References : http://lkml.org/lkml/2007/5/24/172
Submitter  : Mike Miller (OS Dev) <mikem@beardog.cca.cpqcorp.net>
Patch      : http://lkml.org/lkml/2007/5/31/387
Status     : patch available



SATA/PATA

Subject    : libata reset-seq merge broke sata_sil on sh
References : http://lkml.org/lkml/2007/5/10/63
Submitter  : Paul Mundt <lethal@linux-sh.org>
Handled-By : Tejun Heo <htejun@gmail.com>
Caused-By  : commit 4750def52cb2c21732dda9aa1d43a07db37b0186
Patch      : http://lkml.org/lkml/2007/5/19/161
Status     : patch available



Timers

Subject    : timer statistics oops
References : http://lkml.org/lkml/2007/5/29/399
Submitter  : Ian Kumlien <iank@bredband.net>
Handled-By : Thomas Gleixner <tglx@linutronix.de>
             Björn Steinbrink <B.Steinbrink@gmx.de>
Patch      : http://lkml.org/lkml/2007/5/31/394
Status     : patch was suggested



Regards,
Michal

--
"Najbardziej brakowa³o mi twojego milczenia."
-- Andrzej Sapkowski "Co¶ wiêcej"

