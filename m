Return-Path: <linux-kernel-owner+w=401wt.eu-S968069AbXEHN6G@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S968069AbXEHN6G (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2007 09:58:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S968064AbXEHN6E
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 May 2007 09:58:04 -0400
Received: from courier.cs.helsinki.fi ([128.214.9.1]:35967 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S968063AbXEHN6B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2007 09:58:01 -0400
Date: Tue, 8 May 2007 16:57:59 +0300 (EEST)
From: Pekka J Enberg <penberg@cs.helsinki.fi>
To: Jens Axboe <jens.axboe@oracle.com>
cc: Rene Herman <rene.herman@gmail.com>, Andrew Morton <akpm@osdl.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: New Mitsumi legacy CD-ROM driver
In-Reply-To: <20070508134944.GO4163@kernel.dk>
Message-ID: <Pine.LNX.4.64.0705081656570.31629@sbz-30.cs.Helsinki.FI>
References: <464045F0.3040906@gmail.com> <20070508103524.GH4163@kernel.dk>
 <46407D75.7050603@gmail.com> <20070508134944.GO4163@kernel.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 8 May 2007, Jens Axboe wrote:
> IOW, you are always better off not supporting highmem for this driver.
> The fact that it also simplifies the handling is a bonus.

Agreed. So we should just use BLK_BOUNCE_HIGH, right?

On Tue, 8 May 2007, Jens Axboe wrote:
> Fine with me... As far as I am concerned, you are now the legacy CD-ROM
> driver maintainer :-)

Poor Rene... ;-)
