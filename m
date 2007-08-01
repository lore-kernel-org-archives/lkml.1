Return-Path: <linux-kernel-owner+w=401wt.eu-S1755638AbXHAXlj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755638AbXHAXlj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Aug 2007 19:41:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752865AbXHAXl2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Aug 2007 19:41:28 -0400
Received: from mu-out-0910.google.com ([209.85.134.189]:40236 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755234AbXHAXlX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Aug 2007 19:41:23 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:content-type:content-transfer-encoding;
        b=P+2FkIalRKXooRZ6TT5ttvhJFiHvNZrqSu8V+SV2XRB9jtRjLGXOUGgrkN89fokoNtMqFqIl4CqKZXtjMc/9xtqGARiU2XWDlOw77WvVCygu+q0StnLrDqHTrW2eKnd1BtRapsEU21pnp5EHJ2fTweiEpSieSKUcu1VVvd6wmTY=
Message-ID: <46B11A05.9070001@googlemail.com>
Date: Thu, 02 Aug 2007 01:40:53 +0200
From: Gabriel C <nix.or.die@googlemail.com>
User-Agent: Thunderbird 2.0.0.5 (X11/20070721)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: linux-kernel@vger.kernel.org, David Woodhouse <dwmw2@infradead.org>,
       linux-audit@redhat.com, Al Viro <viro@zeniv.linux.org.uk>
Subject: INOTIFY=n , AUDIT*=y compile error
References: <20070731230932.a9459617.akpm@linux-foundation.org>
In-Reply-To: <20070731230932.a9459617.akpm@linux-foundation.org>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


> Changes since 2.6.23-rc1-mm1:
> 
...

>  git-audit-master.patch

...

kernel/auditsc.c: In function 'handle_one':
kernel/auditsc.c:1411: error: 'const struct inode' has no member named 'inotify_watches'
kernel/auditsc.c:1411: error: 'const struct inode' has no member named 'inotify_watches'
kernel/auditsc.c:1411: error: 'const struct inode' has no member named 'inotify_watches'
kernel/auditsc.c: In function 'handle_path':
kernel/auditsc.c:1452: error: 'struct inode' has no member named 'inotify_watches'
kernel/auditsc.c:1452: error: 'struct inode' has no member named 'inotify_watches'
kernel/auditsc.c:1452: error: 'struct inode' has no member named 'inotify_watches'
make[1]: *** [kernel/auditsc.o] Error 1
make: *** [kernel] Error 2
make: *** Waiting for unfinished jobs....

...


Got that with a randconfig ( http://194.231.229.228/MM/randconfig-auto-34 )


Regards,

Gabriel
