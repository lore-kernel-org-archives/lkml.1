Return-Path: <linux-kernel-owner+w=401wt.eu-S1754290AbXDSW6J@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754290AbXDSW6J (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Apr 2007 18:58:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754295AbXDSW6I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Apr 2007 18:58:08 -0400
Received: from wx-out-0506.google.com ([66.249.82.236]:13499 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754294AbXDSW6H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Apr 2007 18:58:07 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=m0avFrGOYiT7J4t2Lt2Zt/r+pTEotBKxH98a4fcs2Jnuv3G9+4ngWMYkAGcHGmaSY/5POYQcmfQFvSvf3VDwKvX6goOYazRLydarbpGVvQTCOZWmdHDwbAWEO5BI7zo6lIyHSUJGKgdmuOerccY6oYpfAi40fLPLHPCDlcZ4pjg=
Message-ID: <f2b55d220704191558i6deadc08q6aa07360cadaaccc@mail.gmail.com>
Date: Thu, 19 Apr 2007 15:58:02 -0700
From: "Michael K. Edwards" <medwards.linux@gmail.com>
To: chris@pcburn.com
Subject: Re: GPL-incompatible Module Error Message
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <4627EED5.6020800@pcburn.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <4627EED5.6020800@pcburn.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 4/19/07, Chris Bergeron <chris@pcburn.com> wrote:
> It just seemed like it might be interesting and I couldn't find anything
> to shed light on the error itself in the mailing list logs, and I'm
> curious at what's happening.

What's happening is that some kernel developers don't like Linus's
stance on binary-only drivers and are trying to circumvent the norms
of software copyright law using EXPORT_SYMBOL_GPL.  (Why some people
think that the GPL is magically exempt from Lotus v. Borland, Lexmark
v. Static Control, and their analogues in other jurisdiction is beyond
me -- but then I gave up smoking the FSF's parallel-legal-universe
herb some time ago.)

Just s/EXPORT_SYMBOL_GPL/EXPORT_SYMBOL/ throughout the kernel and
you'll be fine -- at a technical level.  But be prepared, when later
changes break extra-volatile quasi-private in-kernel APIs, to keep
both pieces -- and to be shunned by EXPORT_SYMBOL_GPL partisans.

Cheers (IANAL, TINLA),
- Michael
