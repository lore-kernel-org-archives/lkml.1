Return-Path: <linux-kernel-owner+w=401wt.eu-S1754859AbXJZBKh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754859AbXJZBKh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2007 21:10:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750816AbXJZBKa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Oct 2007 21:10:30 -0400
Received: from smtp-out.google.com ([216.239.45.13]:24166 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750701AbXJZBK3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2007 21:10:29 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:message-id:date:from:to:subject:cc:in-reply-to:
	mime-version:content-type:content-transfer-encoding:
	content-disposition:references;
	b=XBE3DnqC4SUsVcpfvbWpRorTItOju7L50KF8FbzfukqZxa/I9Ntt64Ma1QlzQC753
	XK0aiaeFi2+xVOxikO5FQ==
Message-ID: <6599ad830710251810r6bb1e390nf3612031af8b6767@mail.gmail.com>
Date: Thu, 25 Oct 2007 18:10:24 -0700
From: "Paul Menage" <menage@google.com>
To: "Paul Jackson" <pj@sgi.com>
Subject: Re: [2.6 patch] kernel/cgroup.c: remove dead code
Cc: bunk@kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <20071024103411.dfd3ae04.pj@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20071024162534.GZ30533@stusta.de>
	 <6599ad830710240930r6649dec0q21b8c00f7d8a796a@mail.gmail.com>
	 <20071024103411.dfd3ae04.pj@sgi.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/24/07, Paul Jackson <pj@sgi.com> wrote:
> Paul M wrote:
> > I think I'd rather not make this change - if we later changed the size
> > of release_agent_path[] this could silently fail. Can we get around
> > the coverity checker somehow?
>
> Perhaps we can simplify this check then, to:
>
>   BUG_ON(sizeof(cgrp->root->release_agent_path) < PATH_MAX));
>
> Less runtime code.

Sounds reasonable to me. Is there any kind of compile-time assert
macro in the kernel?

Paul
