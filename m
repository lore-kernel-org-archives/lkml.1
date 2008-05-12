Return-Path: <linux-kernel-owner+w=401wt.eu-S1756845AbYELULq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756845AbYELULq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 May 2008 16:11:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753224AbYELULh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 May 2008 16:11:37 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:35767 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752804AbYELULg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 May 2008 16:11:36 -0400
Date: Mon, 12 May 2008 20:58:23 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Chris Malley <mail@chrismalley.co.uk>
Cc: Alan Cox <alan@redhat.com>, linux-kernel@vger.kernel.org, akpm@osdl.org
Subject: Re: [PATCH] riscom8: remove redundant null pointer test
Message-ID: <20080512205823.23adc6f1@core>
In-Reply-To: <1210616830.7454.0.camel@localhost>
References: <1210616830.7454.0.camel@localhost>
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

On Mon, 12 May 2008 19:27:10 +0100
Chris Malley <mail@chrismalley.co.uk> wrote:

> tty has already been dereferenced at least twice in these functions,
> so checking for null here seems a bit unnecessary.

Oh it is - and lots of the other tty checks are bogus too.

Acked-by: Alan Cox <alan@redhat.com>

Alan
