Return-Path: <linux-kernel-owner+w=401wt.eu-S1756366AbYBYQOp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756366AbYBYQOp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Feb 2008 11:14:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755530AbYBYQOe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Feb 2008 11:14:34 -0500
Received: from saraswathi.solana.com ([198.99.130.12]:44415 "EHLO
	saraswathi.solana.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753567AbYBYQOe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Feb 2008 11:14:34 -0500
Date: Mon, 25 Feb 2008 11:14:08 -0500
From: Jeff Dike <jdike@addtoit.com>
To: "Theodore Ts'o" <tytso@mit.edu>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Should a x86 gdb work under an x86_64 kernel?
Message-ID: <20080225161408.GA7295@c2.user-mode-linux.org>
References: <E1JTeeF-0005dk-Nv@closure.thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1JTeeF-0005dk-Nv@closure.thunk.org>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 25, 2008 at 09:49:43AM -0500, Theodore Ts'o wrote:
> 	I've noticed that if I try to use a 32-bit x86 gdb to debug a
> 32-bit program under a 64-bit x86_64 kernel, gdb (version 6.6-debian,
> from Ubuntu Gutsy) immediately core dumps as soon as I run the test
> program under the debugger.  Is this normal/expected/known bug?

Probably - UML broke too.

Roland found the bug and posted a patch fairly quickly -
	http://marc.info/?l=linux-kernel&m=120365510230307&q=raw

				Jeff

-- 
Work email - jdike at linux dot intel dot com
