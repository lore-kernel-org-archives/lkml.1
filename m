Return-Path: <linux-kernel-owner+w=401wt.eu-S1762788AbXJDQKs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762788AbXJDQKs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Oct 2007 12:10:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762224AbXJDQKc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Oct 2007 12:10:32 -0400
Received: from smtp-out.google.com ([216.239.45.13]:13971 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760117AbXJDQK3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Oct 2007 12:10:29 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:message-id:date:from:to:subject:cc:in-reply-to:
	mime-version:content-type:content-transfer-encoding:
	content-disposition:references;
	b=gGu1UYblDEm5bXnGAiHeFlS3/p6tMFtMEMJu6cxriClfqKmOrUW06C93X8Up5g0VL
	bAY/nlnC2kOd7KGAgi1NQ==
Message-ID: <6599ad830710040910u3696df8p3c0448555cac23e@mail.gmail.com>
Date: Thu, 4 Oct 2007 09:10:02 -0700
From: "Paul Menage" <menage@google.com>
To: "Hugh Dickins" <hugh@veritas.com>
Subject: Re: Memory controller merge (was Re: -mm merge plans for 2.6.24)
Cc: "Balbir Singh" <balbir@linux.vnet.ibm.com>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Pavel Emelianov" <xemul@openvz.org>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org
In-Reply-To: <Pine.LNX.4.64.0710021604260.4916@blonde.wat.veritas.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20071001142222.fcaa8d57.akpm@linux-foundation.org>
	 <4701C737.8070906@linux.vnet.ibm.com>
	 <Pine.LNX.4.64.0710021604260.4916@blonde.wat.veritas.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/2/07, Hugh Dickins <hugh@veritas.com> wrote:
>
> I accept that full swap control is something you're intending to add
> incrementally later; but the current state doesn't make sense to me.

One comment on swap - ideally it should be a separate subsystem from
the memory controller. That way people who are using cpusets to
provide memory isolation (rather than using the page-based memory
controller) can also get swap isolation.

Paul
