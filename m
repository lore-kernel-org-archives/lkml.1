Return-Path: <linux-kernel-owner+w=401wt.eu-S1755211AbYDFR73@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755211AbYDFR73 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Apr 2008 13:59:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751883AbYDFR7N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Apr 2008 13:59:13 -0400
Received: from terminus.zytor.com ([198.137.202.10]:54439 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754098AbYDFR7J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Apr 2008 13:59:09 -0400
Message-ID: <47F90F53.7060007@zytor.com>
Date: Sun, 06 Apr 2008 10:58:43 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: David Brownell <david-b@pacbell.net>
CC: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: (regression) kernel/timeconst.h bugs with HZ=128
References: <pdj7pZVURbL.A.42H.kDW9HB@albercik> <pdYe6zNQVl.A.-CB.KGW9HB@albercik> <200804060029.34551.david-b@pacbell.net>
In-Reply-To: <200804060029.34551.david-b@pacbell.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Brownell wrote:
> 
> The (new) compiler warnings are still being issued, yes.
> 

I have a cleaner patchset prepared than the one that got bikeshed 
painted out of existence, but I want to wait until post-2.6.25 for it.

The nice thing is that it deletes a lot more code than it adds:

  include/asm-alpha/types.h      |   36 --------------
  include/asm-arm/types.h        |   33 -------------
  include/asm-avr32/types.h      |   32 -------------
  include/asm-blackfin/types.h   |   34 -------------
  include/asm-cris/types.h       |   33 -------------
  include/asm-frv/types.h        |   34 -------------
  include/asm-generic/Kbuild     |    2
  include/asm-generic/int-l64.h  |   71 ++++++++++++++++++++++++++++
  include/asm-generic/int-ll64.h |   76 +++++++++++++++++++++++++++++++
  include/asm-h8300/types.h      |   33 -------------
  include/asm-ia64/types.h       |   31 ------------
  include/asm-m32r/types.h       |   32 -------------
  include/asm-m68k/types.h       |   32 -------------
  include/asm-mips/types.h       |   56 ++--------------------
  include/asm-mn10300/types.h    |   33 -------------
  include/asm-parisc/types.h     |   33 -------------
  include/asm-powerpc/types.h    |   48 ++-----------------
  include/asm-s390/types.h       |   48 ++-----------------
  include/asm-sh/types.h         |   34 -------------
  include/asm-sparc/types.h      |   30 ------------
  include/asm-sparc64/types.h    |   30 ------------
  include/asm-v850/types.h       |   32 -------------
  include/asm-x86/types.h        |   38 ---------------
  include/asm-xtensa/types.h     |   33 -------------
  kernel/time.c                  |    8 +--
  25 files changed, 201 insertions(+), 701 deletions(-)

See:

git://git.kernel.org/pub/scm/linux/kernel/git/hpa/linux-2.6-inttypes.git

	-hpa

