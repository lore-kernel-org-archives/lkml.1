Return-Path: <linux-kernel-owner+w=401wt.eu-S934944AbXFFTGY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934944AbXFFTGY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2007 15:06:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765003AbXFFTGQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jun 2007 15:06:16 -0400
Received: from smtp-out.google.com ([216.239.45.13]:51851 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763284AbXFFTGP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2007 15:06:15 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:message-id:date:from:to:subject:cc:in-reply-to:
	mime-version:content-type:content-transfer-encoding:
	content-disposition:references;
	b=JVuRjBG3UvlI2IDOZYE+xpI3uADGOeBAo/BpRdjl+A7C9KIuk7IYgUfYa7aIZndhe
	lE1pb3jaizwPL353Ud35g==
Message-ID: <65dd6fd50706061206y558e7f90t3740424fae7bdc9c@mail.gmail.com>
Date: Wed, 6 Jun 2007 12:06:05 -0700
From: "Ollie Wild" <aaw@google.com>
To: "Peter Zijlstra" <a.p.zijlstra@chello.nl>
Subject: Re: [PATCH 3/4] mm: move_page_tables{,_up}
Cc: linux-kernel@vger.kernel.org, parisc-linux@lists.parisc-linux.org,
       linux-mm@kvack.org, linux-arch@vger.kernel.org,
       "Andrew Morton" <akpm@osdl.org>, "Ingo Molnar" <mingo@elte.hu>,
       "Andi Kleen" <ak@suse.de>
In-Reply-To: <20070605151203.738393000@chello.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070605150523.786600000@chello.nl>
	 <20070605151203.738393000@chello.nl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 6/5/07, Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:
> Provide functions for moving page tables upwards.

Now that we're initializing the temporary stack location to
STACK_TOP_MAX, do we still need move_page_tables_up() for variable
length argument support?  I originally added it into shift_arg_pages()
to support 32-bit apps exec'ing 64-bit apps when we were using
TASK_SIZE as our temporary location.

Maybe we should decouple this patch from the others and submit it as
an enhancement to support memory defragmentation.

Ollie
