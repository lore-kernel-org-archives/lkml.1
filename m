Return-Path: <linux-kernel-owner+w=401wt.eu-S1752923AbXHNHJq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752923AbXHNHJq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Aug 2007 03:09:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751082AbXHNHJb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Aug 2007 03:09:31 -0400
Received: from mx.logic.tuwien.ac.at ([128.130.175.19]:52760 "EHLO
	mx.logic.tuwien.ac.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751072AbXHNHJ3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Aug 2007 03:09:29 -0400
Date: Tue, 14 Aug 2007 09:09:17 +0200
To: Alexey Starikovskiy <astarikovskiy@suse.de>
Cc: Sergey Dolgov <solkaa@gmail.com>, Hugh Dickins <hugh@veritas.com>,
       Len Brown <len.brown@intel.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Henrique de Moraes Holshuh <hmh@hmh.eng.br>,
       Michal Piotrowski <michal.k.k.piotrowski@gmail.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [Fwd: Re: 2.6.23-rc3 regression and bisection query]
Message-ID: <20070814070917.GA21301@gamma.logic.tuwien.ac.at>
References: <Pine.LNX.4.64.0708131905280.13982@blonde.wat.veritas.com> <20070813212204.GA2645@slk.laptop> <46C0D6DB.7090703@suse.de> <46C0D35B.5030104@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46C0D6DB.7090703@suse.de> <46C0D35B.5030104@suse.de>
User-Agent: Mutt/1.3.28i
From: Norbert Preining <preining@logic.at>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Alexey,

On Die, 14 Aug 2007, Alexey Starikovskiy wrote:
> ACPI: EC: Fix regression
> Undelete call to register query methods. 

I am now using a kernel with only this patch (reapplied ec/battery which
you sent me).

On Die, 14 Aug 2007, Alexey Starikovskiy wrote:
>     cat /proc/acpi/battery/C1BE/state
> 
> does not change after this file has been read for the the first time;

This does not occur with this patch.

But there is still the strange thing that
	ACPI: Battery Slot [BAT1] (battery absent)
is present in the dmesg, while 
	$ acpi
	     Battery 1: charging, 46%, 00:00:49 until charged

But this seems to be a minor issue. Thanks a lot.

Best wishes

Norbert

-------------------------------------------------------------------------------
Dr. Norbert Preining <preining@logic.at>        Vienna University of Technology
Debian Developer <preining@debian.org>                         Debian TeX Group
gpg DSA: 0x09C5B094      fp: 14DF 2E6C 0307 BE6D AD76  A9C0 D2BF 4AA3 09C5 B094
-------------------------------------------------------------------------------
DUNBAR (n.)
A highly specialised fiscal term used solely by turnstile
operatives at Regnet's Part zoo. It refers to the variable amount of
increase in the variable gate takings on a Sunday afternoon, caused by
persons going to the zoo because they are in love and believe that the
feeling of romance will be somehow enhanced by the smell of panther
sweat and rank incontinence in the reptile house.
			--- Douglas Adams, The Meaning of Liff
