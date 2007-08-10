Return-Path: <linux-kernel-owner+w=401wt.eu-S932820AbXHJR6L@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932820AbXHJR6L (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Aug 2007 13:58:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756339AbXHJR54
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Aug 2007 13:57:56 -0400
Received: from mu-out-0910.google.com ([209.85.134.191]:17899 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755364AbXHJR5z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Aug 2007 13:57:55 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:content-type:content-transfer-encoding;
        b=cu/TRuvRHUjU/4BTrQMvnrAYMpGm8wqS+tRDfrkPKy5bicQsRVh79UxWVy5LWGj7yTbb8iL5laV8V5nsbaGIh87YygYERgHdP03IOcGg18Z8bjs4tW4peaKbeY7ockIftoaKISbc92AtIAhxTyjv3SeL7q6oGPOxMPNStJPFUQs=
Message-ID: <46BCA6A9.6000402@googlemail.com>
Date: Fri, 10 Aug 2007 19:55:53 +0200
From: Gabriel C <nix.or.die@googlemail.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070803)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>
Subject: arch/i386/kernel/setup.c - compile error (Re: 2.6.23-rc2-mm2)
References: <20070809224254.11f42716.akpm@linux-foundation.org>
In-Reply-To: <20070809224254.11f42716.akpm@linux-foundation.org>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


>  git-newsetup.patch

...

arch/i386/kernel/setup.c: In function 'setup_arch':
arch/i386/kernel/setup.c:547: error: 'PARAM' undeclared (first use in this function)
arch/i386/kernel/setup.c:547: error: (Each undeclared identifier is reported only once
arch/i386/kernel/setup.c:547: error: for each function it appears in.)
make[1]: *** [arch/i386/kernel/setup.o] Error 1
make: *** [arch/i386/kernel] Error 2
make: *** Waiting for unfinished jobs....
 
....

Got it on a randconfig :

http://194.231.229.228/kernel/mm/2.6.23-rc2-mm2/randconfig-auto-25
