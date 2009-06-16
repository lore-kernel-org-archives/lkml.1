Return-Path: <linux-kernel-owner+w=401wt.eu-S1764211AbZFPUVF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764211AbZFPUVF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jun 2009 16:21:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763587AbZFPUSg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Jun 2009 16:18:36 -0400
Received: from mx2.redhat.com ([66.187.237.31]:51251 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763579AbZFPUSf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jun 2009 16:18:35 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20090616200746.GA28663@redhat.com>
References: <20090616200746.GA28663@redhat.com> <4A36532E.3050006@redhat.com> <20090615174544.GA10467@redhat.com> <4A36E555.80206@redhat.com> <20090616183829.GA10027@redhat.com> <alpine.LFD.2.01.0906161224110.3282@localhost.localdomain>
To: Oleg Nesterov <oleg@redhat.com>
Cc: dhowells@redhat.com, Linus Torvalds <torvalds@linux-foundation.org>,
       Eugene Teo <eugene@redhat.com>, James Morris <jmorris@namei.org>,
       Roland McGrath <roland@redhat.com>, solar@openwall.com,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] shift current_cred() from __f_setown() to f_modown()
Date: Tue, 16 Jun 2009 21:17:58 +0100
Message-ID: <24972.1245183478@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Oleg Nesterov <oleg@redhat.com> wrote:

> Shift current_cred() from __f_setown() to f_modown(). This reduces
> the number of arguments and saves 48 bytes from fs/fcntl.o.
> 
> Signed-off-by: Oleg Nesterov <oleg@redhat.com>

Acked-by: David Howells <dhowells@redhat.com>
