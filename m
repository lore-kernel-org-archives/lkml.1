Return-Path: <linux-kernel-owner+w=401wt.eu-S1760550AbZC3Tr3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760550AbZC3Tr3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Mar 2009 15:47:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757153AbZC3TrU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Mar 2009 15:47:20 -0400
Received: from buzzloop.caiaq.de ([212.112.241.133]:46503 "EHLO
	buzzloop.caiaq.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758027AbZC3TrU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Mar 2009 15:47:20 -0400
Date: Mon, 30 Mar 2009 21:47:14 +0200
From: Daniel Mack <daniel@caiaq.de>
To: Torsten Schmidt <torsten.schmidt@s2006.tu-chemnitz.de>
Cc: linux-kernel@vger.kernel.org
Subject: Re: 2.6.29: Error during update of the kernel configuration.
Message-ID: <20090330194714.GA7165@buzzloop.caiaq.de>
References: <200903302059.54566.schmto@hrz.tu-chemnitz.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200903302059.54566.schmto@hrz.tu-chemnitz.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 30, 2009 at 08:59:54PM +0200, Torsten Schmidt wrote:
> I am not quit sure if this should be reported here: After loading the new 
> kernel 2.6.29, the following error appears:
> 
> # make defconfig
> *** Default configuration is based on 'i386_defconfig'
> usr/Kconfig:145:warning: defaults for choice values not supported
> #
> # configuration written to .config
> #
> 
> # make
> scripts/kconfig/conf -s arch/x86/Kconfig
> usr/Kconfig:145:warning: defaults for choice values not supported
> 
> *** Error during update of the kernel configuration.
> 
> make[2]: *** [silentoldconfig] Fehler 1
> make[1]: *** [silentoldconfig] Fehler 2
> make: *** [include/config/auto.conf] Fehler 2
> 
> Whats going wrong ?

Running 'make oldconfig' should help.

Daniel

