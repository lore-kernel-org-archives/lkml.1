Return-Path: <linux-kernel-owner+w=401wt.eu-S1753225AbZG1OuH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753225AbZG1OuH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jul 2009 10:50:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752885AbZG1OuF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Jul 2009 10:50:05 -0400
Received: from fias.uni-frankfurt.de ([141.2.248.1]:39977 "EHLO
	fias.uni-frankfurt.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751034AbZG1OuE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jul 2009 10:50:04 -0400
From: Jan Scholz <scholz@fias.uni-frankfurt.de>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Benjamin Herrenschmidt" <benh@kernel.crashing.org>,
       "Jan Scholz" <scholz@fias.uni-frankfurt.de>
Subject: Re: [Bug #13407] adb trackpad disappears after suspend to ram
References: <DizPU9GBfHF.A.kgF.iWObKB@chimera>
	<H5-1lZIIeYK.A.BsH.IYObKB@chimera>
Date: Tue, 28 Jul 2009 16:49:56 +0200
In-Reply-To: <H5-1lZIIeYK.A.BsH.IYObKB@chimera> (Rafael J. Wysocki's message
	of "Sun, 26 Jul 2009 22:45:28 +0200 (CEST)")
Message-ID: <87iqhcvp4b.fsf@scholz.fias.uni-frankfurt.de>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.96 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

The bug is still present in v2.6.31-rc4, it is fixed by commenting out
{suspend,resume}_device_irqs() in drivers/base/power/main.c as suggested
by Rafael. Any success in reproducing it?

Regards,
   Jan

"Rafael J. Wysocki" <rjw@sisk.pl> writes:

> This message has been generated automatically as a part of a report
> of regressions introduced between 2.6.29 and 2.6.30.
>
> The following bug entry is on the current list of known regressions
> introduced between 2.6.29 and 2.6.30.  Please verify if it still should
> be listed and let me know (either way).
>
>
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=13407
> Subject		: adb trackpad disappears after suspend to ram
> Submitter	: Jan Scholz <scholz@fias.uni-frankfurt.de>
> Date		: 2009-05-28 7:59 (60 days old)
> First-Bad-Commit: http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=2ed8d2b3a81bdbb0418301628ccdb008ac9f40b7
> References	: http://marc.info/?l=linux-kernel&m=124349762314976&w=4
> Handled-By	: Rafael J. Wysocki <rjw@sisk.pl>
>
>
>

-- 
 Jan Scholz                                ____  ____    __    ___ 
                                          ( ___)(_  _)  /__\  / __)
 Frankfurt Institute for Advanced Studies  )__)  _)(_  /(__)\ \__ \
                                          (__)  (____)(__)(__)(___/
 Goethe Universitaet Frankfurt
 Ruth-Moufang-Str. 1                             Tel. 069-798-47534
 60438 Frankfurt am Main
