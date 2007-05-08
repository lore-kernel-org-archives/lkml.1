Return-Path: <linux-kernel-owner+w=401wt.eu-S967613AbXEHCcw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967613AbXEHCcw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 May 2007 22:32:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966892AbXEHCct
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 May 2007 22:32:49 -0400
Received: from nz-out-0506.google.com ([64.233.162.237]:8889 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966693AbXEHCct (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 May 2007 22:32:49 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=WEyD2l6g2Ro7k72miuWohVpEEqCRhj6kGMJ67ZELpVBcpblQ0Yr5YzJ3NFcVytjghl1+rClGcfwbwQdA8R5e8uQSqVUn3XE51pPd+A0WIesTGDwZPbojGHFcIAhzt0qM4CymQn6IIOAiGVi+FzviIzOLimI3d3WpWwmtbVq92UE=
Message-ID: <a36005b50705071932s6880d732hf228612ad8416bca@mail.gmail.com>
Date: Mon, 7 May 2007 19:32:48 -0700
From: "Ulrich Drepper" <drepper@gmail.com>
To: "Davi Arnaut" <davi@haxent.com.br>
Subject: Re: [PATCH] rfc: threaded epoll_wait thundering herd
Cc: "Davide Libenzi" <davidel@xmailserver.org>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
In-Reply-To: <463FB327.4070906@haxent.com.br>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070504225730.490334000@haxent.com.br>
	 <463BC3CA.6050109@haxent.com.br>
	 <Pine.LNX.4.64.0705051155210.19104@alien.or.mcafeemobile.com>
	 <463CFA37.3020809@haxent.com.br>
	 <a36005b50705071400p5302da05n7d27ec1995b9d4dc@mail.gmail.com>
	 <463F9B68.305@haxent.com.br>
	 <a36005b50705071519k40449ed2p7b9ece22cc19219a@mail.gmail.com>
	 <463FB327.4070906@haxent.com.br>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/7/07, Davi Arnaut <davi@haxent.com.br> wrote:
> Anyway, we could extend epoll to be mmapable...

Welcome to kevent, well, except with a lot more ballast and awkward interfaces.
