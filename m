Return-Path: <linux-kernel-owner+w=401wt.eu-S933653AbZARPNT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933653AbZARPNT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Jan 2009 10:13:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762745AbZARPNA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 Jan 2009 10:13:00 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:58879 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1762901AbZARPM6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Jan 2009 10:12:58 -0500
Date: Sun, 18 Jan 2009 15:11:57 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Cedric Le Goater <clg@fr.ibm.com>, Dave Hansen <haveblue@us.ibm.com>,
       Eric Biederman <ebiederm@xmission.com>,
       Pavel Emelyanov <xemul@openvz.org>, Serge Hallyn <serue@us.ibm.com>,
       Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] pids: kill now unused signal_struct-> __pgrp/__session
 and friends
Message-ID: <20090118151157.09aaff4f@lxorguk.ukuu.org.uk>
In-Reply-To: <20090118143354.GA8159@redhat.com>
References: <20090118143354.GA8159@redhat.com>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.12; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 18 Jan 2009 15:33:54 +0100
Oleg Nesterov <oleg@redhat.com> wrote:

> On top of
> 	[PATCH] autofs: fix the wrong usage of the deprecated task_pgrp_nr()
> 	[PATCH] autofs4: turn ->oz_pgrp into "struct pid *"
> 	[PATCH] coda: alloc_upcall: s/task_pgrp_nr/task_pgrp_vnr/
> 
> task_pgrp_nr() was wiped from fs/ code recently, task_session_nr() has no
> callers since 2e2ba22ea4fd4bb85f0fa37c521066db6775cbef. __pgrp/__session
> become write-only. Kill them and the related helpers.
> 
> The change in drivers/char/tty_io.c is cosmetic, but hopefully makes sense
> anyway.
> 
> Signed-off-by: Oleg Nesterov <oleg@redhat.com>

TTY parts Acked-by: Alan Cox <number6@the-village.bc.nu>
