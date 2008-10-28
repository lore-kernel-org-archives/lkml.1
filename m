Return-Path: <linux-kernel-owner+w=401wt.eu-S1754030AbYJ1UUq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754030AbYJ1UUq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2008 16:20:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752462AbYJ1UUh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Oct 2008 16:20:37 -0400
Received: from rv-out-0506.google.com ([209.85.198.231]:15147 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752133AbYJ1UUg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2008 16:20:36 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references:x-google-sender-auth;
        b=M133aYCY5gqiAPr8nakU+Icz+3+h6z1c9OwkBh2gcddjcNZPgXDLvqxX3YtiVTIuIL
         UC9WZWgPxdW2QF8OyhTBXpAT0PTPtlUe3n3B6WZzwvWGvb/KfWhWidnDYXZV4BidIt3Y
         yKRUOlpNJPw2GWFCBJKE0zohbFmoyuoxzIDLE=
Message-ID: <517f3f820810281320l5ed1df3v3717584e4284a43f@mail.gmail.com>
Date: Tue, 28 Oct 2008 15:20:35 -0500
From: "Michael Kerrisk" <mtk.manpages@gmail.com>
To: "Ulrich Drepper" <drepper@redhat.com>
Subject: Re: [PATCH] cleanup paccept
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       linux-api@vger.kernel.org, torvalds@linux-foundation.org
In-Reply-To: <517f3f820810281310y2b02705fs8b402a5ca5117f51@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200810281909.m9SJ9pdj003624@hs20-bc2-1.build.redhat.com>
	 <517f3f820810281310y2b02705fs8b402a5ca5117f51@mail.gmail.com>
X-Google-Sender-Auth: e44f1e5d53fbfc67
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> The actual patch which is in the kernel is different from
>> the patch in the mail: only the signal mask handling has been disabled.
>> This is why this is only a cleanup patch.
>
> And that does not explain to the world at large what this
> to-be-enabled system call does, or why it's needed.

And one further point: what is the userspace interface going to look
like for this system call?

Are we to see a repeat of the unsafe userspace implementation of
pselect() that was present in glibc before the kernel finally added a
pselect() system call?

In other words: is the userspace interface for accept4() going to be
the thinnest of wrappers, or will glibc add an unsafe
paccept()-with-signal-mask in userspace?
