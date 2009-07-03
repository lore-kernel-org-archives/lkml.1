Return-Path: <linux-kernel-owner+w=401wt.eu-S1759282AbZGCVUL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759282AbZGCVUL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jul 2009 17:20:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756647AbZGCVUA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Jul 2009 17:20:00 -0400
Received: from mail-out.m-online.net ([212.18.0.10]:34251 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753108AbZGCVT7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jul 2009 17:19:59 -0400
From: Andreas Schwab <schwab@linux-m68k.org>
To: kernel mailz <kernelmailz@googlemail.com>
Cc: Brad Boyer <flar@allandria.com>, linuxppc-dev@ozlabs.org,
       gcc-help@gcc.gnu.org, linux-kernel@vger.kernel.org
Subject: Re: Inline assembly queries [2]
References: <abe8a1fd0907022344k2eb9874ejdbda3209a7cadf40@mail.gmail.com>
	<20090703174031.GA12410@cynthia.pants.nu>
	<abe8a1fd0907031305r5cb9e2e8pec170bffb1c497ff@mail.gmail.com>
X-Yow: ..  Now I think I just reached the state of HYPERTENSION that comes
 JUST BEFORE you see the TOTAL at the SAFEWAY CHECKOUT COUNTER!
Date: Fri, 03 Jul 2009 23:19:57 +0200
In-Reply-To: <abe8a1fd0907031305r5cb9e2e8pec170bffb1c497ff@mail.gmail.com>
	(kernel mailz's message of "Sat, 4 Jul 2009 01:35:50 +0530")
Message-ID: <m2vdm9cvlu.fsf@igel.home>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.95 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

kernel mailz <kernelmailz@googlemail.com> writes:

> My query was more on %U1%X1, I guess it is specifying U and/or X for %1 right ?
> what does U/X stand for (is it similar to u - unsigned and x for a hex address)
> are there any more literals like U/X/...

The 'U' and 'X' modifiers expand to 'u' and 'x' resp, depending on the
form of the referenced memory operand.  That allows one to select the
right mnemonic among for example lwz, lwzu, lwzx and lwzux.  Those
modifiers must always be used together with the "m" constraint.

Andreas.

-- 
Andreas Schwab, schwab@linux-m68k.org
GPG Key fingerprint = 58CA 54C7 6D53 942B 1756  01D3 44D5 214B 8276 4ED5
"And now for something completely different."
