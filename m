Return-Path: <linux-kernel-owner+w=401wt.eu-S1755292AbYEEEqH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755292AbYEEEqH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2008 00:46:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752029AbYEEEpx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 May 2008 00:45:53 -0400
Received: from x35.xmailserver.org ([64.71.152.41]:46964 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752109AbYEEEpw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2008 00:45:52 -0400
X-AuthUser: davidel@xmailserver.org
Date: Sun, 4 May 2008 21:45:51 -0700 (PDT)
From: Davide Libenzi <davidel@xmailserver.org>
X-X-Sender: davide@alien.or.mcafeemobile.com
To: Ulrich Drepper <drepper@redhat.com>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       netdev@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       mtk.manpages@gmail.com, Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH 01/18] flag parameters: helper function
In-Reply-To: <200805050342.m453gkY4029814@devserv.devel.redhat.com>
Message-ID: <Pine.LNX.4.64.0805042144320.8307@alien.or.mcafeemobile.com>
References: <200805050342.m453gkY4029814@devserv.devel.redhat.com>
X-GPG-FINGRPRINT: CFAE 5BEE FD36 F65E E640  56FE 0974 BF23 270F 474E
X-GPG-PUBLIC_KEY: http://www.xmailserver.org/davidel.asc
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 4 May 2008, Ulrich Drepper wrote:

> In the following patches we have to map one set of flags to another one
> in numerous locations.  This patch provides a generic implementation for
> this.  It is basically the code Davide Libenzi suggested on 4/27/08.
> 
> I haven't checked whether this functionality can be applied to any existing
> code.
> 
> 
>  include/linux/flagsremap.h |   15 +++++++++++++++
>  lib/Makefile               |    2 +-
>  lib/flagsremap.c           |   17 +++++++++++++++++
>  3 files changed, 33 insertions(+), 1 deletion(-)
> 
> 
> Signed-off-by: Ulrich Drepper <drepper@redhat.com>

I dunno if this deserves separate c/h files. Otherwise ...

Acked-by: Davide Libenzi <davidel@xmailserver.org>



- Davide


