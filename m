Return-Path: <linux-kernel-owner+w=401wt.eu-S965292AbXFGAdD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965292AbXFGAdD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2007 20:33:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965236AbXFGAcm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jun 2007 20:32:42 -0400
Received: from smtp-out.google.com ([216.239.45.13]:22452 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755821AbXFGAck (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2007 20:32:40 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:message-id:date:from:to:subject:cc:in-reply-to:
	mime-version:content-type:content-transfer-encoding:
	content-disposition:references;
	b=SReZgeuCq/huoEFPYAEQzxGD33lSbAv4QcHoJRqBJmjoW60qwlxvG5fUd3w6AWm6j
	AW0Ts2ZP+sEywiGTV9YsA==
Message-ID: <6599ad830706061732i1ecb70f3gf0f4c288ba74563d@mail.gmail.com>
Date: Wed, 6 Jun 2007 17:32:33 -0700
From: "Paul Menage" <menage@google.com>
To: "William Lee Irwin III" <wli@holomorphy.com>
Subject: Re: 2.6.22-rc4-mm1
Cc: "Andrew Morton" <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
In-Reply-To: <20070606194329.GO6909@holomorphy.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070606020737.4663d686.akpm@linux-foundation.org>
	 <20070606163053.GM6909@holomorphy.com>
	 <20070606111315.884cf712.akpm@linux-foundation.org>
	 <20070606194329.GO6909@holomorphy.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 6/6/07, William Lee Irwin III <wli@holomorphy.com> wrote:
>
> (1) build for i386 with my .config
> (2) attempt to boot in qemu's i386 system simulator
>
> I'm not seeing the sort of nondeterminism Andy Whitcroft is. It breaks
> every time when I try this.
>

Looks to be lockdep related - it's reproducible for me when I turn on
CONFIG_LOCKDEP and the early crash goes away when I move the
container_init_early() call to after lockdep_init().

Paul
