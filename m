Return-Path: <linux-kernel-owner+w=401wt.eu-S1756615AbYICR7t@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756615AbYICR7t (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2008 13:59:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752795AbYICR7j
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Sep 2008 13:59:39 -0400
Received: from mk-outboundfilter-4.mail.uk.tiscali.com ([212.74.114.32]:20609
	"EHLO mk-outboundfilter-4.mail.uk.tiscali.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752517AbYICR7i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2008 13:59:38 -0400
X-Trace: 131656168/mk-outboundfilter-2.mail.uk.tiscali.com/F2S/$F2S-NILDRAM-ACCEPTED/f2s-nildram-customers/195.149.44.6
X-SBRS: None
X-RemoteIP: 195.149.44.6
X-IP-MAIL-FROM: alistair@devzero.co.uk
X-IP-BHB: Once
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AtoEALxtvkjDlSwG/2dsb2JhbACBZbVfgWc
X-IronPort-AV: E=Sophos;i="4.32,320,1217804400"; 
   d="scan'208";a="131656168"
X-IP-Direction: IN
From: Alistair John Strachan <alistair@devzero.co.uk>
To: Lennart Sorensen <lsorense@csclub.uwaterloo.ca>
Subject: Re: How to add the Asus R1F to asus-laptop.c?
Date: Wed, 3 Sep 2008 18:59:28 +0100
User-Agent: KMail/1.10.0 (Linux/2.6.27-rc5-damocles; KDE/4.1.0; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, Corentin CHARY <corentincj@iksaif.net>
References: <20080903170649.GF12476@csclub.uwaterloo.ca>
In-Reply-To: <20080903170649.GF12476@csclub.uwaterloo.ca>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200809031859.28203.alistair@devzero.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Unless I'm mistaken, the current asus-laptop maintainer is Corentin Chary, who 
I've added to CC on your behalf.

On Wednesday 03 September 2008 18:06:49 Lennart Sorensen wrote:
> My wife has an Asu R1F and I have been trying to help her get wireless
> networking to work on it.
>
> The chipset is an intel 3945abg, so that part should be simple, and the
> driver does in fact load and see things.  unfortunately the radio is
> killed and there is no hardware switch to toggling it.  Instead you have
> to use fn-F2 as on many other Asus laptops.
>
> I have managed to manually toggle it and see the Ap by poking at values
> exported by asus-acpi in /proc and /sys, but that isn't very convinient.
>
> It would appear that the asus-laptop driver is supposed to manage
> hotkeys on many asus laptops, but unfortunately the R1F isn't recognized
> by the driver, which refuses to load.
>
> Looking at the sourceforge.net page mentioned in asus-laptop.c as the
> development site, I see that there is in fact a patch submitted for the
> R1F (which is almost the same as the M2E) to that site in may 2007, but
> apparently no one monitors that site anymore, and it never got submitted
> to the kernel.
>
> Who needs to be poked to have anything like that happen?  Why is that
> site listed in the driver anymore, if it isn't being used now?
>
> If I test out the patch and it works, should I submit it here to have it
> included so that this can be solved once and for all?

-- 
Cheers,
Alistair.
