Return-Path: <linux-kernel-owner+w=401wt.eu-S1760184AbYDRSYZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760184AbYDRSYZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Apr 2008 14:24:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760027AbYDRSYL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Apr 2008 14:24:11 -0400
Received: from fg-out-1718.google.com ([72.14.220.153]:16021 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757392AbYDRSYK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Apr 2008 14:24:10 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=kC5MFFTm3wGZGf9eYSKsyfHjtzZ5qhAuLpFqr7a6wfX+9SX1HggTjL5c9ai7jCIApY9p5UaDv9ISTP7ybBULVoojuIhKT5dr/AcwiuPZ74+ry/G8ko7NCkMCRqanC2FLfKv6JgwXPk8CIOkQ0pYPXl1FCf7Evn7L1N4cWaKhHJg=
Message-ID: <517f3f820804181124o6354444cq696665f38a14ae4f@mail.gmail.com>
Date: Fri, 18 Apr 2008 20:24:08 +0200
From: "Michael Kerrisk" <mtk.manpages@gmail.com>
To: "Rusty Russell" <rusty@rustcorp.com.au>
Subject: Re: [PATCH] Removal of FUTEX_FD (and related code)
Cc: linux-kernel@vger.kernel.org, "Ingo Molnar" <mingo@elte.hu>
In-Reply-To: <200804190207.14598.rusty@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200804190207.14598.rusty@rustcorp.com.au>
X-Google-Sender-Auth: 56b814330b8f06e7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey Rusty,

On 4/18/08, Rusty Russell <rusty@rustcorp.com.au> wrote:
> From: Eric Sesterhenn <snakebyte@gmx.de>
>  Date: Fri, 25 Jan 2008 10:40:46 +0100
>
>  hi,
>
>  since FUTEX_FD was scheduled for removal in June 2007 lets remove it.
>  Google Code search found no users for it and NGPT was abandoned in 2003
>  according to IBM. futex.h is left untouched to make sure the id does
>  not get reassigned. Since queue_me() has no users left it is commented
>  out to avoid a warning, i didnt remove it completely since it is part
>  of the internal api (matching unqueue_me())
[...]

Please CC me on API changes...

Cheers,

Michael
