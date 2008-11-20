Return-Path: <linux-kernel-owner+w=401wt.eu-S1756674AbYKTP6M@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756674AbYKTP6M (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2008 10:58:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755026AbYKTP56
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Nov 2008 10:57:58 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:51297 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754915AbYKTP55 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2008 10:57:57 -0500
Date: Thu, 20 Nov 2008 15:58:08 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Takashi Iwai <tiwai@suse.de>
Cc: linux-kernel@vger.kernel.org
Subject: Re: vm86 segfaults with NX bit
Message-ID: <20081120155808.19439807@lxorguk.ukuu.org.uk>
In-Reply-To: <s5hmyfu9zl1.wl%tiwai@suse.de>
References: <s5hmyfu9zl1.wl%tiwai@suse.de>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.12; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Also, when NX bit is reset for the first 1MB (or smaller) in
> do_sys_vm86(), it also works as expected.  But I have little clue
> where to restore the bit again.
> 
> Any good suggestions / solutions?

Does it behave if you clear NX just for  640K-1MB, and page 0 ?

Alan
