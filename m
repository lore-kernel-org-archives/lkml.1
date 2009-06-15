Return-Path: <linux-kernel-owner+w=401wt.eu-S1762502AbZFOQSA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762502AbZFOQSA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jun 2009 12:18:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751528AbZFOQRx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Jun 2009 12:17:53 -0400
Received: from mail-gx0-f214.google.com ([209.85.217.214]:65405 "EHLO
	mail-gx0-f214.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751083AbZFOQRw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jun 2009 12:17:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=TszuHVSDCOH6LFmp23DBhU9S0kFazr+nP6U/HhrLaCgs8v1QJsmZXq9Q7lNtU7gL+n
         fVkbBAsS+296WIT81KfygrW7m+2cqUCHxDX+n9kw/pahvLIFnUfRqMJi8T3neFLqD7Uy
         OAx9URSy6i8HS0EVjo+50yf61ST/9HiRd89s4=
MIME-Version: 1.0
In-Reply-To: <200906142243.32409.arnd@arndb.de>
References: <1244903447-23579-1-git-send-email-vapier@gentoo.org> 
	<200906132318.19208.arnd@arndb.de> <8bd0f97a0906131725l214007fcpfa90e72b03cad2ac@mail.gmail.com> 
	<200906142243.32409.arnd@arndb.de>
From: Mike Frysinger <vapier.adi@gmail.com>
Date: Mon, 15 Jun 2009 12:17:34 -0400
Message-ID: <8bd0f97a0906150917q159d213ax82cd51dee8ad1a08@mail.gmail.com>
Subject: Re: [PATCH] asm-generic: drop HARDIRQ_BITS definition from hardirq.h
To: Arnd Bergmann <arnd@arndb.de>
Cc: "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org,
       Steven Rostedt <srostedt@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 14, 2009 at 16:43, Arnd Bergmann wrote:
> linux/hardirq.h contains a fallback for HARDIRQ_BITS to 10
> if it's not defined, so it is pointless to define a default
> of 8 in asm/hardirq.h. There does not seem to be a good
> reason why an architecture would want to limit the number
> of hardirqs this way.
>
> Reported-by: Mike Frysinger <vapier@gentoo.org>
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> ---
>  include/asm-generic/hardirq.h |   13 -------------
>  1 files changed, 0 insertions(+), 13 deletions(-)
> On Sunday 14 June 2009, Mike Frysinger wrote:
>
> Mike Frysinger wrote:
>> is there any downsides to using a "too large" value ?  i.e. if my
>> system has less than 256, does it make any difference at all if it's
>> set to 10 ?
>
> None that I know of. I'm queuing this patch in my asm-generic tree now,
> unless Steven or someone else has a better idea.

based on Steven's comments, this patch makes sense to me
Acked-by: Mike Frysinger <vapier@gentoo.org>
-mike
