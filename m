Return-Path: <linux-kernel-owner+w=401wt.eu-S1753797AbZI0KW7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753797AbZI0KW7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Sep 2009 06:22:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753784AbZI0KW6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Sep 2009 06:22:58 -0400
Received: from [195.41.46.236] ([195.41.46.236]:50366 "EHLO pfepb.post.tele.dk"
	rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753781AbZI0KW6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Sep 2009 06:22:58 -0400
Date: Sun, 27 Sep 2009 12:22:56 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Bernard Pidoux <bernard.pidoux@upmc.fr>
Cc: linux-kernel@vger.kernel.org
Subject: Re: 2.6.31.1 BUG #include <asm/bitsperlong.h>
Message-ID: <20090927102256.GA10295@merkur.ravnborg.org>
References: <4ABF36DF.90101@upmc.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4ABF36DF.90101@upmc.fr>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Sep 27, 2009 at 11:56:47AM +0200, Bernard Pidoux wrote:
> In kernel 2.6.31.1 the following files in
>
> /usr/src/linux-2.6.31.1/include/asm-generic/
>
> include <asm/bitsperlong.h> 
>
> while they should #include <asm-generic/bitsperlong.h>

It would be wrong to include the generic version
directly.
We need access to the arch specifics definitions
before we include the generic version.

See how different architectures does various things
in their: arch/$(ARCH)/include/asm/bitsperlong.h

	Sam
