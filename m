Return-Path: <linux-kernel-owner+w=401wt.eu-S1756592AbYBKWOx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756592AbYBKWOx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2008 17:14:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751883AbYBKWOp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Feb 2008 17:14:45 -0500
Received: from ns2.suse.de ([195.135.220.15]:59897 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751405AbYBKWOo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2008 17:14:44 -0500
From: Andreas Schwab <schwab@suse.de>
To: Jiri Kosina <jkosina@suse.cz>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Abel Bernabeu <abelbg@m2grp.com>,
       Sam Ravnborg <sam@ravnborg.org>, linux-kernel@vger.kernel.org
Subject: Re: [Patch] Elf loader crash while zero-filling .bss
References: <15577be70802111027s59bc16f7q7c0be42cc44f9ad7@mail.gmail.com>
	<15577be70802111032l6ea6d2fagba2da4462c739d66@mail.gmail.com>
	<Pine.LNX.4.64.0802111944220.7699@twin.jikos.cz>
	<15577be70802111111x36f61433p321e5b8175a13d08@mail.gmail.com>
	<Pine.LNX.4.64.0802112026470.30955@jikos.suse.cz>
	<47B0B1AB.3020203@zytor.com>
	<Pine.LNX.4.64.0802112137360.30955@jikos.suse.cz>
X-Yow: TAPPING?  You POLITICIANS!  Don't you realize that the END of the
 ``Wash Cycle'' is a TREASURED MOMENT for most people?!
Date: Mon, 11 Feb 2008 23:14:38 +0100
In-Reply-To: <Pine.LNX.4.64.0802112137360.30955@jikos.suse.cz> (Jiri Kosina's
	message of "Mon\, 11 Feb 2008 21\:40\:22 +0100 \(CET\)")
Message-ID: <jeabm7nnsh.fsf@sykes.suse.de>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/22.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jiri Kosina <jkosina@suse.cz> writes:

> On Mon, 11 Feb 2008, H. Peter Anvin wrote:
>
>
>> > Now, the question is whether it is valid for ELF binary to not have the end
>> > of .bss section (if present at all) not page-aligned.
>> Why wouldn't it be?  It would, however, be valid to the kernel to round it up
>> to the next boundary.
>
> I wasn't immediately sure if there is nothing in ELF specification that 
> would forbid that.

The only requirement for a loadable segment is that its address is
congruent modulo alignment with the file offset.

Andreas.

-- 
Andreas Schwab, SuSE Labs, schwab@suse.de
SuSE Linux Products GmbH, Maxfeldstraße 5, 90409 Nürnberg, Germany
PGP key fingerprint = 58CA 54C7 6D53 942B 1756  01D3 44D5 214B 8276 4ED5
"And now for something completely different."
