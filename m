Return-Path: <linux-kernel-owner+w=401wt.eu-S1756690AbXEQMCS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756690AbXEQMCS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2007 08:02:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755469AbXEQMCK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 May 2007 08:02:10 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:55523 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754962AbXEQMCJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2007 08:02:09 -0400
Date: Thu, 17 May 2007 13:06:43 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: bbpetkov@yahoo.de
Cc: bzolnier@gmail.com, linux-ide@vger.kernel.org,
       lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] ide.c: microscopic size and readability optimization
Message-ID: <20070517130643.39fbfe29@the-village.bc.nu>
In-Reply-To: <20070517112554.GA32183@zmei.tnic>
References: <20070517112554.GA32183@zmei.tnic>
X-Mailer: Claws Mail 2.9.1 (GTK+ 2.10.8; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 17 May 2007 13:25:54 +0200
Borislav Petkov <bbpetkov@yahoo.de> wrote:

> -----
> From: bbpetkov@yahoo.de
> 
> A very small size (object file 432 bytes smaller) and readability optimization of ide.c
> 
> Signed-off-by: Borislav Petkov <bbpetkov@yahoo.de>

Bad idea. Now you won't know which of the conditions caused the BUG() to
occur.

