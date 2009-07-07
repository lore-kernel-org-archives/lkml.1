Return-Path: <linux-kernel-owner+w=401wt.eu-S1756557AbZGGMko@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756557AbZGGMko (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jul 2009 08:40:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755758AbZGGMkh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Jul 2009 08:40:37 -0400
Received: from mx2.redhat.com ([66.187.237.31]:39436 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755109AbZGGMkg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jul 2009 08:40:36 -0400
From: Andreas Schwab <schwab@linux-m68k.org>
To: Gabriel Paubert <paubert@iram.es>
Cc: Brad Boyer <flar@allandria.com>, gcc-help@gcc.gnu.org,
       linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org,
       kernel mailz <kernelmailz@googlemail.com>
Subject: Re: Inline assembly queries [2]
References: <abe8a1fd0907022344k2eb9874ejdbda3209a7cadf40@mail.gmail.com>
	<20090703174031.GA12410@cynthia.pants.nu> <m23a9deb87.fsf@igel.home>
	<20090706065627.GA12499@iram.es>
X-Yow: The entire CHINESE WOMEN'S VOLLEYBALL TEAM all share ONE personality --
 and have since BIRTH!!
Date: Tue, 07 Jul 2009 14:40:02 +0200
In-Reply-To: <20090706065627.GA12499@iram.es> (Gabriel Paubert's message of
	"Mon, 6 Jul 2009 08:56:27 +0200")
Message-ID: <m37hykis4d.fsf@hase.home>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.95 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Gabriel Paubert <paubert@iram.es> writes:

> On Fri, Jul 03, 2009 at 10:57:12PM +0200, Andreas Schwab wrote:
>> The 'Z' constraint is required for a memory operand for insns that don't
>> have an update form (which would be selected by the %U modifier).  
>
> Hmmm, I believed that it was for instructions that only have an indexed
> form (all Altivec, byte reverse, and l?arx/st?cx for atomic operations).
>
> Of course none of these instructions have an update form, but they don't
> have an offset encoded in the instruction either.

Yes, you are right.  IIRC there are either all u/x/ux forms or only the
x form.

Andreas.

-- 
Andreas Schwab, schwab@linux-m68k.org
GPG Key fingerprint = 58CA 54C7 6D53 942B 1756  01D3 44D5 214B 8276 4ED5
"And now for something completely different."
