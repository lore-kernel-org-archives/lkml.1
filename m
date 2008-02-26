Return-Path: <linux-kernel-owner+w=401wt.eu-S1761123AbYBZOw2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761123AbYBZOw2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2008 09:52:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751522AbYBZOwS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Feb 2008 09:52:18 -0500
Received: from cantor2.suse.de ([195.135.220.15]:50187 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751344AbYBZOwR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2008 09:52:17 -0500
From: Andreas Schwab <schwab@suse.de>
To: petkovbb@gmail.com
Cc: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>, bzolnier@gmail.com,
       linux-kernel@vger.kernel.org, jens.axboe@oracle.com,
       j-nomura@ce.jp.nec.com
Subject: Re: 2.6.25-rc1/2 CD/DVD burning broken
References: <jelk5k62uy.fsf@sykes.suse.de>
	<58cb370e0802180759h4d44b9bci86f02919a48c7979@mail.gmail.com>
	<20080218.135827.74754725.k-ueda@ct.jp.nec.com>
	<jek5kvisih.fsf@sykes.suse.de> <20080224163244.GA11998@gollum.tnic>
	<jehcfyffyp.fsf@sykes.suse.de> <002101c87759$0fb4f010$58f80d0a@brian>
	<jeejb0968h.fsf@sykes.suse.de> <20080225204543.GA26788@gollum.tnic>
	<jeir0c7kp4.fsf@sykes.suse.de> <20080226042414.GB26788@gollum.tnic>
X-Yow: .. If I cover this entire WALL with MAZOLA, who I have to give my
 AGENT ten per cent??
Date: Tue, 26 Feb 2008 15:52:13 +0100
In-Reply-To: <20080226042414.GB26788@gollum.tnic> (Borislav Petkov's message
	of "Tue\, 26 Feb 2008 05\:24\:14 +0100")
Message-ID: <jebq63epnm.fsf@sykes.suse.de>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/22.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Borislav Petkov <petkovbb@googlemail.com> writes:

> On Mon, Feb 25, 2008 at 11:08:55PM +0100, Andreas Schwab wrote:
>> Borislav Petkov <petkovbb@googlemail.com> writes:
>> 
>> > On Mon, Feb 25, 2008 at 08:38:22PM +0100, Andreas Schwab wrote:
>> >> "Kiyoshi Ueda" <k-ueda@ct.jp.nec.com> writes:
>> >> 
>> >> > I'm looking at this problem, but currently no idea why the conversion
>> >> > to blk_end_request causes it.
>> >> 
>> >> cdrom_newpc_intr apparently never sets rq->sense_len.
>> >> 
>> >
>> > actually it does, see the code chunk around line 1188 in 2.6.25-rc2, for
>> > example.
>> 
>> Yes, it does, but it always adds zero.
>
> yep, true. Does that fix your dvd burning problem?

Yes, sure.

Andreas.

-- 
Andreas Schwab, SuSE Labs, schwab@suse.de
SuSE Linux Products GmbH, Maxfeldstraße 5, 90409 Nürnberg, Germany
PGP key fingerprint = 58CA 54C7 6D53 942B 1756  01D3 44D5 214B 8276 4ED5
"And now for something completely different."
