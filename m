Return-Path: <linux-kernel-owner+w=401wt.eu-S1754642AbXJJLXd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754642AbXJJLXd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Oct 2007 07:23:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752103AbXJJLXZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Oct 2007 07:23:25 -0400
Received: from ns2.suse.de ([195.135.220.15]:48720 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751983AbXJJLXY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Oct 2007 07:23:24 -0400
From: Andreas Schwab <schwab@suse.de>
To: Alexey Dobriyan <adobriyan@sw.ru>
Cc: Al Viro <viro@ftp.linux.org.uk>, linux-kernel@vger.kernel.org,
       davej@codemonkey.org.uk, Pierre Ossman <drzeus@drzeus.cx>,
       akpm@osdl.org, linux-sparse@vger.kernel.org
Subject: Re: idio{,ma}tic typos (was Re: + fix-vm_can_nonlinear-check-in-sys_remap_file_pages.patch added to -mm tree)
References: <20071010104540.GA6366@localhost.sw.ru>
X-Yow: Used staples are good with SOY SAUCE!
Date: Wed, 10 Oct 2007 13:23:19 +0200
In-Reply-To: <20071010104540.GA6366@localhost.sw.ru> (Alexey Dobriyan's
	message of "Wed\, 10 Oct 2007 14\:45\:40 +0400")
Message-ID: <je7ilvtdqw.fsf@sykes.suse.de>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/22.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Alexey Dobriyan <adobriyan@sw.ru> writes:

> --- a/drivers/net/wireless/arlan.h
> +++ b/drivers/net/wireless/arlan.h
> @@ -485,7 +485,7 @@ struct arlan_private {
>  #define clearClearInterrupt(dev){\
>     writeControlRegister(dev,readControlRegister(dev) & ~ARLAN_CLEAR_INTERRUPT);}
>  #define setPowerOff(dev){\
> -   writeControlRegister(dev,readControlRegister(dev) | (ARLAN_POWER && ARLAN_ACCESS));\
> +   writeControlRegister(dev,readControlRegister(dev) | (ARLAN_POWER & ARLAN_ACCESS));\

Methinks that this actually wants (ARLAN_POWER | ARLAN_ACCESS), since
(ARLAN_POWER & ARLAN_ACCESS) == 0.

Andreas.

-- 
Andreas Schwab, SuSE Labs, schwab@suse.de
SuSE Linux Products GmbH, Maxfeldstraße 5, 90409 Nürnberg, Germany
PGP key fingerprint = 58CA 54C7 6D53 942B 1756  01D3 44D5 214B 8276 4ED5
"And now for something completely different."
