Return-Path: <linux-kernel-owner+w=401wt.eu-S1423097AbXBVAHg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423097AbXBVAHg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Feb 2007 19:07:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423268AbXBVAHg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Feb 2007 19:07:36 -0500
Received: from smtp001.mail.ukl.yahoo.com ([217.12.11.32]:29615 "HELO
	smtp001.mail.ukl.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1423097AbXBVAHf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Feb 2007 19:07:35 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.it;
  h=Received:X-YMail-OSG:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=hSRs7b9I40/w+cSKWJyju75McwmHUzdG0hNneS5NWlYfWV4Q/PQlUcjcMFwNi4RGczraxPAEgjmq6cWVNqKjEUwF1zYFshK8WOkkr7w0HsM3T6SI9kPocUTggL6/Y+HiR/KCm4vAvkXWUiLs5pgC2NlzLwNVkXzCXuobUlKH5rI=  ;
X-YMail-OSG: RsJzpFUVM1kUgr7uIQw7cqI_cvVWtnTfqhu_p9DbFd_OTqB_uTVp7_ksVYvDway027LCROAVsGIY56O6jMiRnI.w.p3m775G9vAPVFEF1zvNDsYaozuItdfp2aawGFno1wz0ZcHXSB84
From: Blaisorblade <blaisorblade@yahoo.it>
To: user-mode-linux-devel@lists.sourceforge.net
Subject: Re: [uml-devel] [PATCH 2/3] UML - x86_64 thread fixes
Date: Thu, 22 Feb 2007 01:07:30 +0100
User-Agent: KMail/1.9.5
Cc: Jeff Dike <jdike@addtoit.com>, akpm@osdl.org, wstearns@pobox.com,
       linux-kernel@vger.kernel.org
References: <200702082157.l18LvVFB007602@ccure.user-mode-linux.org>
In-Reply-To: <200702082157.l18LvVFB007602@ccure.user-mode-linux.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200702220107.30766.blaisorblade@yahoo.it>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 08 February 2007 22:57, Jeff Dike wrote:
> x86_64 needs some TLS fixes.  What was missing was remembering the
> child thread id during clone and stuffing it into the child during
> each context switch.
>
> The %fs value is stored separately in the thread structure since the
> host controls what effect it has on the actual register file.  The
> host also needs to store it in its own thread struct, so we need the
> value kept outside the register file.
Is there any reason for avoiding this treatment to %gs, apart that TLS code 
usually does not need it, even if the API allows for it to exist? I _do_ 
believe this patch fixes bug which can be tested (not verified everything), 
even if I wonder why you didn't look at the patch I sent to you time ago (I 
hadn't finished it, in truth, but there was most stuff - it had problems I 
couldn't debug at that time).
-- 
Inform me of my mistakes, so I can add them to my list!
Paolo Giarrusso, aka Blaisorblade
http://www.user-mode-linux.org/~blaisorblade
Chiacchiera con i tuoi amici in tempo reale! 
 http://it.yahoo.com/mail_it/foot/*http://it.messenger.yahoo.com 
