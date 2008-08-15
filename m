Return-Path: <linux-kernel-owner+w=401wt.eu-S1760688AbYHORYU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760688AbYHORYU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Aug 2008 13:24:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753422AbYHORYL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Aug 2008 13:24:11 -0400
Received: from mail-gx0-f16.google.com ([209.85.217.16]:50039 "EHLO
	mail-gx0-f16.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753137AbYHORYK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Aug 2008 13:24:10 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=MfUrcC87ECbHiZocI0mgbJjOG0fzaw9RLudHUCMqGyOLeB+0IfTyJ2wnfH1zhwccp8
         AgvTCq6l8JplXNBRFyiNbypV5bvmJtzpOMA+SXSWM+RnMyqlpZMTogsNNXr1qlSnBpgy
         ecQMUq9EVJjVCvaNpOw9CA/T7wEBAmLRVkbgA=
Message-ID: <a36005b50808151023s7baffae5w8e163046209ce9dc@mail.gmail.com>
Date: Fri, 15 Aug 2008 10:23:49 -0700
From: "Ulrich Drepper" <drepper@gmail.com>
To: "Ingo Molnar" <mingo@elte.hu>
Subject: Re: pthread_create() slow for many threads; also time to revisit 64b context switch optimization?
Cc: "Jamie Lokier" <jamie@shareable.org>,
       "Arjan van de Ven" <arjan@infradead.org>, akpm@linux-foundation.org,
       hugh@veritas.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
       briangrant@google.com, cgd@google.com, mbligh@google.com,
       "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Thomas Gleixner" <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>
In-Reply-To: <20080815171913.GB23600@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <48A2EE07.3040003@redhat.com> <48A2F157.7000303@redhat.com>
	 <20080813151007.GA8780@elte.hu> <48A2FC17.9070302@redhat.com>
	 <20080813154043.GA11886@elte.hu> <48A303EE.8070002@redhat.com>
	 <20080813160218.GB18037@elte.hu> <20080815155457.GA5210@shareable.org>
	 <48A5B943.1010607@gmail.com> <20080815171913.GB23600@elte.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 15, 2008 at 10:19 AM, Ingo Molnar <mingo@elte.hu> wrote:
> ( also, just to make sure: all Linux kernel versions will ignore such
>  extra flags, so you can just update glibc to use this flag
>  unconditionally, correct? )

As soon as the patch hits Linus' tree I can change the code.
