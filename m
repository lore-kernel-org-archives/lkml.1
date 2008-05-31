Return-Path: <linux-kernel-owner+w=401wt.eu-S1759346AbYEaTJW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759346AbYEaTJW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 May 2008 15:09:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757179AbYEaS4V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 31 May 2008 14:56:21 -0400
Received: from eth7959.sa.adsl.internode.on.net ([150.101.82.22]:41189 "EHLO
	hawking.rebel.net.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757171AbYEaS4U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 May 2008 14:56:20 -0400
Message-ID: <48419F45.20908@davidnewall.com>
Date: Sun, 01 Jun 2008 04:26:05 +0930
From: David Newall <davidn@davidnewall.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080227)
MIME-Version: 1.0
To: arnd@arndb.de
CC: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, hch@lst.de
Subject: Re: [RFC 0/7] [RFC] cramfs: fake write support
References: <200805311737.58991.arnd@arndb.de>
In-Reply-To: <200805311737.58991.arnd@arndb.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

arnd@arndb.de wrote:
> Many existing systems currently use unionfs or aufs for this
> purpose, by overlaying a tmpfs over a read-only file
> system like cramfs, squashfs or iso9660. IMHO, it would
> be a much nicer solution to not require unionfs for a simple
> case like this, but rather have support for it in the file
> system. If people find this useful, we can do the same in
> other read-only file system.
>   

I don't agree that it is nicer to do this in cramfs.  I prefer the
technique of union of a tmpfs over some other fs because a single
solution that works with all filesystems is better than re-implementing
the same idea in multiple filesystems.  Multiple implementations is a
recipe for bugs and feature mismatch.
