Return-Path: <linux-kernel-owner+w=401wt.eu-S1757059AbZDFWxa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757059AbZDFWxa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Apr 2009 18:53:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754903AbZDFWxU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Apr 2009 18:53:20 -0400
Received: from rv-out-0506.google.com ([209.85.198.233]:25339 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754424AbZDFWxU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Apr 2009 18:53:20 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:references:in-reply-to:subject:date:message-id
         :mime-version:content-type:content-transfer-encoding:x-mailer
         :thread-index:content-language;
        b=ktYSnBj3frUuwH0GYjVlRAC1EPcR7urk1HV0FunSxIYpF2g4Zt0v7C+Y1GwhV3qcjN
         Cw+shvA++oYi10RH28tD7074nZe2kaqfCMV90L3t40nrIxaV2bb2H4y5yK8ShF0Ow3TU
         GSy/SZquTMgeYPdHiBMGhT3fM4OicMiKLhOjo=
From: "Hua Zhong" <hzhong@gmail.com>
To: "'Ray Lee'" <ray-lk@madrabbit.org>
Cc: "'Theodore Tso'" <tytso@mit.edu>,
       "'Linus Torvalds'" <torvalds@linux-foundation.org>,
       "'Jens Axboe'" <jens.axboe@oracle.com>,
       "'Linux Kernel Mailing List'" <linux-kernel@vger.kernel.org>
References: <1239022088-29002-1-git-send-email-jens.axboe@oracle.com> 	<20090406151054.GD5178@kernel.dk> <alpine.LFD.2.00.0904060840080.3863@localhost.localdomain> 	<20090406183157.GD7376@mit.edu> <alpine.LFD.2.00.0904061255160.4134@localhost.localdomain> 	<002501c9b6f3$f85b4910$e911db30$@com> <20090406211931.GB8586@mit.edu> 	<003001c9b6ff$a9259ce0$fb70d6a0$@com> <2c0942db0904061504l6504934bi446f7425fcd38470@mail.gmail.com> 	<003401c9b706$9c4c1b50$d4e451f0$@com> <2c0942db0904061548x2d34eff7g9b5332826509da53@mail.gmail.com>
In-Reply-To: <2c0942db0904061548x2d34eff7g9b5332826509da53@mail.gmail.com>
Subject: RE: [PATCH 0/8][RFC] IO latency/throughput fixes
Date: Mon, 6 Apr 2009 15:52:50 -0700
Message-ID: <003501c9b70a$6a809f20$3f81dd60$@com>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-Index: Acm3CcVUo9wEBqCPQzu6yDr4nYlWgQAAE42A
Content-Language: en-us
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Security on an embedded device starts with controlling physical
> access. If they have access to the storage media all bets are off,
> whether it's data=ordered or not. (Access to the storage media is
> really what we're talking about here -- medical data, for example,
> hitting the platter before the metadata updates that then make that
> data unaccessible to other userspace processes.)
> 
> Because *if* they have access to the media, they can replace any
> running code on that box, and your security is worthless.
> 
> So no, I don't see how that's a valid argument.

The problem with security has nothing to do with embedded. It's 
that when you commit metadata first and crash before you write 
the data, then you get to see random blocks which might contain 
sensitive information from other users.

Hua


