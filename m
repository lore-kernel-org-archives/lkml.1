Return-Path: <linux-kernel-owner+w=401wt.eu-S1753944AbZI2MEO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753944AbZI2MEO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Sep 2009 08:04:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753645AbZI2MEN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Sep 2009 08:04:13 -0400
Received: from eddie.linux-mips.org ([78.24.191.182]:40538 "EHLO
	eddie.linux-mips.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751038AbZI2MEN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Sep 2009 08:04:13 -0400
Date: Tue, 29 Sep 2009 14:05:04 +0200
From: Ralf Baechle <ralf@linux-mips.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Michal Simek <michal.simek@petalogix.com>, linux-arch@vger.kernel.org,
       microblaze-uclinux@itee.uq.edu.au, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] kill USE_ELF_CORE_DUMP
Message-ID: <20090929120504.GA13128@linux-mips.org>
References: <20090423183331.GA19899@lst.de> <49F16786.7010401@petalogix.com> <20090926195010.GA24592@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090926195010.GA24592@lst.de>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Sep 26, 2009 at 09:50:10PM +0200, Christoph Hellwig wrote:

> Currently all architectures but microblaze unconditionally define
> USE_ELF_CORE_DUMP.  The microblaze ommision seems like an error to
> me, so let's  kill this ifdef and make sure we are the same everywhere.

USE_ELF_CORE_DUMP was introduced in 2.6.11.  Already back then all
architectures did define it unconditionally in <asm/elf.h> so there may
never have been any real use for it.

Acked-by: Ralf Baechle <ralf@linux-mips.org>

  Ralf
