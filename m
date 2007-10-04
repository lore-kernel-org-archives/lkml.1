Return-Path: <linux-kernel-owner+w=401wt.eu-S1762337AbXJDXQi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762337AbXJDXQi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Oct 2007 19:16:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755585AbXJDXQb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Oct 2007 19:16:31 -0400
Received: from mail-gw3.sa.ew.hu ([212.108.200.82]:45500 "EHLO
	mail-gw3.sa.ew.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756657AbXJDXQa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Oct 2007 19:16:30 -0400
To: akpm@linux-foundation.org
CC: miklos@szeredi.hu, linux-kernel@vger.kernel.org
In-reply-to: <20071004155128.62fc1098.akpm@linux-foundation.org> (message from
	Andrew Morton on Thu, 4 Oct 2007 15:51:28 -0700)
Subject: Re: [patch 09/12] fuse: add list of writable files to fuse_inode
References: <20071002155026.650555479@szeredi.hu>
	<20071002155222.373341208@szeredi.hu> <20071004155128.62fc1098.akpm@linux-foundation.org>
Message-Id: <E1IdZvZ-0002ZW-00@dorka.pomaz.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Fri, 05 Oct 2007 01:16:21 +0200
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> hm.  At no point in this patch series does anything actually get added to
> these lists, so this patch is presently a no-op.
> 
> I'll assume that it will get used later.  But it is a bit odd to add
> infrastructure in a patch series, then not use it.  Why not hold the patch
> back and include it in the patch series which actually uses these lists for
> something?

My stupidity.  I somehow thought the patch does actually do something
interesting when including it in this series, instead of holding it
back for the writable-mmap series.

Miklos
