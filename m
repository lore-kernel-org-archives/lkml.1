Return-Path: <linux-kernel-owner+w=401wt.eu-S1758890AbZFPW5g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758890AbZFPW5g (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jun 2009 18:57:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757168AbZFPW53
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Jun 2009 18:57:29 -0400
Received: from tundra.namei.org ([65.99.196.166]:35074 "EHLO tundra.namei.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756216AbZFPW52 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jun 2009 18:57:28 -0400
Date: Wed, 17 Jun 2009 08:56:44 +1000 (EST)
From: James Morris <jmorris@namei.org>
To: Oleg Nesterov <oleg@redhat.com>
cc: Linus Torvalds <torvalds@linux-foundation.org>,
       David Howells <dhowells@redhat.com>, Eugene Teo <eugene@redhat.com>,
       Roland McGrath <roland@redhat.com>, solar@openwall.com,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] shift current_cred() from __f_setown() to f_modown()
In-Reply-To: <20090616200746.GA28663@redhat.com>
Message-ID: <alpine.LRH.2.00.0906170856230.3185@tundra.namei.org>
References: <4A36532E.3050006@redhat.com> <20090615174544.GA10467@redhat.com> <4A36E555.80206@redhat.com> <20090616183829.GA10027@redhat.com> <alpine.LFD.2.01.0906161224110.3282@localhost.localdomain> <20090616200746.GA28663@redhat.com>
User-Agent: Alpine 2.00 (LRH 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 16 Jun 2009, Oleg Nesterov wrote:

> Shift current_cred() from __f_setown() to f_modown(). This reduces
> the number of arguments and saves 48 bytes from fs/fcntl.o.
> 
> Signed-off-by: Oleg Nesterov <oleg@redhat.com>

Reviewed-by: James Morris <jmorris@namei.org>


-- 
James Morris
<jmorris@namei.org>
