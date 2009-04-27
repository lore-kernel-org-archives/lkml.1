Return-Path: <linux-kernel-owner+w=401wt.eu-S1760387AbZD0Xtd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760387AbZD0Xtd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Apr 2009 19:49:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757095AbZD0XtX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Apr 2009 19:49:23 -0400
Received: from BISCAYNE-ONE-STATION.MIT.EDU ([18.7.7.80]:65500 "EHLO
	biscayne-one-station.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756405AbZD0XtW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Apr 2009 19:49:22 -0400
Date: Mon, 27 Apr 2009 19:48:09 -0400 (EDT)
From: Tim Abbott <tabbott@MIT.EDU>
To: David Howells <dhowells@redhat.com>
cc: Sam Ravnborg <sam@ravnborg.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Linux kernel mailing list <linux-kernel@vger.kernel.org>,
       Anders Kaseorg <andersk@MIT.EDU>, Waseem Daher <wdaher@MIT.EDU>,
       Denys Vlasenko <vda.linux@googlemail.com>,
       Jeff Arnold <jbarnold@MIT.EDU>, Paul Mundt <lethal@linux-sh.org>
Subject: Re: [PATCH 03/14] mn10300: Use macros for .bss.page_aligned
 section.
In-Reply-To: <4678.1240875782@redhat.com>
Message-ID: <alpine.DEB.1.10.0904271946520.27012@vinegar-pot.mit.edu>
References: <1240864388-26315-4-git-send-email-tabbott@mit.edu> <1240864388-26315-1-git-send-email-tabbott@mit.edu> <1240864388-26315-2-git-send-email-tabbott@mit.edu> <1240864388-26315-3-git-send-email-tabbott@mit.edu> <4678.1240875782@redhat.com>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Spam-Flag: NO
X-Spam-Score: 0.00
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 28 Apr 2009, David Howells wrote:

> Tim Abbott <tabbott@MIT.EDU> wrote:
> 
> > -	*(.bss.page_aligned)
> > +	PAGE_ALIGNED_BSS
> 
> /opt/nickc/H-i686-pc-linux-gnulibc2.3/bin/am33_2.0-linux-gnu-ld: cannot find PAGE_ALIGNED_BSS
> 
> warthog>grep -r PAGE_ALIGNED_BSS include/linux/
> warthog1>grep -r PAGE_ALIGNED_BSS include/asm-generic/
> warthog1>grep -r PAGE_ALIGNED_BSS arch/frv/
> warthog1>
> 
> I take it that wasn't what you meant.

No, it is.  The macro is new in PATCH 1/14 of this series.

	-Tim Abbott
