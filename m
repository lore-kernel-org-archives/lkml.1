Return-Path: <linux-kernel-owner+w=401wt.eu-S933787AbXHJMhN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933787AbXHJMhN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Aug 2007 08:37:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757771AbXHJMg6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Aug 2007 08:36:58 -0400
Received: from nf-out-0910.google.com ([64.233.182.186]:27455 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756806AbXHJMg5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Aug 2007 08:36:57 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:content-type:content-transfer-encoding;
        b=MjIZe4iWhbJRQwVTo5coghfI+w80UdPQknbP61kz0st5699JELw+fe8IIME/SoaKembKg3uORkUBcC0ZAPsUexKPhAaYQRJYMPECIVNm5CEYua9ihoXcVorFsVES+Vz2aVwskZE0/bGUNTEtny2LMVA5tXfD2be1+eVgZC2KlCc=
Message-ID: <46BC5B75.80102@googlemail.com>
Date: Fri, 10 Aug 2007 14:35:01 +0200
From: Gabriel C <nix.or.die@googlemail.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070803)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
Subject: Re: 2.6.23-rc2-mm2
References: <20070809224254.11f42716.akpm@linux-foundation.org> <46BC3CB1.2090503@googlemail.com>
In-Reply-To: <46BC3CB1.2090503@googlemail.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Some new warnings here :

...

In file included from include/linux/blkdev.h:17,
                 from kernel/sched.c:45:
include/linux/bsg.h:67: warning: 'struct request_queue' declared inside parameter list
include/linux/bsg.h:67: warning: its scope is only this definition or declaration, which is probably not what you want
include/linux/bsg.h:71: warning: 'struct request_queue' declared inside parameter list

...

In file included from include/linux/blkdev.h:17,
                 from mm/filemap.c:29:
include/linux/bsg.h:67: warning: 'struct request_queue' declared inside parameter list
include/linux/bsg.h:67: warning: its scope is only this definition or declaration, which is probably not what you want
include/linux/bsg.h:71: warning: 'struct request_queue' declared inside parameter list

...

Some more of these , all from bsg.h:{67,71}

config there :

http://194.231.229.228/kernel/mm/2.6.23-rc2-mm2/randconfig-auto-5







