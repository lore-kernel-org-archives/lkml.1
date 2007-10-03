Return-Path: <linux-kernel-owner+w=401wt.eu-S1756086AbXJCHkL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756086AbXJCHkL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Oct 2007 03:40:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752750AbXJCHj7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Oct 2007 03:39:59 -0400
Received: from namei.org ([69.55.235.186]:35444 "EHLO us.intercode.com.au"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752686AbXJCHj6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Oct 2007 03:39:58 -0400
Date: Wed, 3 Oct 2007 00:39:34 -0700 (PDT)
From: James Morris <jmorris@namei.org>
X-X-Sender: jmorris@us.intercode.com.au
To: Kentaro Takeda <takedakn@nttdata.co.jp>
cc: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
       chrisw@sous-sol.org
Subject: Re: [TOMOYO 03/15](repost) Memory and pathname management functions.
In-Reply-To: <4701F3AB.5000807@nttdata.co.jp>
Message-ID: <Xine.LNX.4.64.0710030033350.1422@us.intercode.com.au>
References: <4701F285.5000206@nttdata.co.jp> <4701F3AB.5000807@nttdata.co.jp>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2 Oct 2007, Kentaro Takeda wrote:

> +/**
> + * tmy_alloc - allocate memory for temporary purpose.
> + * @size: requested size in bytes.
> + *
> + * Returns '\0'-initialized memory region on success.
> + * Returns NULL on failure.
> + *
> + * This function allocates memory for keeping ACL entries.
> + * The caller has to call tmy_free() the returned pointer
> + * when memory is no longer needed.
> + */

Would you please explain why you need another level of memory allocation?

What does it do apart from let you check for memory leaks?

- James
-- 
James Morris
<jmorris@namei.org>
