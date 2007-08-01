Return-Path: <linux-kernel-owner+w=401wt.eu-S1763548AbXHAKj5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763548AbXHAKj5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Aug 2007 06:39:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754045AbXHAKju
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Aug 2007 06:39:50 -0400
Received: from mx2.suse.de ([195.135.220.15]:53183 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754334AbXHAKjt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Aug 2007 06:39:49 -0400
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: andi@firstfloor.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       akpm@linux-foundation.org, torvalds@linux-foundation.org
Subject: Re: [RFC PATCH] type safe allocator
References: <E1IGAAI-0006K6-00@dorka.pomaz.szeredi.hu>
	<p73myxbpm8r.fsf@bingen.suse.de>
	<E1IGAx0-0006TK-00@dorka.pomaz.szeredi.hu>
From: Andi Kleen <andi@firstfloor.org>
Date: 01 Aug 2007 13:34:23 +0200
In-Reply-To: <E1IGAx0-0006TK-00@dorka.pomaz.szeredi.hu>
Message-ID: <p73643zpjy8.fsf@bingen.suse.de>
User-Agent: Gnus/5.09 (Gnus v5.9.0) Emacs/21.3
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Miklos Szeredi <miklos@szeredi.hu> writes:
> 
> #define k_new(type, flags) ((type *) kmalloc(sizeof(type), flags))

The cast doesn't make it more safe in any way

(at least as long as you don't care about portability to C++;
the kernel doesn't)

-Andi
