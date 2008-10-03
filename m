Return-Path: <linux-kernel-owner+w=401wt.eu-S1753898AbYJCRGb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753898AbYJCRGb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2008 13:06:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752481AbYJCRGV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Oct 2008 13:06:21 -0400
Received: from sovereign.computergmbh.de ([85.214.69.204]:53786 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752311AbYJCRGU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2008 13:06:20 -0400
Date: Fri, 3 Oct 2008 13:06:18 -0400 (EDT)
From: Jan Engelhardt <jengelh@medozas.de>
To: Chris Mason <chris.mason@oracle.com>
cc: linux-fsdevel <linux-fsdevel@vger.kernel.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [RFC] Btrfs mainline plans
In-Reply-To: <1222717460.30627.56.camel@think.oraclecorp.com>
Message-ID: <alpine.LNX.1.10.0810031303520.13861@fbirervta.pbzchgretzou.qr>
References: <1222717460.30627.56.camel@think.oraclecorp.com>
User-Agent: Alpine 1.10 (LNX 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Monday 2008-09-29 15:44, Chris Mason wrote:
>[...]
>But, the code is very actively developed, and I believe the best way to
>develop Btrfs from here is to get it into the mainline kernel (with a
>large warning label about the disk format) and attract more extensive
>review of both the disk format and underlying code.

Definitely. While, due to the changing disk format, long-term storage
is not really an option yet, the filesystem can be really useful in
network-booted hybrid clients that have a local disk in an unionfs
compound mount as a COW rw storage device (because RAM *is* limited
after all). Keep up the work.


Jan
