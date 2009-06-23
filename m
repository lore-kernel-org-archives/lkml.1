Return-Path: <linux-kernel-owner+w=401wt.eu-S1751256AbZFWMGN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751256AbZFWMGN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jun 2009 08:06:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751770AbZFWMF7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jun 2009 08:05:59 -0400
Received: from one.firstfloor.org ([213.235.205.2]:54917 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750777AbZFWMF6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jun 2009 08:05:58 -0400
To: Arnd Bergmann <arnd@arndb.de>
Cc: liqin.chen@sunplusct.com, Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org
Subject: Re: S+core architecture (arch/score/) support files
From: Andi Kleen <andi@firstfloor.org>
References: <OF318304AE.9C3DA8BC-ON482575DE.002B7553-482575DE.002FC96B@sunplusct.com>
	<200906231143.22985.arnd@arndb.de>
Date: Tue, 23 Jun 2009 14:06:00 +0200
In-Reply-To: <200906231143.22985.arnd@arndb.de> (Arnd Bergmann's message of "Tue, 23 Jun 2009 11:43:22 +0200")
Message-ID: <87zlbz17fb.fsf@basil.nowhere.org>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/22.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arnd Bergmann <arnd@arndb.de> writes:
>
> Unfortunately, I don't think that the score glibc has been fully
> ported to support this, so it also means that the version that is
> being submitted has undergone any run-time testing. I did check
> that it compiles fine but could not do more in lack of hardware
> or even just a user space distro.

IMHO a full successfull LTP run should be minimal criterium for
merging an architecture. That should catch most of the possible
"simple" mistakes in the syscall ABI. I would suggest to wait to after
this has been done.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
