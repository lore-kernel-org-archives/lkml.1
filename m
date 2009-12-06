Return-Path: <linux-kernel-owner+w=401wt.eu-S1757821AbZLFX1j@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757821AbZLFX1j (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Dec 2009 18:27:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757720AbZLFX1i
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Dec 2009 18:27:38 -0500
Received: from smtp-out.google.com ([216.239.33.17]:31544 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757592AbZLFX1i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Dec 2009 18:27:38 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:x-system-of-record;
	b=cR+WrPGTh84YiC3zpLMZtluYMC1A+t6a5u3uY5hyNSpY8NProtV9/sype7l0Bq1nV
	ANbsziRbjDA4odhQ6AlxA==
MIME-Version: 1.0
In-Reply-To: <20091206205041.GA12555@elf.ucw.cz>
References: <20091206205041.GA12555@elf.ucw.cz>
Date: Sun, 6 Dec 2009 15:27:38 -0800
Message-ID: <a55d774e0912061527t5b09b510g1fc458b53a423c04@mail.gmail.com>
Subject: Re: HTC Dream: dream is better name for this machine
From: Brian Swetland <swetland@google.com>
To: Pavel Machek <pavel@ucw.cz>
Cc: "Arve Hj?nnev?g" <arve@android.com>,
       kernel list <linux-kernel@vger.kernel.org>,
       linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
       Daniel Walker <dwalker@codeaurora.org>,
       Iliyan Malchev <malchev@google.com>
Content-Type: text/plain; charset=UTF-8
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Dec 6, 2009 at 12:50 PM, Pavel Machek <pavel@ucw.cz> wrote:
>
> While few people may know HTC Dream by its codename, it is better to
> use name of released hardware in the sources.

I still think that it'd be less pain for everyone to leave it as
trout.  If you go by sales volume, the most known released hardware
name is "Tmobile G1", some people know it as ADP1, and I believe it
has sold under a few other names in other markets, but the software
has, since day one, been trout and changing that just makes it harder
to merge other existing changes where we'd have to deal with renames
as well.  The bootloader identifies it as "trout", and the userspace
software stack's hardware-specific bits refer to trout.

If it really drives everyone crazy, we could do a big rename once it's
all in and working, but right now I just don't see the benefit.

Brian
