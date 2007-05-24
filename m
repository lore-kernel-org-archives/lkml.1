Return-Path: <linux-kernel-owner+w=401wt.eu-S1751261AbXEXOEj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751261AbXEXOEj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2007 10:04:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750797AbXEXOEP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 May 2007 10:04:15 -0400
Received: from ug-out-1314.google.com ([66.249.92.174]:34799 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750765AbXEXOEM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2007 10:04:12 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding:from;
        b=jhs4qSFN31dX9IH1dXwJOgEja4EtDL13itnVtYija4vk9qd7l2ZfFYM8pGmyD1XHh9Gb5IJuPSHIG7O+dzbejd7yc/Z9wbgzvmWaY90mUmGS9BwpNifU1hUXNLGgN5D0V2DYSmB65wfPgKqZIKORlL2Okjo210KeNcr85DPSk3c=
Message-ID: <46559B54.80106@googlemail.com>
Date: Thu, 24 May 2007 16:04:04 +0200
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       "Cherwin R. Nooitmeer" <cherwin@gmail.com>,
       Christoph Lameter <clameter@sgi.com>, linux-pcmcia@lists.infradead.org,
       Robert de Rooy <robert.de.rooy@gmail.com>, Alan Cox <alan@redhat.com>,
       Tejun Heo <htejun@gmail.com>, sparclinux@vger.kernel.org,
       David Miller <davem@davemloft.net>, Mikael Pettersson <mikpe@it.uu.se>,
       linux1394-devel@lists.sourceforge.net,
       Stefan Richter <stefanr@s5r6.in-berlin.de>,
       =?UTF-8?B?S3Jpc3RpYW4gSMO4Z3NiZXJn?= <krh@bitplanet.net>,
       linux-pm@lists.linux-foundation.org, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Pavel Machek <pavel@ucw.cz>, Marcus Better <marcus@better.se>,
       Andrey Borzenkov <arvidjaar@mail.ru>,
       linux-usb-devel@lists.sourceforge.net,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: Re: [2/3] 2.6.22-rc2: known regressions v2
References: <46558708.2040803@googlemail.com>
In-Reply-To: <46558708.2040803@googlemail.com>
X-Enigmail-Version: 0.94.1.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
From: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

Here is a list of some known regressions in 2.6.22-rc2.

Feel free to add new regressions/remove fixed etc.
http://kernelnewbies.org/known_regressions



Memory management

Subject    : kernel BUG at include/linux/slub_def.h:88 kmalloc_index()
References : http://bugzilla.kernel.org/show_bug.cgi?id=8476
Submitter  : Cherwin R. Nooitmeer <cherwin@gmail.com>
Status     : Unknown



PCMCIA

Subject    : libata and legacy ide pcmcia failure
References : http://lkml.org/lkml/2007/5/17/305
Submitter  : Robert de Rooy <robert.de.rooy@gmail.com>
Status     : Unknown



Sparc64

Subject    : 2.6.22-rc broke X on Ultra5
References : http://lkml.org/lkml/2007/5/22/78
Submitter  : Mikael Pettersson <mikpe@it.uu.se>
Status     : Unknown



Suspend

Subject    : STD fails with pci_device_suspend(): usb_hcd_pci_suspend+0x0/0x160 [usbcore]() returns -16
References : http://lkml.org/lkml/2007/5/19/66
Submitter  : Andrey Borzenkov <arvidjaar@mail.ru>
Status     : Unknown

Subject    : 2.6.22-rc1 suspend to RAM problem
References : http://permalink.gmane.org/gmane.linux.power-management.general/5819
Submitter  : Marcus Better <marcus@better.se>
Handled-By : Stefan Richter <stefanr@s5r6.in-berlin.de>
             Kristian Høgsberg <krh@bitplanet.net>
Status     : caused by fw-ohci module



Regards,
Michal

-- 
"Najbardziej brakowało mi twojego milczenia."
-- Andrzej Sapkowski "Coś więcej"


