Return-Path: <linux-kernel-owner+w=401wt.eu-S1760264AbYEOO6f@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760264AbYEOO6f (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2008 10:58:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755252AbYEOO62
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 May 2008 10:58:28 -0400
Received: from 206-248-169-182.dsl.ncf.ca ([206.248.169.182]:56130 "EHLO
	phobos.cabal.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754000AbYEOO61 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2008 10:58:27 -0400
Date: Thu, 15 May 2008 10:58:26 -0400
From: Kyle McMartin <kyle@mcmartin.ca>
To: Ulrich Drepper <drepper@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-parisc@vger.kernel.org,
       akpm@linux-foundation.org, torvalds@linux-foundation.org
Subject: Re: [PATCH] flag parameters: arch-specific SOCK_NONBLOCK
Message-ID: <20080515145826.GM12850@phobos.i.cabal.ca>
References: <200805130431.m4D4Vo5e017311@devserv.devel.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200805130431.m4D4Vo5e017311@devserv.devel.redhat.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 13, 2008 at 12:31:50AM -0400, Ulrich Drepper wrote:
> The value of O_NONBLOCK clashes on Alpha dn PARISC with the bits used
> for socket types.  Therefore we cannot define SOCK_NONBLOCK as
> O_NONBLOCK on these platforms.  This patch adds support for an
> arch-specific SOCK_NONBLOCK value which doesn't add costs for
> other architectures.
> 
>  include/asm-alpha/socket.h  |    5 +++++
>  include/asm-parisc/socket.h |    5 +++++
>  include/linux/net.h         |    2 ++
>  net/socket.c                |    9 +++++++++
>  4 files changed, 21 insertions(+)
> 
> 
> Signed-off-by: Ulrich Drepper <drepper@redhat.com>
> 

This looks fine to me. Thanks, Ulrich!

Acked-by: Kyle McMartin <kyle@mcmartin.ca>
