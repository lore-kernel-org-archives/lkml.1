Return-Path: <linux-kernel-owner+w=401wt.eu-S1755939AbXHBK4Q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755939AbXHBK4Q (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Aug 2007 06:56:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753432AbXHBK4E
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Aug 2007 06:56:04 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:44761 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753373AbXHBK4C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Aug 2007 06:56:02 -0400
Date: Thu, 2 Aug 2007 12:02:21 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: trenn@suse.de
Cc: Adrian =?UTF-8?B?U2NocsO2dGVy?= <adrian@suse.de>,
       Knut Petersen <Knut_Petersen@t-online.de>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@osdl.org>, pavel@ucw.cz, mjg59@srcf.ucam.org,
       lenb@kernel.org, "Zhang, Rui" <rui.zhang@intel.com>,
       Jean Delvare <khali@linux-fr.org>,
       Alexey Starikovskiy <aystarik@gmail.com>
Subject: Re: 2.6.22 regression: thermal trip points
Message-ID: <20070802120221.5474e732@the-village.bc.nu>
In-Reply-To: <1186048701.18821.459.camel@queen.suse.de>
References: <46B1988C.3090302@t-online.de>
	<1186047747.18821.450.camel@queen.suse.de>
	<200708021145.09377.adrian@suse.de>
	<1186048701.18821.459.camel@queen.suse.de>
X-Mailer: Claws Mail 2.9.1 (GTK+ 2.10.13; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> Anyway, only solution/workaround to use these machines with current
> kernels is to override trip points, maybe the patch should really just
> be reverted...

The question really is whether the vendors will all revert it and carry
it as a patch or whether the main tree will accept reality on this one.

Reverting it and adding a taint marker if you do it is much preferable I
suspect to having every vendor revert this bogus if well meaning
changeset.

