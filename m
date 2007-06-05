Return-Path: <linux-kernel-owner+w=401wt.eu-S932801AbXFEOzc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932801AbXFEOzc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jun 2007 10:55:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932732AbXFEOyx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Jun 2007 10:54:53 -0400
Received: from ug-out-1314.google.com ([66.249.92.175]:49466 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932646AbXFEOyw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jun 2007 10:54:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:user-agent:mime-version:to:cc:subject:references:in-reply-to:content-type:content-transfer-encoding:from;
        b=K+jjXcaPFhHSRSnCwrxUfAzqvojIdtrhQhveHff0vEcQqlfDOUQATB+rx/3UjzSvFyYI/Z4260jjfbDpVZbDLF7kxkLTVdURhuc6TeemkhNU2dnp5lTjPMBMScBO6u6nT/GnyOX0I4JSrOnF9xwDwLK0aeDPTCByAqqI/bD2ZKc=
Message-ID: <4665792B.8030005@googlemail.com>
Date: Tue, 05 Jun 2007 16:54:35 +0200
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, linux-pci@atrey.karlin.mff.cuni.cz,
       Greg KH <greg@kroah.com>,
       "Mike Miller (OS Dev)" <mikem@beardog.cca.cpqcorp.net>,
       Tom Long Nguyen <tom.l.nguyen@intel.com>, linux-ide@vger.kernel.org,
       Paul Mundt <lethal@linux-sh.org>, Tejun Heo <htejun@gmail.com>,
       Jeff Garzik <jeff@garzik.org>, Alan Cox <alan@redhat.com>,
       sparclinux@vger.kernel.org, David Miller <davem@davemloft.net>,
       "Horst H. von Brand" <vonbrand@inf.utfsm.cl>
Subject: Re: [2/2] 2.6.22-rc4: known regressions with patches
References: <46657866.7000108@googlemail.com>
In-Reply-To: <46657866.7000108@googlemail.com>
Content-Type: text/plain; charset=ISO-8859-2; format=flowed
Content-Transfer-Encoding: 8bit
From: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

Here is a list of some known regressions in 2.6.22-rc4
with patches available.

Feel free to add new regressions/remove fixed etc.
http://kernelnewbies.org/known_regressions



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



Sparc64

Subject    : arch/sparc64/time.c doesn't compile on Ultra 1 (no PCI)
References : http://bugzilla.kernel.org/show_bug.cgi?id=8540
Submitter  : Horst H. von Brand <vonbrand@inf.utfsm.cl>
Status     : patch available



Regards,
Michal

--
"Najbardziej brakowa³o mi twojego milczenia."
-- Andrzej Sapkowski "Co¶ wiêcej"
