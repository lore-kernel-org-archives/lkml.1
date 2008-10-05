Return-Path: <linux-kernel-owner+w=401wt.eu-S1756732AbYJESYR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756732AbYJESYR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Oct 2008 14:24:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755224AbYJESYB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 5 Oct 2008 14:24:01 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:55097 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755140AbYJESYB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Oct 2008 14:24:01 -0400
Date: Sun, 5 Oct 2008 19:22:03 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Frans Pop <elendil@planet.nl>
Cc: Alan Cox <alan@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 14/19] parport: quickfix the proc registration bug
Message-ID: <20081005192203.279b8dfc@lxorguk.ukuu.org.uk>
In-Reply-To: <200810052010.29315.elendil@planet.nl>
References: <20081005163302.3799.61899.stgit@localhost.localdomain>
	<20081005163302.3799.61899.stgit@localhost.localdomain>
	<20081005163758.3799.88465.stgit@localhost.localdomain>
	<200810052010.29315.elendil@planet.nl>
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

On Sun, 5 Oct 2008 20:10:28 +0200
Frans Pop <elendil@planet.nl> wrote:

> Alan Cox wrote:
> > Ideally we should have a directory of drivers and a link to the 'active'
> > driver. For now just show the first device which is effectively the
> > existing semantics without a warning.
> > 
> > Signed-off-by: Alan Cox <alan@redhat.com>
> 
> I tested this patch, but it did not fix the issue [1].
> Should it still be included?

It fixed it for me so its still in my test pile but yes I do need to look
at what you saw to try and work out why
