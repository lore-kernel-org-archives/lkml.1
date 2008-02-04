Return-Path: <linux-kernel-owner+w=401wt.eu-S1757280AbYBDTNR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757280AbYBDTNR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2008 14:13:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753857AbYBDTNE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Feb 2008 14:13:04 -0500
Received: from pasmtpa.tele.dk ([80.160.77.114]:50428 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753853AbYBDTNB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2008 14:13:01 -0500
Date: Mon, 4 Feb 2008 20:13:05 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Oliver Pinter =?iso-8859-1?B?KFBpbnTpciBPbGl26XIp?= 
	<oliver.pntr@gmail.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [Kconfig {SM,E}] 2.6.24-git13 9135f1901ee6449dfe338adf6e40e9c2025b8150
Message-ID: <20080204191305.GC16050@uranus.ravnborg.org>
References: <6101e8c40802040556y7c58a729m13c4f3e81aff001@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <6101e8c40802040556y7c58a729m13c4f3e81aff001@mail.gmail.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Oliver.

On Mon, Feb 04, 2008 at 02:56:07PM +0100, Oliver Pinter (Pintér Olivér) wrote:
> git top: 9135f1901ee6449dfe338adf6e40e9c2025b8150
> 
> -------8<-------
> drivers/spi/Kconfig:156:warning: 'select' used by config symbol
> 'SPI_PXA2XX' refers to undefined symbol 'PXA_SSP'
> 
> WARNING: vmlinux.o(.text+0xe01e): Section mismatch in reference from
> the function acpi_unmap_lsapic() to the variable
> .cpuinit.data:num_processors
...
Yes - we all see them. They will soon be silenced and only
a summarycounter is printed.
For now you can safely ignore them.

> 
> make[4]: Warning: File `/dev/null' has modification time 2,1e+03 s in the future
> make[5]: Warning: File `/dev/null' has modification time 2,1e+03 s in the future
>   CHECK   include/asm-generic/errno-base.h

These looks strange. I have not seen this message before.
Did you adjust your clock backwards recently?

	Sam

