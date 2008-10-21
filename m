Return-Path: <linux-kernel-owner+w=401wt.eu-S1755480AbYJUUhk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755480AbYJUUhk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2008 16:37:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751764AbYJUUhc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Oct 2008 16:37:32 -0400
Received: from wf-out-1314.google.com ([209.85.200.170]:1228 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750966AbYJUUhb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2008 16:37:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=VWW14W8M9TeXEh6jvsXbF2wsLaKFnWPvPSy7A0Au6ToW6vvU92LJm2MM08fpIJOkyI
         voJMYw9zdY/8OlBZaKS4W8PAmrtzh9iWCNvM7YPXfsYR0vk7l8yTRwtv5js8nWD4hwaj
         DVKjdmsay6D7Ilkd6vR2EIlTF5kq4EVZx5oV8=
Subject: Re: [PATCH] byteorder: remove direct includes of
 linux/byteorder/swab[b].h
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: torvalds@linux-foundation.org, paulmck@us.ibm.com,
       linux-kernel@vger.kernel.org
In-Reply-To: <20081021131534.7c084fdb.akpm@linux-foundation.org>
References: <1224523418.31861.4.camel@brick>
	 <20081021131534.7c084fdb.akpm@linux-foundation.org>
Content-Type: text/plain
Date: Tue, 21 Oct 2008 13:37:27 -0700
Message-Id: <1224621447.5768.3.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2008-10-21 at 13:15 -0700, Andrew Morton wrote:
> On Mon, 20 Oct 2008 10:23:38 -0700
> Harvey Harrison <harvey.harrison@gmail.com> wrote:
> 
> > A consolidated implementation will provide this generically through
> > asm/byteorder, remove direct includes to avoid breakage when the
> > changeover to the new implementation occurs.
> > 
> > Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
> > ---
> > Andrew, this hunk seems to have been lost when you sent it to Linus, it's possible
> > you applied this on top of the -next tree where this file has moved, but the tests
> > tree hasn't been pulled yet.
> > 
> > The rest of the patch went into mainline as 1d8cca44b6a244b7e378546d719041819049a0f9
> > 
> 
> Grump.  It happens sometimes.  People putting stuff into linux-next and
> then not merging it into the next kernel.
> 
> Should this be linux/byteorder.h?  (Which weirdly doesn't include
> asm/byteorder.h).

As the implementations all used to live in asm/byteorder.h before
consolidating, it needs to be asm until all arches convert.  At that
time we can do the flip and let linux/ be directly includable.

Harvey


