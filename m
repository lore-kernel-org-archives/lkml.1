Return-Path: <linux-kernel-owner+w=401wt.eu-S1763078AbYCGLyl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763078AbYCGLyl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2008 06:54:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758922AbYCGLyc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Mar 2008 06:54:32 -0500
Received: from py-out-1112.google.com ([64.233.166.177]:32933 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758520AbYCGLyb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2008 06:54:31 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=htXaezW6b7a2kY2LRY1l1zNPqDreGohPCwgvL2ImQLAOS1hmJFOqpnBVN3xJjK5oodG5aW8xtZmuyNj45l9zW5hSCqBdiAnywl97Arx7qmGAOzeqjs6XEamNxgjF/Q1TQM/jsGe1qyvg5ERwu+mFdvk99QOnwRWDeC7/0BxAjtE=
Message-ID: <87a5b0800803070354x391ff718u3af9664804526da1@mail.gmail.com>
Date: Fri, 7 Mar 2008 11:54:28 +0000
From: "Will Newton" <will.newton@gmail.com>
To: "Jeongdo Son" <sohn9086@gmail.com>
Subject: Re: [BUG REPORT] smc911x: Auto negotiation NOT supported
Cc: LKML <linux-kernel@vger.kernel.org>, Linux-SH <linux-sh@vger.kernel.org>
In-Reply-To: <59fd4ce80803062200n203e5cd7o152be120adbdb717@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <59fd4ce80803062200n203e5cd7o152be120adbdb717@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 7, 2008 at 6:00 AM, Jeongdo Son <sohn9086@gmail.com> wrote:

>  The problem is that only the first ifup after cold boot succeed.
>  Here is the instruction how to reproduce the symptom.
>  (smc911x is recognized as eth0 on the board.)
>  1. boot up the board, and login.
>  2. ifup eth0  (after doing this, ping works)
>  3. ifdown eth0
>  4. ifup eth0 ("Auto negotiation NOT supported" printed, and ping doesn't works)
>  Please refer to the bottom of this mail.

Are you getting interrupts from the chip? Sounds like it could be you
have missed and interrupt somewhere - check where your interrupt
polarities and where you are acking/clearing them down.
