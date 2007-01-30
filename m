Return-Path: <linux-kernel-owner+w=401wt.eu-S1751651AbXA3TQ2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751651AbXA3TQ2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jan 2007 14:16:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751669AbXA3TQ2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jan 2007 14:16:28 -0500
Received: from nf-out-0910.google.com ([64.233.182.187]:2824 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751649AbXA3TQ1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jan 2007 14:16:27 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:subject:from:to:cc:in-reply-to:references:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=gpbwD4Epe6hAxSyvhyb/itwwM8zxidsqgslu6SEBtOU9K/xky/5KN7NR2urCmWS2+O2V84xmsqHF/mFIpnYMaKkfAuG2dkJngmARu4fd5oyCQNM/2pyY4ic3eEF+UOgiRT3Tujy98DP+aaidkAjqX4tLLMI02F9KlxjPtUsnrn0=
Subject: Re: [PATCH] EFI x86: pass firmware call parameters on the stack
From: =?ISO-8859-1?Q?Fr=E9d=E9ric?= Riss <frederic.riss@gmail.com>
To: Andrew Morton <akpm@osdl.org>
Cc: Matt Domsch <Matt_Domsch@dell.com>, linux-kernel@vger.kernel.org,
       artiom.myaskouvskey@intel.com, bjorn.helgaas@hp.com,
       Linus Torvalds <torvalds@linux-foundation.org>
In-Reply-To: <20070130111058.db191e07.akpm@osdl.org>
References: <1170183678.21603.73.camel@funkylaptop>
	 <20070130111058.db191e07.akpm@osdl.org>
Content-Type: text/plain; charset=utf-8
Date: Tue, 30 Jan 2007 20:16:22 +0100
Message-Id: <1170184582.21603.76.camel@funkylaptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.1 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Le mardi 30 janvier 2007 à 11:10 -0800, Andrew Morton a écrit :
> > This patch fixes the issue for x86, but the file is also used by IA64. I
> > would have used asmlinkage to force arguments on the stack, but it has a
> > special meaning on IA64, thus I used a raw regparm(0) GCC attribute.
> > This attribute is documented only for x86, I hope it has no side effect
> > on other archs.
> 
> hm, this sounds like a fairly serious problem.  Has this been runtime
> tested on ia64 and x86_64>

Not by me, the only EFI box I've access to is my Mac Mini.

Fred.

