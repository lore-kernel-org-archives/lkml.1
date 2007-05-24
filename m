Return-Path: <linux-kernel-owner+w=401wt.eu-S1752188AbXEXRKo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752188AbXEXRKo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2007 13:10:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751222AbXEXRK1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 May 2007 13:10:27 -0400
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:44602 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751046AbXEXRK0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2007 13:10:26 -0400
Date: Thu, 24 May 2007 19:10:19 +0200
From: Adrian Bunk <bunk@stusta.de>
To: Roland Dreier <rdreier@cisco.com>
Cc: Arjan van de Ven <arjan@linux.intel.com>, Rob Landley <rob@landley.net>,
       linux-kernel@vger.kernel.org
Subject: Re: Status of CONFIG_FORCED_INLINING?
Message-ID: <20070524171019.GA4470@stusta.de>
References: <200705231510.52932.rob@landley.net> <46549937.1030306@linux.intel.com> <20070523212237.GH2098@stusta.de> <ada7iqz9qlj.fsf@cisco.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <ada7iqz9qlj.fsf@cisco.com>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 23, 2007 at 02:28:56PM -0700, Roland Dreier wrote:
>  > - every static function in a header file must be __always_inline
> 
> Why?  Why does it matter whether a function is defined in a .h file or
> a .c file?  Can't the compiler decide better than we can whether
> something should be inlined or not?
> 
> Your argument seems to imply that we should never use the inline
> keyword at all.

A function only belongs into a header file if we always want it inlined, 
otherwise it belongs into a C file.

>  - R.

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

