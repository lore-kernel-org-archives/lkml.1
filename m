Return-Path: <linux-kernel-owner+w=401wt.eu-S1757745AbZJBMwd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757745AbZJBMwd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Oct 2009 08:52:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757088AbZJBMwd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Oct 2009 08:52:33 -0400
Received: from fias.uni-frankfurt.de ([141.2.248.1]:35146 "EHLO
	fias.uni-frankfurt.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756979AbZJBMwc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Oct 2009 08:52:32 -0400
From: Jan Scholz <scholz@fias.uni-frankfurt.de>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Adrian Ulrich" <kernel@blinkenlights.ch>,
       "Jan Scholz" <Scholz@fias.uni-frankfurt.de>,
       "Jiri Kosina" <jkosina@suse.cz>
Subject: Re: [Bug #13935] 2.6.31-rcX breaks Apple MightyMouse (Bluetooth version)
References: <3onW63eFtRF.A.xXH.oMTxKB@chimera>
	<COE24pZSBH.A.DPD.fOTxKB@chimera>
Date: Fri, 02 Oct 2009 14:51:21 +0200
In-Reply-To: <COE24pZSBH.A.DPD.fOTxKB@chimera> (Rafael J. Wysocki's message of
	"Thu, 1 Oct 2009 21:55:53 +0200 (CEST)")
Message-ID: <871vlm3qnq.fsf@scholz.fias.uni-frankfurt.de>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

for me this bug is fixed by:

commit 42960a13001aa6df52ca9952ce996f94a744ea65
HID: completely remove apple mightymouse from blacklist

Cheers,
   Jan

"Rafael J. Wysocki" <rjw@sisk.pl> writes:

> This message has been generated automatically as a part of a report
> of regressions introduced between 2.6.30 and 2.6.31.
>
> The following bug entry is on the current list of known regressions
> introduced between 2.6.30 and 2.6.31.  Please verify if it still should
> be listed and let me know (either way).
>
>
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=13935
> Subject		: 2.6.31-rcX breaks Apple MightyMouse (Bluetooth version)
> Submitter	: Adrian Ulrich <kernel@blinkenlights.ch>
> Date		: 2009-08-08 22:08 (55 days old)
> First-Bad-Commit: http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=fa047e4f6fa63a6e9d0ae4d7749538830d14a343
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
