Return-Path: <linux-kernel-owner+w=401wt.eu-S1756751AbZBWT1S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756751AbZBWT1S (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Feb 2009 14:27:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754009AbZBWT1G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Feb 2009 14:27:06 -0500
Received: from gw.goop.org ([64.81.55.164]:37759 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753042AbZBWT1F (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Feb 2009 14:27:05 -0500
Message-ID: <49A2F885.8030407@goop.org>
Date: Mon, 23 Feb 2009 11:27:01 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: Nick Piggin <nickpiggin@yahoo.com.au>
CC: Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linux Memory Management List <linux-mm@kvack.org>,
       the arch/x86 maintainers <x86@kernel.org>,
       Arjan van de Ven <arjan@linux.intel.com>
Subject: Re: [PATCH RFC] vm_unmap_aliases: allow callers to inhibit TLB flush
References: <49416494.6040009@goop.org> <200902231514.01965.nickpiggin@yahoo.com.au> <49A25086.30606@goop.org> <200902232013.43054.nickpiggin@yahoo.com.au>
In-Reply-To: <200902232013.43054.nickpiggin@yahoo.com.au>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Nick Piggin wrote:
> Here's a start for you. I think it gets rid of all the dead code and
> data without introducing any actual conditional compilation...
>   

OK, I can get started with this, but it will need to be a runtime 
switch; a Xen kernel running native is just a normal kernel, and I don't 
think we want to disable lazy flushes in that case.

    J
