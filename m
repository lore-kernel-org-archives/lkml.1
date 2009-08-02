Return-Path: <linux-kernel-owner+w=401wt.eu-S1753766AbZHBUfu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753766AbZHBUfu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Aug 2009 16:35:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753476AbZHBUfu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Aug 2009 16:35:50 -0400
Received: from moutng.kundenserver.de ([212.227.17.10]:59512 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753295AbZHBUft (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Aug 2009 16:35:49 -0400
Date: Sun, 2 Aug 2009 13:35:48 -0700 (PDT)
From: Christian Kujau <lists@nerdbynature.de>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
cc: David Rientjes <rientjes@google.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-ext4@vger.kernel.org
Subject: Re: [Bug #13666] WARNING: at mm/page_alloc.c:1743
 __alloc_pages_nodemask
In-Reply-To: <200908022226.52228.rjw@sisk.pl>
Message-ID: <alpine.DEB.2.01.0908021331350.5831@bogon.housecafe.de>
References: <Jya1GruKQpD.A.16.2GObKB@chimera> <alpine.DEB.2.01.0908011427270.5831@bogon.housecafe.de> <alpine.DEB.2.01.0908021314030.5831@bogon.housecafe.de> <200908022226.52228.rjw@sisk.pl>
User-Agent: Alpine 2.01 (DEB 1184 2008-12-16)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Provags-ID: V01U2FsdGVkX1/sFTYWWZ9Cw8JMPRSPAAH0uOB7xv6B2VaGnPf
 5h4lAQOIG8/3fHN4BUtrdYTw0C7Eew9Dsett4LO8RUqJoh/eFT
 588KXuZHIrVBSMgXjO4dw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Rafael,

On Sun, 2 Aug 2009 at 22:26, Rafael J. Wysocki wrote:
> The patches supposed to fix this issue went in right before -rc5 AFAIC.

Sorry, you fell off my Cc list, thanks for catching this. I've seen these 
patches too, but David confirmed:

---------------------------------------------------------------------
> Is this related to the WARNING in #13666?
> I'm pretty sure the kernel already includes the patches you
> mentioned, "git show" said "b592972493c38665efd7d429a01b23fcb21e331a".
> Also, I just pulled again and mm/ was not touched any more.

Your kernel includes the fixes for the __alloc_pages_nodemask() warning
that was reported in http://bugzilla.kernel.org/show_bug.cgi?id=13666. 
---------------------------------------------------------------------

So, it looks like it's not related to #13666.

> Can you try to reproduce with -rc5?

Yes, I'm building it right now (actually, I'm using current -git tree), 
will report back.


Thanks,
Christian.
-- 
BOFH excuse #6:

global warming
