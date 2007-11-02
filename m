Return-Path: <linux-kernel-owner+w=401wt.eu-S1754354AbXKBIFN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754354AbXKBIFN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Nov 2007 04:05:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751925AbXKBIEw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Nov 2007 04:04:52 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:48354 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751027AbXKBIEu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Nov 2007 04:04:50 -0400
Date: Fri, 2 Nov 2007 01:04:19 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Pavel Emelyanov <xemul@openvz.org>
Cc: Ulrich Drepper <drepper@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [patch] PID namespace design bug, workaround
Message-Id: <20071102010419.23f3db5c.akpm@linux-foundation.org>
In-Reply-To: <472AD7D6.80900@openvz.org>
References: <20071101144307.GA29566@elte.hu>
	<4729E7E4.8070208@openvz.org>
	<4729E936.4040400@redhat.com>
	<4729EB3C.9050102@openvz.org>
	<472A6D91.1020300@redhat.com>
	<472AD7D6.80900@openvz.org>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 02 Nov 2007 10:55:02 +0300 Pavel Emelyanov <xemul@openvz.org> wrote:

> Ulrich Drepper wrote:
> > -----BEGIN PGP SIGNED MESSAGE-----
> > Hash: SHA1
> > 
> > Pavel Emelyanov wrote:
> >> The "fix" I mention is just returning -EINVAL in case user orders 
> >> CLONE_NEWPIDS
> > 
> > That is the "fix" you were referring to?  I was hoping you have a sketch
> > for a real solution.  If nobody can think of a way to fix this PID
> 
> Looks like we misunderstood each other. Can you please elaborate on 
> what exactly is broken in pid namespaces?

Isn't it this?

http://lkml.org/lkml/2007/11/1/141

