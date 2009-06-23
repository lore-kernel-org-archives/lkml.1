Return-Path: <linux-kernel-owner+w=401wt.eu-S1759574AbZFWN4j@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759574AbZFWN4j (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jun 2009 09:56:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754225AbZFWN4a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jun 2009 09:56:30 -0400
Received: from moutng.kundenserver.de ([212.227.17.10]:57219 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753975AbZFWN4a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jun 2009 09:56:30 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Andi Kleen <andi@firstfloor.org>
Subject: Re: S+core architecture (arch/score/) support files
Date: Tue, 23 Jun 2009 15:55:54 +0200
User-Agent: KMail/1.11.90 (Linux/2.6.30-9-generic; KDE/4.2.90; x86_64; ; )
Cc: liqin.chen@sunplusct.com, Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org
References: <OF318304AE.9C3DA8BC-ON482575DE.002B7553-482575DE.002FC96B@sunplusct.com> <200906231143.22985.arnd@arndb.de> <87zlbz17fb.fsf@basil.nowhere.org>
In-Reply-To: <87zlbz17fb.fsf@basil.nowhere.org>
X-Face: I@=L^?./?$U,EK.)V[4*>`zSqm0>65YtkOe>TFD'!aw?7OVv#~5xd\s,[~w]-J!)|%=]>
 =?utf-8?q?+=0A=09=7EohchhkRGW=3F=7C6=5FqTmkd=5Ft=3FLZC=23Q-=60=2E=60Y=2Ea=5E?=
 =?utf-8?q?3zb?=)
 =?utf-8?q?+U-JVN=5DWT=25cw=23=5BYo0=267C=26bL12wWGlZi=0A=09=7EJ=3B=5Cwg?=
 =?utf-8?q?=3B3zRnz?=,J"CT_)=\H'1/{?SR7GDu?WIopm.HaBG=QYj"NZD_[zrM\Gip^U
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200906231555.54887.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX1+57d/NEsK+gypJjWnDrzhE1DJg/DSJuu9gE+k
 sqveMGf4LLD13ETsGPN/Z3eELt9c25EYyNCJMRqjSrNBhjvcG4
 PrFEc08xQHXbF+h/ljxVA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 23 June 2009, Andi Kleen wrote:
> IMHO a full successfull LTP run should be minimal criterium for
> merging an architecture. That should catch most of the possible
> "simple" mistakes in the syscall ABI. I would suggest to wait to after
> this has been done.

I agree in general, but in this case the ABI is essentially defined
through the asm-generic headers, with the exception of the functions
that actually were tested before the change (sys_clone, sys_execve,
sys_rt_sigreturn and sys_sig).

We should certainly fix the asm-generic versions if there are some
unexpected problems found by LTP, but delaying the score merge
won't help that, because the interesting code is already there.

While I understand the argument against merging untested code
(that's why I mentioned it in the first place), I think in
this case it's not about the ABI and the code is obviously
self-contained enough to cause no harm to others.

	Arnd <><
