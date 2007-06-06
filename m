Return-Path: <linux-kernel-owner+w=401wt.eu-S934903AbXFFTvQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934903AbXFFTvQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2007 15:51:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765202AbXFFTu7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jun 2007 15:50:59 -0400
Received: from smtp-out.google.com ([216.239.33.17]:45672 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757632AbXFFTu6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2007 15:50:58 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:message-id:date:from:to:subject:cc:in-reply-to:
	mime-version:content-type:content-transfer-encoding:
	content-disposition:references;
	b=Gyz9wK6SJ5MEVGp3JYOjeQPiw4QwpT5Pm4I8zOyFnHfn21ijGmyhfb8iQ7wWDSWAZ
	5ar2UYYhb0fCMQK4l4GMg==
Message-ID: <65dd6fd50706061250l7378ec38gf86c984fe4e00b86@mail.gmail.com>
Date: Wed, 6 Jun 2007 12:50:42 -0700
From: "Ollie Wild" <aaw@google.com>
To: "Peter Zijlstra" <a.p.zijlstra@chello.nl>
Subject: Re: [PATCH 3/4] mm: move_page_tables{,_up}
Cc: linux-kernel@vger.kernel.org, parisc-linux@lists.parisc-linux.org,
       linux-mm@kvack.org, linux-arch@vger.kernel.org,
       "Andrew Morton" <akpm@osdl.org>, "Ingo Molnar" <mingo@elte.hu>,
       "Andi Kleen" <ak@suse.de>
In-Reply-To: <1181157134.5676.28.camel@lappy>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070605150523.786600000@chello.nl>
	 <20070605151203.738393000@chello.nl>
	 <65dd6fd50706061206y558e7f90t3740424fae7bdc9c@mail.gmail.com>
	 <1181157134.5676.28.camel@lappy>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 6/6/07, Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:
> PA-RISC will still need it, right?

Originally, I thought since the PA-RISC stack grows up, we'd want to
place the stack at the bottom of memory and have copy_strings() and
friends work in the opposite direction.  It turns out, though, that
this ends up being way more headache than it's worth, so I just
manually grow the stack down with expand_downwards().

Ollie
