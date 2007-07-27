Return-Path: <linux-kernel-owner+w=401wt.eu-S935439AbXG0KTk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935439AbXG0KTk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jul 2007 06:19:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752641AbXG0KTc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Jul 2007 06:19:32 -0400
Received: from sicnat3.emn.fr ([193.54.76.194]:43652 "EHLO ron.emn.fr"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752612AbXG0KTb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jul 2007 06:19:31 -0400
From: Yoann Padioleau <padator@wanadoo.fr>
To: David Howells <dhowells@redhat.com>
Cc: Yoann Padioleau <padator@wanadoo.fr>, kernel-janitors@vger.kernel.org,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 06/68] 0 -> NULL, for arch/frv
References: <200707270944.LAA17167@ifs.emn.fr> <22618.1185531297@redhat.com>
Date: Fri, 27 Jul 2007 12:18:46 +0200
In-Reply-To: <22618.1185531297@redhat.com> (David Howells's message of "Fri,
	27 Jul 2007 11:14:57 +0100")
Message-ID: <87lkd29mk9.fsf@wanadoo.fr>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

David Howells <dhowells@redhat.com> writes:

> Yoann Padioleau <padator@wanadoo.fr> wrote:
>
>> When comparing a pointer, it's clearer to compare it to NULL than to 0.
>
> Can you make them of style:
>
> 	if (!x)

Yes I can. I can make another semantic patch later to do that
transformation. But some people may prefer (x == NULL) to (!x)
so I don't know. I think that transformation 
some 0 to NULL is less controversial.


>
> instead?
>
> Thanks,
> David

