Return-Path: <linux-kernel-owner+w=401wt.eu-S1765632AbYBMILk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765632AbYBMILk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2008 03:11:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756569AbYBMILa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Feb 2008 03:11:30 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:38479 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756573AbYBMIL2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2008 03:11:28 -0500
Date: Wed, 13 Feb 2008 00:09:53 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: "Ahmed S. Darwish" <darwish.07@gmail.com>
Cc: Joerg Platte <jplatte@naasa.net>, linux-kernel@vger.kernel.org,
       casey@schaufler-ca.com
Subject: Re: [PATCH - BUGFIX] Smack: Check for 'struct socket' with NULL sk
Message-Id: <20080213000953.dd782352.akpm@linux-foundation.org>
In-Reply-To: <20080211232347.GA3635@ubuntu>
References: <200802111926.03067.jplatte@naasa.net>
	<20080211232347.GA3635@ubuntu>
X-Mailer: Sylpheed 2.4.7 (GTK+ 2.12.1; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 12 Feb 2008 01:23:47 +0200 "Ahmed S. Darwish" <darwish.07@gmail.com> wrote:

> +	BUG_ON(sk == NULL);
> +	ssp = sk->sk_security;

I'll remove the BUG_ON - the oops on the next line will provide us with just the
same information.

Thanks for the fix.
