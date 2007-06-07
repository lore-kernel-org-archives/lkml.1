Return-Path: <linux-kernel-owner+w=401wt.eu-S936489AbXFGVAG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936489AbXFGVAG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2007 17:00:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763493AbXFGU7z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jun 2007 16:59:55 -0400
Received: from ug-out-1314.google.com ([66.249.92.174]:58125 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753245AbXFGU7y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2007 16:59:54 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=A4dNy9Kd7E2XxAlnaHY5uB+nn3LT0gXhKYoGLrpteWCwGfvYDReDirtqIbWqpetQ923d9va1EiPZ6FnMb1eAFjdTeRBWJJtiPYBbek/psb/9r120XZxt8Bj8zIbptI+XmsE5TAwctk++B959TQlAiWznVi4LS/MzL02SrQcpfXM=
Message-ID: <3d8471ca0706071359jfb79d84wbd34fef54d69ba3e@mail.gmail.com>
Date: Thu, 7 Jun 2007 22:59:50 +0200
From: "Guillaume Chazarain" <guichaz@yahoo.fr>
To: "Linus Torvalds" <torvalds@linux-foundation.org>
Subject: Re: [patch 7/8] fdmap v2 - implement sys_socket2
Cc: "Alan Cox" <alan@lxorguk.ukuu.org.uk>,
       "Davide Libenzi" <davidel@xmailserver.org>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Ulrich Drepper" <drepper@redhat.com>, "Ingo Molnar" <mingo@elte.hu>,
       "Eric Dumazet" <dada1@cosmosbay.com>
In-Reply-To: <alpine.LFD.0.98.0706071240150.4205@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <send-serie.davidel@xmailserver.org.4625.1181169040.7>
	 <20070606235906.72439d16@the-village.bc.nu>
	 <alpine.LFD.0.98.0706071240150.4205@woody.linux-foundation.org>
X-Google-Sender-Auth: 4f37c14cae3324d2
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

2007/6/7, Linus Torvalds <torvalds@linux-foundation.org>:

>         syscall_indirect(unsigned long flags, sigset_t *,
>                          int syscall, unsigned long args[6]);

Would that also be the user interface or all the wrappers would
still be implemented by the glibc?

Also, it sounds like a per-thread prctl, fun with syslets though ... ;-)

-- 
Guillaume
