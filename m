Return-Path: <linux-kernel-owner+w=401wt.eu-S933697AbXHVRLz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933697AbXHVRLz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2007 13:11:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765405AbXHVRLm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Aug 2007 13:11:42 -0400
Received: from nf-out-0910.google.com ([64.233.182.187]:27984 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764907AbXHVRLk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2007 13:11:40 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:content-type:content-transfer-encoding;
        b=azWg/hYIxPpfoE4whLn7R9BQj306DvUD8nkO+M3jTIwUMHvE1/mH0Iumbu0cEIIuuM3aqRJQXK+V9EM6cRiPdySrUnmR6+S4vkYjZdNLnMgo/KQVDXaEfewyNmvsFDTYo6tt2O5vz0VdIFFc6VyxE+MbDywOBtO6cQAiAf+yoI0=
Message-ID: <46CC6DF8.1090504@googlemail.com>
Date: Wed, 22 Aug 2007 19:10:16 +0200
From: Gabriel C <nix.or.die@googlemail.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070803)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: linux-kernel@vger.kernel.org, netdev <netdev@vger.kernel.org>
Subject: drivers/net/ppp_generic - __modpost error ( Re: 2.6.23-rc3-mm1 )
References: <20070822020648.5ea3a612.akpm@linux-foundation.org>
In-Reply-To: <20070822020648.5ea3a612.akpm@linux-foundation.org>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Got it with a randconfig ( http://194.231.229.228/kernel/mm/2.6.23-rc3-mm1/r/randconfig-9 )
( patch from http://lkml.org/lkml/2007/8/22/273 is needed too or CONFIG_SCSI_ADVANSYS need be N)


...

ERROR: "slhc_init" [drivers/net/ppp_generic.ko] undefined!
ERROR: "slhc_remember" [drivers/net/ppp_generic.ko] undefined!
ERROR: "slhc_uncompress" [drivers/net/ppp_generic.ko] undefined!
ERROR: "slhc_free" [drivers/net/ppp_generic.ko] undefined!
ERROR: "slhc_compress" [drivers/net/ppp_generic.ko] undefined!
ERROR: "slhc_toss" [drivers/net/ppp_generic.ko] undefined!
make[1]: *** [__modpost] Error 1
make: *** [modules] Error 2

...


Regards,

Gabriel
