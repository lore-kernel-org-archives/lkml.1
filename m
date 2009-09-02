Return-Path: <linux-kernel-owner+w=401wt.eu-S1751830AbZIBLkE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751830AbZIBLkE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Sep 2009 07:40:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751570AbZIBLkD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Sep 2009 07:40:03 -0400
Received: from lo.gmane.org ([80.91.229.12]:40233 "EHLO lo.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751071AbZIBLkC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Sep 2009 07:40:02 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Detlev Zundel <dzu@denx.de>
Subject: Re: [RFC][POWERPC] WDT: added support for the WDT Chain driver.
Date: Wed, 02 Sep 2009 13:32:23 +0200
Organization: Church of Emacs - Missionary division
Message-ID: <m2d469pooo.fsf@ohwell.denx.de>
References: <20090902004928.132974c9@vitb-lp>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Complaints-To: usenet@ger.gmane.org
Cc: linuxppc-dev@ozlabs.org
X-Gmane-NNTP-Posting-Host: p4ff065d6.dip.t-dialin.net
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.94 (gnu/linux)
Cancel-Lock: sha1:VfehpceO3H3WshyF9tUtF78qO7A=
Cc: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Vitaly,

> From: Heiko Schocher <hs@denx.de>
>
> [POWERPC] WDT: added support for the WDT Chain driver.
>
>     This new driver implements a character device with major number 10
>     and minor number 130.  It is a software abstraction of the hardware
>     watchdog with two different APIs.  While the driver periodically
>     triggers the hardware watchdog, the software can setup independent
>     timeout periods.
>
>     More info in Documentation/watchdog/wdt_chain.txt
>
>     Signed-off-by: Heiko Schocher <hs@denx.de>
>     Signed-off-by: Vitaly Bordug <vitb@kernel.crashing.org>
> ---
> This code was (and is) originally residing in DENX public git repo. I
> think it would be useful upstream, to prevent reinventing the same
> thing. 

Thanks a lot for taking an interest in this piece of code.  I would
suggest however that you coordinate with Heiko as he has worked some
more on this driver in the meantime.  This new code however is not in
our repository.  We should start the RFC discussion with current code.

For the casual reader this means, don't invest time into reviewing this
but wait for a cleaned up version instead.

Thanks
  Detlev

--
DENX Software Engineering GmbH,      MD: Wolfgang Denk & Detlev Zundel
HRB 165235 Munich,  Office: Kirchenstr.5, D-82194 Groebenzell, Germany
Phone: (+49)-8142-66989-40 Fax: (+49)-8142-66989-80 Email: dzu@denx.de

