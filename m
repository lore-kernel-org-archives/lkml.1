Return-Path: <linux-kernel-owner+w=401wt.eu-S1762751AbXHAK4r@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762751AbXHAK4r (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Aug 2007 06:56:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757439AbXHAK4i
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Aug 2007 06:56:38 -0400
Received: from nf-out-0910.google.com ([64.233.182.189]:21627 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756927AbXHAK4b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Aug 2007 06:56:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:content-type:content-transfer-encoding;
        b=uPjAqiKjVXUnkPxJR3ePMd3MFZOJn3P5gzRf+ZAjTviCVX0Gp3/yZtVuM0G8pm1aWIY8jYhoVMCFrjkJD0+X0f2w5npK0V++RGpzbhc9WjmvLYdsUzaQ69llttA5sXDG8/Cau4EjVZ1Le+kf2JyfuIhJ11uBf4UtHHWuqIQdLqs=
Message-ID: <46B066C9.9030100@googlemail.com>
Date: Wed, 01 Aug 2007 12:56:09 +0200
From: Gabriel C <nix.or.die@googlemail.com>
User-Agent: Thunderbird 2.0.0.5 (X11/20070721)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: linux-kernel@vger.kernel.org
Subject: Re: 2.6.23-rc1-mm2
References: <20070731230932.a9459617.akpm@linux-foundation.org>
In-Reply-To: <20070731230932.a9459617.akpm@linux-foundation.org>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
...
> - git-wireless is back.  It is still a >3MB diff, and appears to compile.
> 
...

allmodconfig on UML 

...


In file included from drivers/net/wireless/bcm43xx-mac80211/bcm43xx_main.c:48:
drivers/net/wireless/bcm43xx-mac80211/bcm43xx_pio.h: In function 'bcm43xx_pio_write':
drivers/net/wireless/bcm43xx-mac80211/bcm43xx_pio.h:97: error: implicit declaration of function 'mmiowb'
drivers/net/wireless/bcm43xx-mac80211/bcm43xx_main.c: In function 'bcm43xx_init':
drivers/net/wireless/bcm43xx-mac80211/bcm43xx_main.c:4051: warning: label 'err_dfs_exit' defined but not used
make[4]: *** [drivers/net/wireless/bcm43xx-mac80211/bcm43xx_main.o] Error 1
make[3]: *** [drivers/net/wireless/bcm43xx-mac80211] Error 2
make[2]: *** [drivers/net/wireless] Error 2
make[1]: *** [drivers/net] Error 2
make: *** [drivers] Error 2
make: *** Waiting for unfinished jobs....


...


Gabriel
