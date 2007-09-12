Return-Path: <linux-kernel-owner+w=401wt.eu-S1762236AbXILFQ7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762236AbXILFQ7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2007 01:16:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751845AbXILFQv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Sep 2007 01:16:51 -0400
Received: from MGW4.Sony.CO.JP ([137.153.0.46]:45781 "EHLO mgw4.sony.co.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751382AbXILFQu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2007 01:16:50 -0400
X-Greylist: delayed 10630 seconds by postgrey-1.27 at vger.kernel.org; Wed, 12 Sep 2007 01:16:50 EDT
Message-ID: <46E74C95.3090402@am.sony.com>
Date: Tue, 11 Sep 2007 19:19:01 -0700
From: Geoff Levand <geoffrey.levand@am.sony.com>
User-Agent: Thunderbird 1.5.0.12 (X11/20070719)
MIME-Version: 1.0
To: Michael Neuling <mikey@neuling.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, akpm@linux-foundation.org,
       paulus@samba.org, Alan Cox <alan@redhat.com>,
       "David S. Miller" <davem@davemloft.net>, linuxppc-dev@ozlabs.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] powerpc: add new required termio functions
References: <8018.1189562679@neuling.org>
In-Reply-To: <8018.1189562679@neuling.org>
X-Enigmail-Version: 0.94.3.0
X-MIMETrack: Itemize by SMTP Server on SCE_MGW01/SCEI(Release 7.0.2FP1|January 10, 2007) at
 2007/09/12 11:19:35,
	Serialize by Router on SCE_MGW01/SCEI(Release 7.0.2FP1|January 10, 2007) at
 2007/09/12 11:19:36,
	Serialize complete at 2007/09/12 11:19:36
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Michael Neuling wrote:
> The "tty: termios locking functions break with new termios type" patch
> (f629307c857c030d5a3dd777fee37c8bb395e171) breaks the powerpc compile.
> This adds the required API to asm-powerpc.
> 
> Signed-off-by: Michael Neuling <mikey@neuling.org>
> --
> This needs to go up for 2.6.23.
> 
> Should we really put these definitions in asm-generic/termios.h as I'm
> guessing other architectures are broken too?

I think it would be better to do so, as that is where we pickup the defs for
the original kernel_termios_to_user_termios and user_termios_to_kernel_termios.

-Geoff
