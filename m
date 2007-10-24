Return-Path: <linux-kernel-owner+w=401wt.eu-S1758266AbXJXNqa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758266AbXJXNqa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2007 09:46:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757967AbXJXNqW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Oct 2007 09:46:22 -0400
Received: from mail.enyo.de ([212.9.189.167]:1486 "EHLO mail.enyo.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752882AbXJXNqW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2007 09:46:22 -0400
X-Greylist: delayed 1500 seconds by postgrey-1.27 at vger.kernel.org; Wed, 24 Oct 2007 09:46:22 EDT
From: Florian Weimer <fw@deneb.enyo.de>
To: Matthew Wilcox <matthew@wil.cx>
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, Matthew Wilcox <willy@linux.intel.com>
Subject: Re: [PATCH 1/4] stringbuf: A string buffer implementation
References: <1193173966-3550-1-git-send-email-matthew@wil.cx>
Date: Wed, 24 Oct 2007 15:21:06 +0200
In-Reply-To: <1193173966-3550-1-git-send-email-matthew@wil.cx> (Matthew
	Wilcox's message of "Tue, 23 Oct 2007 17:12:43 -0400")
Message-ID: <87sl401we5.fsf@mid.deneb.enyo.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

* Matthew Wilcox:

> +struct stringbuf {
> +	char *s;
> +	int alloc;
> +	int len;
> +};

I think alloc and len should be unsigned (including some return values
in the remaining patch).
