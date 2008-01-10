Return-Path: <linux-kernel-owner+w=401wt.eu-S1755157AbYAJL6Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755157AbYAJL6Y (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jan 2008 06:58:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753050AbYAJL6L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jan 2008 06:58:11 -0500
Received: from gateway.drzeus.cx ([85.8.24.16]:49449 "EHLO smtp.drzeus.cx"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752810AbYAJL6K (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jan 2008 06:58:10 -0500
Date: Thu, 10 Jan 2008 12:57:48 +0100
From: Pierre Ossman <drzeus-mmc@drzeus.cx>
To: "Bryan Wu" <cooloney.lkml@gmail.com>
Cc: "Cai, Cliff" <Cliff.Cai@analog.com>,
       "Mike Frysinger" <vapier.adi@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: [patch] split MMC_CAP_4_BIT_DATA
Message-ID: <20080110125748.416ad0c5@poseidon.drzeus.cx>
In-Reply-To: <386072610801100122n52339488ke2b8724c390be765@mail.gmail.com>
References: <386072610801081832w2befcbafwe9215067f022ed5d@mail.gmail.com>
	<0F1B54C89D5F954D8535DB252AF412FA014FAD4A@chinexm1.ad.analog.com>
	<20080109082325.212ec90d@poseidon.drzeus.cx>
	<386072610801090845r14510fb8tbcca76d605458a96@mail.gmail.com>
	<20080110095428.3b93fd18@poseidon.drzeus.cx>
	<386072610801100122n52339488ke2b8724c390be765@mail.gmail.com>
X-Mailer: Claws Mail 3.2.0 (GTK+ 2.12.3; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 10 Jan 2008 17:22:55 +0800
"Bryan Wu" <cooloney.lkml@gmail.com> wrote:

> 
> At page 4-3 of  ADSP-BF54x Blackfin(R) Processor Peripheral Hardware
> Reference, there is a table which guide us the SDH controller does not
> support 4-bit mode MMC card. Please found the table picture in the
> attachment or get the document at:
> http://www.analog.com/UploadedFiles/Associated_Docs/61460151169789ADSP_BF54x_Blackfin_Processor_Peripheral_Hardware_Reference.pdf
> 

Ok, but this just means the controller wasn't designed with 4-bit MMC in mind. As several other "SD-only" controller have been tested with modern MMC cards without a problem, this is not sufficient to explain any problem.

> 
> Thanks, actually we are not yet convinced  by our hardware designer
> why BF54x SDH does not support 4-bit MMC.
> 

Please keep me informed on how it progresses. I'd like an at least plausible explanation, preferably also some empirical data, before I'm ready to accept Mike's patch.

Rgds
-- 
     -- Pierre Ossman

  Linux kernel, MMC maintainer        http://www.kernel.org
  PulseAudio, core developer          http://pulseaudio.org
  rdesktop, core developer          http://www.rdesktop.org
