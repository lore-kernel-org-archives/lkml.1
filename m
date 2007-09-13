Return-Path: <linux-kernel-owner+w=401wt.eu-S1752322AbXIMHMy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752322AbXIMHMy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Sep 2007 03:12:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751056AbXIMHMq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Sep 2007 03:12:46 -0400
Received: from 74-93-104-98-Washington.hfc.comcastbusiness.net ([74.93.104.98]:49777
	"EHLO picasso.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751111AbXIMHMp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Sep 2007 03:12:45 -0400
Date: Thu, 13 Sep 2007 00:11:45 -0700 (PDT)
Message-Id: <20070913.001145.78733806.davem@davemloft.net>
To: jdi@l4x.org
Cc: paulus@samba.org, torvalds@linux-foundation.org, akpm@linux-foundation.org,
       tony@bakeyournoodle.com, mikey@neuling.org,
       linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org, alan@redhat.com,
       heiko.carstens@de.ibm.com, hskinnemoen@atmel.com, dhowells@redhat.com
Subject: Re: Define termios_1 functions for powerpc, s390, avr32 and frv
From: David Miller <davem@davemloft.net>
In-Reply-To: <46E8DF49.7090402@l4x.org>
References: <18152.719.316280.579601@cargo.ozlabs.ibm.com>
	<46E8DF49.7090402@l4x.org>
X-Mailer: Mew version 5.2 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jan Dittmer <jdi@l4x.org>
Date: Thu, 13 Sep 2007 08:57:13 +0200

> Paul Mackerras wrote:
> > Commit f629307c857c030d5a3dd777fee37c8bb395e171 introduced uses of
> > kernel_termios_to_user_termios_1 and user_termios_to_kernel_termios_1
> > on all architectures.  However, powerpc, s390, avr32 and frv don't
> > currently define those functions since their termios struct didn't
> > need to be changed when the arbitrary baud rate stuff was added, and
> > thus the kernel won't currently build on those architectures.
> 
> alpha, parisc, sh, sparc{64,}, xtensa are still broken with this error...

I sent Alan a patch last week that added the Sparc bits, it would
be nice if he or someone else could merge it as I'm travelling
today :-)
