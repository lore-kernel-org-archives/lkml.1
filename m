Return-Path: <linux-kernel-owner+w=401wt.eu-S1753864AbZFUNOX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753864AbZFUNOX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Jun 2009 09:14:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751323AbZFUNOQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 21 Jun 2009 09:14:16 -0400
Received: from mail-gx0-f214.google.com ([209.85.217.214]:45805 "EHLO
	mail-gx0-f214.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751315AbZFUNOP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Jun 2009 09:14:15 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=xBx3Ew5LK/sibcgXAdbvls1Durr90nncZtpifly8zhV0qZOxnBGwfj771ofe5PKP45
         LZ55ugHOV5hWPzm2YRinO1zMx6ZuRqNvWBTa24QZ7auFtE7ByPj/vQaIZGLpLBv4KcdQ
         oIZuR8dfxpBUbN9meQTPJGy6OL7x79tA2gaWE=
MIME-Version: 1.0
In-Reply-To: <20090621065844.GC1810@ucw.cz>
References: <412e6f7f0906131829y6e0abb00j85e221f92ab439d2@mail.gmail.com>
	 <20090621065844.GC1810@ucw.cz>
Date: Sun, 21 Jun 2009 21:14:17 +0800
Message-ID: <412e6f7f0906210614gdd1c32di2762542df8bc7f20@mail.gmail.com>
Subject: Re: memconsole: a virtual console to record the Oops message for 
	debugging purpose.
From: Changli Gao <xiaosuo@gmail.com>
To: Pavel Machek <pavel@ucw.cz>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 21, 2009 at 2:58 PM, Pavel Machek<pavel@ucw.cz> wrote:
>
> ...and test it on real hw...?
>                                                                Pavel
>

Bad news, it doesn't work on real computer, so the patch isn't necessary now.

I'm trying another way: building a initrd.gz, which doesn't nothing
except of dumping the demsg into a non-volatile storage device: such
as a file or a partiton of a hard disk, and it does work on real
computer. When it is stable, I'll share the code with you all.


-- 
Regards，
Changli Gao(xiaosuo@gmail.com)
