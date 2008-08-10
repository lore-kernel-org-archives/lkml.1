Return-Path: <linux-kernel-owner+w=401wt.eu-S1754742AbYHJV5Q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754742AbYHJV5Q (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Aug 2008 17:57:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753790AbYHJV5D
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 Aug 2008 17:57:03 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:50277 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753788AbYHJV5B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Aug 2008 17:57:01 -0400
Date: Sun, 10 Aug 2008 22:37:19 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Rene Herman <rene.herman@keyaccess.nl>
Cc: Andrew Morton <akpm@osdl.org>, Ingo Molnar <mingo@redhat.com>,
       video4linux-list@redhat.com,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] V4L1: make PMS not autoprobe when builtin.
Message-ID: <20080810223719.446bf52a@lxorguk.ukuu.org.uk>
In-Reply-To: <489F5F99.1000905@keyaccess.nl>
References: <489F5F99.1000905@keyaccess.nl>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.11; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 10 Aug 2008 23:37:29 +0200
Rene Herman <rene.herman@keyaccess.nl> wrote:

> Hi Andrew.
> 
> Alternate version of the PMS patch sent yesterday. This one makes it 
> need explicit enabling when builtin and doesn't change anything when 
> modular as per Alan Cox's comments.
> 
> This is a deprecated, unused driver meaning it doesn't matter. It still 
> fixes that (randconfig testing breakage) which it is supposed to fix.


Acked-by: Alan Cox <alan@redhat.com>


Would probably make the printk "pms: not enabled, use pms.enable=1 to
probe"

So you know
a) What is wittering about not being probed
b) How to undo it.

But thats trivia really.
