Return-Path: <linux-kernel-owner+w=401wt.eu-S1756894AbXKWSir@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756894AbXKWSir (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Nov 2007 13:38:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752861AbXKWSij
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Nov 2007 13:38:39 -0500
Received: from wr-out-0506.google.com ([64.233.184.227]:14489 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752520AbXKWSii (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Nov 2007 13:38:38 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=JC58vopLeMYTQ1WsFasbT9DiC94xxLcmEGnFXfcDBrcI4VkUQo1zLIt2c/w1DhSFfYz5M00SVGKTYFDRnJHb98zTTS15V3CepznWtWa7lqmBnuECUyMBdOAvpSXz0PlHEhQDzByQdj/6IAaIvZ79o3se7W28xfhxmaZ9qHQJkFc=
Message-ID: <a36005b50711231038j48325a41o26d1749ee89ab64d@mail.gmail.com>
Date: Fri, 23 Nov 2007 10:38:36 -0800
From: "Ulrich Drepper" <drepper@gmail.com>
To: "Davide Libenzi" <davidel@xmailserver.org>
Subject: Re: Where is the new timerfd?
Cc: "Andrew Morton" <akpm@linux-foundation.org>,
       "Michael Kerrisk" <mtk.manpages@googlemail.com>,
       lkml <linux-kernel@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.64.0711230928590.15603@alien.or.mcafeemobile.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <cfd18e0f0711220324l533d9048yf05c399019764b62@mail.gmail.com>
	 <Pine.LNX.4.64.0711220933330.7256@alien.or.mcafeemobile.com>
	 <cfd18e0f0711221048k538d05abk8e4303d5f90a6e1b@mail.gmail.com>
	 <Pine.LNX.4.64.0711221145410.7431@alien.or.mcafeemobile.com>
	 <20071122162430.48f55995.akpm@linux-foundation.org>
	 <Pine.LNX.4.64.0711221634510.7431@alien.or.mcafeemobile.com>
	 <20071122173437.e74890a8.akpm@linux-foundation.org>
	 <cfd18e0f0711230439m1d72abdle4d5050b0bd935a1@mail.gmail.com>
	 <20071123091254.45f4193d.akpm@linux-foundation.org>
	 <Pine.LNX.4.64.0711230928590.15603@alien.or.mcafeemobile.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Nov 23, 2007 9:29 AM, Davide Libenzi <davidel@xmailserver.org> wrote:
> Yes, it's disabled, and yes, I'll repost today ...

I haven't seen the patch and don't feel like searching.  So I say it
here: please mak sure you add a flags parameter to the system call
itself (instead of adding it on as for eventfd and signalfd).  We need
to be able to use O_CLOEXEC some way or another.
