Return-Path: <linux-kernel-owner+w=401wt.eu-S1762895AbXHAKqw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762895AbXHAKqw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Aug 2007 06:46:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753531AbXHAKqp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Aug 2007 06:46:45 -0400
Received: from mail-gw2.sa.eol.hu ([212.108.200.109]:53590 "EHLO
	mail-gw2.sa.eol.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752908AbXHAKqo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Aug 2007 06:46:44 -0400
To: andi@firstfloor.org
CC: miklos@szeredi.hu, andi@firstfloor.org, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, akpm@linux-foundation.org,
       torvalds@linux-foundation.org
In-reply-to: <p73643zpjy8.fsf@bingen.suse.de> (message from Andi Kleen on 01
	Aug 2007 13:34:23 +0200)
Subject: Re: [RFC PATCH] type safe allocator
References: <E1IGAAI-0006K6-00@dorka.pomaz.szeredi.hu>
	<p73myxbpm8r.fsf@bingen.suse.de>
	<E1IGAx0-0006TK-00@dorka.pomaz.szeredi.hu> <p73643zpjy8.fsf@bingen.suse.de>
Message-Id: <E1IGBiG-0006fv-00@dorka.pomaz.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Wed, 01 Aug 2007 12:45:56 +0200
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> > 
> > #define k_new(type, flags) ((type *) kmalloc(sizeof(type), flags))
> 
> The cast doesn't make it more safe in any way

I does, since a warning will be issued, if the type of the assigned
pointer doesn't match the requested allocation.

And yes, warnings are _very_ useful in C for enforcing type safety.

Miklos
