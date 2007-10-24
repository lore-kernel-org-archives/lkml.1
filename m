Return-Path: <linux-kernel-owner+w=401wt.eu-S1763604AbXJXQv4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763604AbXJXQv4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2007 12:51:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761808AbXJXQcd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Oct 2007 12:32:33 -0400
Received: from smtp-out.google.com ([216.239.45.13]:36554 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761793AbXJXQcc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2007 12:32:32 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:message-id:date:from:to:subject:cc:in-reply-to:
	mime-version:content-type:content-transfer-encoding:
	content-disposition:references;
	b=B17+oJIPUnh1yGQ29jvgLRJiqaYQOeS4M7dn73w+wnBKUsHweZ7g8DQN80Oesl1IF
	ESA0B06KfYip65/RUGK+g==
Message-ID: <6599ad830710240932s57656f04y2d753453ce590707@mail.gmail.com>
Date: Wed, 24 Oct 2007 09:32:26 -0700
From: "Paul Menage" <menage@google.com>
To: "Adrian Bunk" <bunk@kernel.org>
Subject: Re: [2.6 patch] kernel/cgroup.c: make 2 functions static
Cc: "Paul Jackson" <pj@sgi.com>, linux-kernel@vger.kernel.org
In-Reply-To: <20071024162339.GT30533@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20071024162339.GT30533@stusta.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/24/07, Adrian Bunk <bunk@kernel.org> wrote:
> cgroup_is_releasable() and notify_on_release() should be static,
> not global inline.
>

They seem like they could be usefully static inline - or will the
compiler inline them anyway since they're simple enough?

Paul
