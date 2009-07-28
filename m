Return-Path: <linux-kernel-owner+w=401wt.eu-S1753325AbZG1UVh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753325AbZG1UVh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jul 2009 16:21:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752210AbZG1UVg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Jul 2009 16:21:36 -0400
Received: from pfepa.post.tele.dk ([195.41.46.235]:43329 "EHLO
	pfepa.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751390AbZG1UVf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jul 2009 16:21:35 -0400
Date: Tue, 28 Jul 2009 22:21:35 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Jiri Slaby <jirislaby@gmail.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>, linux-fsdevel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Christoph Hellwig <hch@infradead.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 1/1] UIO: mark uio.h functions __KERNEL__ only
Message-ID: <20090728202135.GA20927@merkur.ravnborg.org>
References: <20090728195431.GA20914@merkur.ravnborg.org> <1248811555-6648-1-git-send-email-jirislaby@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1248811555-6648-1-git-send-email-jirislaby@gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 28, 2009 at 10:05:55PM +0200, Jiri Slaby wrote:
> To avoid userspace build failures such as:
> .../linux/uio.h:37: error: expected ???=???, ???,???, ???;???, ???asm??? or ???__attribute__??? before ???iov_length???
> .../linux/uio.h:47: error: expected declaration specifiers or ???...??? before ???size_t???
> move uio functions inside a __KERNEL__ block.
> 
> Signed-off-by: Jiri Slaby <jirislaby@gmail.com>

Diff is larger but result is better - thanks.

Acked-by: Sam Ravnborg <sam@ravnborg.org>

	Sam
