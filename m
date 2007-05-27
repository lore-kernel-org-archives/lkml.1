Return-Path: <linux-kernel-owner+w=401wt.eu-S1753109AbXE0Mzo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753109AbXE0Mzo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 May 2007 08:55:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752641AbXE0Mzh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 May 2007 08:55:37 -0400
Received: from smtp.nokia.com ([131.228.20.173]:60007 "EHLO
	mgw-ext14.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752373AbXE0Mzg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 May 2007 08:55:36 -0400
Subject: Re: [PATCH] mtd/ubi: silence gcc warning
From: Artem Bityutskiy <dedekind@infradead.org>
Reply-To: dedekind@infradead.org
To: Jeff Garzik <jeff@garzik.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, linux-mtd@lists.infradead.org
In-Reply-To: <20070527113254.GA11940@havoc.gtf.org>
References: <20070527113254.GA11940@havoc.gtf.org>
Content-Type: text/plain; charset=utf-8
Date: Sun, 27 May 2007 15:54:57 +0300
Message-Id: <1180270497.3642.107.camel@sauron>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 (2.8.3-2.fc6) 
Content-Transfer-Encoding: 8BIT
X-OriginalArrivalTime: 27 May 2007 12:54:57.0879 (UTC) FILETIME=[3AE4C670:01C7A05E]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2007-05-27 at 07:32 -0400, Jeff Garzik wrote:
> Silence the gcc warning
> 
> drivers/mtd/ubi/eba.c: In function ‘ubi_eba_read_leb’:
> drivers/mtd/ubi/eba.c:371: warning: ‘crc’ may be used uninitialized in this function
> 
> This is an example of the uninit'd-var warnings emitted by gcc that
> can be proven to be bogus.
> 
> Normally I would commit this to my git repository containing
> such verified cases, but with all the goto-driven control flow in
> ubi_eba_read_leb(), I feel that initializing the 'crc' variable is
> an easy way to both shut up gcc, and also make the code less fragile
> for the long term.

Committed to the UBI git tree, thanks.

-- 
Best regards,
Artem Bityutskiy (Битюцкий Артём)

