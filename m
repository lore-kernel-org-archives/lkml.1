Return-Path: <linux-kernel-owner+w=401wt.eu-S1753161AbXLDTBB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753161AbXLDTBB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Dec 2007 14:01:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751610AbXLDTAy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Dec 2007 14:00:54 -0500
Received: from nf-out-0910.google.com ([64.233.182.188]:52317 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751552AbXLDTAx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Dec 2007 14:00:53 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:content-type:content-transfer-encoding;
        b=FMCFqNwqneQgVhSrjdp1uiynrf/b7Sfn3cb/QvI/RuPrlTLMQnrYikX9y0d1z8YpOYtyEAUO5slfXBgYkcRJSBIwsDLpGjXWXSD3FsIPJ10IdbUqDPPtur0udczC3f+EUZQsaFa+rq8gs9qu8Qr7x7k6VBlC6S6v/YfB5fNl4w8=
Message-ID: <4755A457.5080405@gmail.com>
Date: Tue, 04 Dec 2007 20:02:47 +0100
From: Jarek Poplawski <jarkao2@gmail.com>
User-Agent: Icedove 1.5.0.14pre (X11/20071020)
MIME-Version: 1.0
To: Alan Stern <stern@rowland.harvard.edu>
CC: Jarek Poplawski <jarkao2@o2.pl>, Ingo Molnar <mingo@elte.hu>,
       Linux-pm mailing list <linux-pm@lists.linux-foundation.org>,
       Kernel development list <linux-kernel@vger.kernel.org>,
       Peter Zijlstra <peterz@infradead.org>
Subject: Re: Need lockdep help
References: <Pine.LNX.4.44L0.0712041000540.4321-100000@iolanthe.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.0712041000540.4321-100000@iolanthe.rowland.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Stern wrote, On 12/04/2007 04:17 PM:
...

> Furthermore, in this case deadlock isn't really impossible -- it could 
> occur if there were a bug somewhere else in the kernel.  So lockdep was 
> correct to warn that deadlock might occur.


Alan, if the scenario was like you described at the beginning, there was
no deadlock possible, unless some errors in the notifier. These #1-#3
threads were only helpful to guess what lockdep could 'think', but I
guess notifier doesn't use 2 rivaling threads for a wake, so, lockdep
probably needed additional information. And you really can't consider
any hypothetical kernel bugs here because then each lock is vulnerable.

Regards,
Jarek P.
