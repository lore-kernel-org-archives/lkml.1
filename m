Return-Path: <linux-kernel-owner+w=401wt.eu-S1030237AbXDQOVQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030237AbXDQOVQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Apr 2007 10:21:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030283AbXDQOVQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Apr 2007 10:21:16 -0400
Received: from ns2.suse.de ([195.135.220.15]:48516 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030237AbXDQOVP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Apr 2007 10:21:15 -0400
To: Pavel Emelianov <xemul@sw.ru>
Cc: Andrew Morton <akpm@osdl.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       devel@openvz.org, Kirill Korotaev <dev@openvz.org>
Subject: Re: [PATCH] Introduce a handy list_first_entry macro
References: <4624AD20.6050009@sw.ru>
From: Andi Kleen <andi@firstfloor.org>
Date: 17 Apr 2007 17:19:12 +0200
In-Reply-To: <4624AD20.6050009@sw.ru>
Message-ID: <p73irbv58r3.fsf@bingen.suse.de>
User-Agent: Gnus/5.09 (Gnus v5.9.0) Emacs/21.3
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Pavel Emelianov <xemul@sw.ru> writes:

> There are many places in the kernel where the construction like
> 
>    foo = list_entry(head->next, struct foo_struct, list);
> 
> are used. 
> The code might look more descriptive and neat if using the macro
> 
>    list_first_entry(head, type, member) \
>              list_entry((head)->next, type, member)

Thanks. I always wanted that too.

-andi
