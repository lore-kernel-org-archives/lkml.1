Return-Path: <linux-kernel-owner+w=401wt.eu-S1764530AbXHFUlx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764530AbXHFUlx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2007 16:41:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756084AbXHFUlr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Aug 2007 16:41:47 -0400
Received: from mu-out-0910.google.com ([209.85.134.184]:11325 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753771AbXHFUlq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2007 16:41:46 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:content-type:content-transfer-encoding;
        b=RRVveO/Y74xqjniNmcwzT/qmUsQ1wxHSJ2bXtbDw4CQfNlFDVlPJ+RQ+Q6bwLTnL5siu+OrtVcyQxuDqTH5uM+7UN7bQCBJZEPg6pGrw9TL1Mhwd166Ns6uq6bEGYUThB1+s9pf4mYghtZrjtHTAxa0a0MFv9T60boJTKk8llTE=
Message-ID: <46B78758.8090101@googlemail.com>
Date: Mon, 06 Aug 2007 22:40:56 +0200
From: Gabriel C <nix.or.die@googlemail.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070803)
MIME-Version: 1.0
To: Jens Axboe <axboe@kernel.dk>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: block/cfq-iosched.c - control reaches end of non-void function warning
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jens,

I just noticed this warning in one of my build logs :

...

block/cfq-iosched.c: In function 'cfq_async_queue_prio':
block/cfq-iosched.c:1430: warning: control reaches end of non-void function

...

Guessing return 0; is missing there.


Regards,

Gabriel 

