Return-Path: <linux-kernel-owner+w=401wt.eu-S1752593AbXIMHFo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752593AbXIMHFo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Sep 2007 03:05:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751016AbXIMHFh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Sep 2007 03:05:37 -0400
Received: from rzcomm22.rz.tu-bs.de ([134.169.9.68]:60971 "EHLO
	rzcomm22.rz.tu-bs.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750876AbXIMHFg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Sep 2007 03:05:36 -0400
Message-ID: <46E8DF49.7090402@l4x.org>
Date: Thu, 13 Sep 2007 08:57:13 +0200
From: Jan Dittmer <jdi@l4x.org>
User-Agent: Mozilla-Thunderbird 2.0.0.4 (X11/20070828)
MIME-Version: 1.0
To: Paul Mackerras <paulus@samba.org>
CC: Linus Torvalds <torvalds@linux-foundation.org>, akpm@linux-foundation.org,
       Tony Breeds <tony@bakeyournoodle.com>,
       Michael Neuling <mikey@neuling.org>, linux-kernel@vger.kernel.org,
       linuxppc-dev@ozlabs.org, Alan Cox <alan@redhat.com>,
       davem@davemloft.net, heiko.carstens@de.ibm.com, hskinnemoen@atmel.com,
       dhowells@redhat.com
Subject: Re: Define termios_1 functions for powerpc, s390, avr32 and frv
References: <18152.719.316280.579601@cargo.ozlabs.ibm.com>
In-Reply-To: <18152.719.316280.579601@cargo.ozlabs.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Paul Mackerras wrote:
> Commit f629307c857c030d5a3dd777fee37c8bb395e171 introduced uses of
> kernel_termios_to_user_termios_1 and user_termios_to_kernel_termios_1
> on all architectures.  However, powerpc, s390, avr32 and frv don't
> currently define those functions since their termios struct didn't
> need to be changed when the arbitrary baud rate stuff was added, and
> thus the kernel won't currently build on those architectures.

alpha, parisc, sh, sparc{64,}, xtensa are still broken with this error...

Jan
