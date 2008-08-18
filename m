Return-Path: <linux-kernel-owner+w=401wt.eu-S1755816AbYHRRiZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755816AbYHRRiZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2008 13:38:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755397AbYHRRhy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Aug 2008 13:37:54 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:40652 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755261AbYHRRhx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2008 13:37:53 -0400
Date: Mon, 18 Aug 2008 18:19:02 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Aristeu Rozanski <aris@redhat.com>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       jirislaby@gmail.com
Subject: Re: [PATCH] vt: kill tty->count usage (v2)
Message-ID: <20080818181902.59ac763b@lxorguk.ukuu.org.uk>
In-Reply-To: <20080812145812.GH7154@redhat.com>
References: <20080808213625.GK20355@redhat.com>
	<20080808222635.4fe52b51@lxorguk.ukuu.org.uk>
	<20080812145812.GH7154@redhat.com>
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

On Tue, 12 Aug 2008 10:58:12 -0400
Aristeu Rozanski <aris@redhat.com> wrote:

> The commit e0426e6a09954d205da2d674a3d368d2715e3afd fixes a real race but
> still isn't enough to prevent these:
> 
> kobject_add_internal failed for vcs7 with -EEXIST, don't try to register
> things with the same name in the same direc.

Patch dropped due to testing failures.

Boot to run level 3, log in and type "reboot\n". Wait

Spews vt->driver_data == NULL warnings and oopses
