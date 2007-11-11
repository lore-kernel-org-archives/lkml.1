Return-Path: <linux-kernel-owner+w=401wt.eu-S1756749AbXKKAw4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756749AbXKKAw4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Nov 2007 19:52:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755912AbXKKAwt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Nov 2007 19:52:49 -0500
Received: from mx02.hansenet.de ([213.191.73.26]:43514 "EHLO
	webmail.hansenet.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755894AbXKKAws (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Nov 2007 19:52:48 -0500
From: Thomas Koeller <thomas@koeller.dyndns.org>
To: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] Include header required for INT_MAX
Date: Sun, 11 Nov 2007 01:52:54 +0100
User-Agent: KMail/1.9.7
Cc: axboe@kernel.dk, linux-kernel@vger.kernel.org
References: <20071110145627.C6FE347A7C@mail.koeller.dyndns.org> <20071110155613.GB22418@infradead.org>
In-Reply-To: <20071110155613.GB22418@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200711110152.55440.thomas@koeller.dyndns.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Samstag, 10. November 2007, Christoph Hellwig wrote:
> On Sat, Nov 10, 2007 at 03:55:15PM +0100, Thomas Koeller wrote:
> > cdrom.h uses INT_MAX, so it must include kernel.h or
> > limits.h (userspace) for a definition.
>
> Nack, we shoiuld never include userspace headers in kernel headers,
> an even more never add !__KERNEL__ ifdefs.  Just make sure your
> programs include limit.h before including linux/cdrom.h.

I think header files should be complete, and should not use undefined
macros, picking up every random definition that may be in effect when
the header is included, don't you agree? Why not use some other
constant instead of INT_MAX? What improvement does commit
132e4b0a049c39337c535501561b8301c7f2b202 provide? It certainly
breaks existing userspace code.

tk

-- 
Thomas Koeller
thomas at koeller dot dyndns dot org
