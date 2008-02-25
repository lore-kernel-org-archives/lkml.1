Return-Path: <linux-kernel-owner+w=401wt.eu-S1754061AbYBYJXw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754061AbYBYJXw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Feb 2008 04:23:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751019AbYBYJXn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Feb 2008 04:23:43 -0500
Received: from cantor2.suse.de ([195.135.220.15]:49157 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751516AbYBYJXm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Feb 2008 04:23:42 -0500
From: Andreas Schwab <schwab@suse.de>
To: "Kiyoshi Ueda" <k-ueda@ct.jp.nec.com>
Cc: <petkovbb@gmail.com>, <bzolnier@gmail.com>, <linux-kernel@vger.kernel.org>,
       <jens.axboe@oracle.com>, <j-nomura@ce.jp.nec.com>
Subject: Re: 2.6.25-rc1/2 CD/DVD burning broken
References: <jelk5k62uy.fsf@sykes.suse.de>
	<58cb370e0802180759h4d44b9bci86f02919a48c7979@mail.gmail.com>
	<20080218.135827.74754725.k-ueda@ct.jp.nec.com>
	<jek5kvisih.fsf@sykes.suse.de> <20080224163244.GA11998@gollum.tnic>
	<jehcfyffyp.fsf@sykes.suse.de> <002101c87759$0fb4f010$58f80d0a@brian>
X-Yow: ..Wait 'til those  ITALIAN TEENAGERS get back to their HONDAS &
 discover them to be FILLED to the BRIM with MAZOLA!!
Date: Mon, 25 Feb 2008 10:23:37 +0100
In-Reply-To: <002101c87759$0fb4f010$58f80d0a@brian> (Kiyoshi Ueda's message of
	"Sun\, 24 Feb 2008 21\:49\:31 -0500")
Message-ID: <je4pbxie3q.fsf@sykes.suse.de>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/22.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"Kiyoshi Ueda" <k-ueda@ct.jp.nec.com> writes:

>  o Have you tried bisecting the kernel changes to find suspicious
>    commit?  If so, that information will be much appreciated.

That is close to impossible.  Intervening kernels either don't boot or
crash while burning.  Especially the one with the bad commit crashes in
cdrom_newpc_intr almost immediately when burning starts.

>  o Is this problem 100% reproducible on your Pioneer drive?

Yes.  See the comment in the growisofs sources, this sense code is
Pioneer specific.

>  o Do you get some messages from kernel like "DMA error" when
>    the problem happens?

Never.

Andreas.

-- 
Andreas Schwab, SuSE Labs, schwab@suse.de
SuSE Linux Products GmbH, Maxfeldstraße 5, 90409 Nürnberg, Germany
PGP key fingerprint = 58CA 54C7 6D53 942B 1756  01D3 44D5 214B 8276 4ED5
"And now for something completely different."
