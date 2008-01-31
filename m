Return-Path: <linux-kernel-owner+w=401wt.eu-S1759373AbYAaAkc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759373AbYAaAkc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2008 19:40:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754740AbYAaAkT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jan 2008 19:40:19 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:37031 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753863AbYAaAkQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2008 19:40:16 -0500
Date: Wed, 30 Jan 2008 16:39:27 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: a.p.zijlstra@chello.nl, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [patch 6/6] mm: bdi: allow setting a maximum for the bdi dirty
 limit
Message-Id: <20080130163927.760e94cc.akpm@linux-foundation.org>
In-Reply-To: <20080129154954.275142755@szeredi.hu>
References: <20080129154900.145303789@szeredi.hu>
	<20080129154954.275142755@szeredi.hu>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 29 Jan 2008 16:49:06 +0100
Miklos Szeredi <miklos@szeredi.hu> wrote:

> Add "max_ratio" to /sys/class/bdi.  This indicates the maximum
> percentage of the global dirty threshold allocated to this bdi.

Maybe I'm having a stupid day, but I don't understand the semantics of this
min and max at all.  I've read the code, and I've read the comments (well,
I've hunted for some) and I've read the docs.

I really don't know how anyone could use this in its current state without
doing a lot of code-reading and complex experimentation.  All of which
would be unneeded if this tunable was properly documented.

So.  Please provide adequate documentation for this tunable.  I'd suggest
that it be pitched at the level of a reasonably competent system operator. 
It should help them understand why the tunable exists, why they might
choose to alter it, and what effects they can expect to see.  Hopefully a
reaonably competent kernel developer can then understand it too.

