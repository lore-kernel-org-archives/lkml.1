Return-Path: <linux-kernel-owner+w=401wt.eu-S1763777AbXHWNRn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763777AbXHWNRn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Aug 2007 09:17:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762225AbXHWNRf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Aug 2007 09:17:35 -0400
Received: from nf-out-0910.google.com ([64.233.182.187]:18656 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763386AbXHWNRe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Aug 2007 09:17:34 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:content-type:content-transfer-encoding;
        b=htFuB+ca2knL3LyvqPgOAN9kWQa5of3yWv4weIUXFPc9DHnBi/4xnoheZ2AEJpj+6R5yy5jLnYr8VQXIxYvruh/ETujexJF6b8ge6ALI1ajVc/+0KRP7EgM1qg7JMNtHVgQ/Tl0hLKmGoVkWeeZPo8ko4x3wUsglrVCM4n+8Ipw=
Message-ID: <46CD888A.6020605@googlemail.com>
Date: Thu, 23 Aug 2007 15:15:54 +0200
From: Gabriel C <nix.or.die@googlemail.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070803)
MIME-Version: 1.0
To: Rusty Russell <rusty@rustcorp.com.au>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: lguest modpost errors
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Rusty,

I got the following modpost errors with a randconfig on current git head ( b377fd3982ad957c796758a90e2988401a884241 )

...

Kernel: arch/i386/boot/bzImage is ready  (#267)
ERROR: "get_futex_key" [drivers/lguest/lg.ko] undefined!
ERROR: "drop_futex_key_refs" [drivers/lguest/lg.ko] undefined!
ERROR: "get_futex_key_refs" [drivers/lguest/lg.ko] undefined!
make[1]: *** [__modpost] Error 1
make: *** [modules] Error 2

...

config : http://194.231.229.228/kernel/randconfig-lguest



Regards,

Gabriel
