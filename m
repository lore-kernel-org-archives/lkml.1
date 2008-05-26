Return-Path: <linux-kernel-owner+w=401wt.eu-S1755560AbYEZMLl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755560AbYEZMLl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 May 2008 08:11:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754650AbYEZMLb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 May 2008 08:11:31 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:52100 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754587AbYEZMLb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 May 2008 08:11:31 -0400
Date: Mon, 26 May 2008 12:58:06 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Jiri Slaby <jirislaby@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Jiri Slaby <jirislaby@gmail.com>
Subject: Re: [PATCH 1/1] Char: vt, make sysfs operations atomic
Message-ID: <20080526125806.0a9922de@core>
In-Reply-To: <1211802812-13658-1-git-send-email-jirislaby@gmail.com>
References: <1211802812-13658-1-git-send-email-jirislaby@gmail.com>
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 26 May 2008 13:53:32 +0200
Jiri Slaby <jirislaby@gmail.com> wrote:

> Hold console sem while creating/destroying sysfs files. Serialisation is
> so far done by BKL held in tty release_dev and chrdev_open, but no other
> locks are held in open path.

Acked-by: Alan Cox <alan@redhat.com>
