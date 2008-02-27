Return-Path: <linux-kernel-owner+w=401wt.eu-S1755351AbYB0Ox1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755351AbYB0Ox1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Feb 2008 09:53:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754159AbYB0OxR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Feb 2008 09:53:17 -0500
Received: from ftp.linux-mips.org ([194.74.144.162]:43881 "EHLO
	ftp.linux-mips.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754134AbYB0OxQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Feb 2008 09:53:16 -0500
Date: Wed, 27 Feb 2008 14:53:08 +0000
From: Ralf Baechle <ralf@linux-mips.org>
To: Martin Michlmayr <tbm@cyrius.com>
Cc: linux-kernel@vger.kernel.org, Evgeniy Polyakov <johnpol@2ka.mipt.ru>,
       Herbert Xu <herbert@gondor.apana.org.au>,
       Andrew Morton <akpm@linux-foundation.org>, linux-mips@linux-mips.org
Subject: Re: 2.6.25-rc3: "__divdi3" [drivers/crypto/hifn_795x.ko] undefined!
Message-ID: <20080227145308.GC20629@linux-mips.org>
References: <20080226122100.GB22699@deprecation.cyrius.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080226122100.GB22699@deprecation.cyrius.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 26, 2008 at 01:21:00PM +0100, Martin Michlmayr wrote:

References to __divdi3 / __udivdi3 are becoming a somewhat regular bug.
I've created a patch to add these to the kernel but I'd rather not push
it unless I have to.  64-bit operations but especially divisions are slow
on 32-bit hardware so undefined references serve as an important detector.

  Ralf
