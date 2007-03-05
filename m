Return-Path: <linux-kernel-owner+w=401wt.eu-S1751638AbXCEWxM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751638AbXCEWxM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2007 17:53:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751709AbXCEWxM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Mar 2007 17:53:12 -0500
Received: from ug-out-1314.google.com ([66.249.92.172]:23413 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751638AbXCEWxJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2007 17:53:09 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=SemW+uj5gDDAe+SzTLHU+ZituovsgQNN3eEYH61OQQK+QxH8BLD1NW+Z4ZYXMOdsPmvdPSB8TTtbStaZ1sl7RTfrDEyfNcO4Ts1DT/U+RFtn4is8WgBnznO8lV7v6MVnaaPsp/iw0WsvIw5cDYfXREP8thihqrwe2SNfPi8fNhk=
Message-ID: <68676e00703051453l1ccfb63dtf7e90d9ff3fd3155@mail.gmail.com>
Date: Mon, 5 Mar 2007 23:53:03 +0100
From: "Luca Tettamanti" <kronos.it@gmail.com>
To: "Kok, Auke" <auke-jan.h.kok@intel.com>
Subject: Re: [PATCH] pata_jmicron: remove spurious #endif
Cc: "Tejun Heo" <htejun@gmail.com>, linux-kernel@vger.kernel.org
In-Reply-To: <45EC94CB.6080903@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070303201541.GA22621@dreamland.darkstar.lan>
	 <45EC94CB.6080903@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 3/5/07, Kok, Auke <auke-jan.h.kok@intel.com> wrote:
> Luca Tettamanti wrote:
> > Hello,
> > commit 438ac6d5e3f8106a6bd1a5682c508d660294a85d causes a build failure:
> >
> >   CC      drivers/ata/pata_jmicron.o
> >   /home/kronos/src/linux-2.6.git/drivers/ata/pata_jmicron.c:247:2: error: #endif without #if
> >   make[3]: *** [drivers/ata/pata_jmicron.o] Error 1
> >
> > Remove a spurious #endif in pata_jmicron driver.
>
> I think the problem is that Tejun forgot to *add* a #ifdef CONFIG_PM instead.

Nope, that #endif was after the jmicron_exit() function which is
unrelated with CONFIG_PM. I see that Jeff has already commited a
similar patch, mine is no longer needed.

Luca
