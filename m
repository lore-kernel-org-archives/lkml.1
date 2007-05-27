Return-Path: <linux-kernel-owner+w=401wt.eu-S1754565AbXE0MuJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754565AbXE0MuJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 May 2007 08:50:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752129AbXE0Mtw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 May 2007 08:49:52 -0400
Received: from e4.ny.us.ibm.com ([32.97.182.144]:47440 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752101AbXE0Mtr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 May 2007 08:49:47 -0400
Subject: Re: [PATCH] mtd/ubi: silence gcc warning
From: Josh Boyer <jwboyer@linux.vnet.ibm.com>
To: Jeff Garzik <jeff@garzik.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, dedekind@infradead.org,
       linux-mtd@lists.infradead.org, LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20070527113254.GA11940@havoc.gtf.org>
References: <20070527113254.GA11940@havoc.gtf.org>
Content-Type: text/plain; charset=utf-8
Date: Sun, 27 May 2007 07:48:03 -0500
Message-Id: <1180270083.3360.45.camel@zod.rchland.ibm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 (2.10.1-4.fc7) 
Content-Transfer-Encoding: 8bit
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
> 
> Signed-off-by: Jeff Garzik <jeff@garzik.org>

Acked-by: Josh Boyer <jwboyer@linux.vnet.ibm.com>

