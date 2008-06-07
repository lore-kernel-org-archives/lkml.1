Return-Path: <linux-kernel-owner+w=401wt.eu-S1756124AbYFGA2T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756124AbYFGA2T (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2008 20:28:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753065AbYFGA2I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Jun 2008 20:28:08 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:45720 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752131AbYFGA2H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2008 20:28:07 -0400
Date: Sat, 7 Jun 2008 01:12:19 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/4] ide: tighten checks on PCI BARs in
 ide_hwif_configure()
Message-ID: <20080607011219.360dbd78@core>
In-Reply-To: <200806062341.26708.bzolnier@gmail.com>
References: <200806062341.26708.bzolnier@gmail.com>
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

On Fri, 6 Jun 2008 23:41:26 +0200
Bartlomiej Zolnierkiewicz <bzolnier@gmail.com> wrote:

> Alan has fixed PCI layer handling of PCI IDE in Compatibility mode so
> PCI BAR 0/1 (and/or 2/3) content reported by kernel should never be zero.

Providing you are in compatability mode - you might see 0 for a native
mode port that has not been assigned, and now and then a bios will lob
you one of those just to see what happens 8)
