Return-Path: <linux-kernel-owner+w=401wt.eu-S1755464AbYCQTUJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755464AbYCQTUJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Mar 2008 15:20:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753149AbYCQTTo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Mar 2008 15:19:44 -0400
Received: from fxip-0047f.externet.hu ([88.209.222.127]:34039 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752256AbYCQTTn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Mar 2008 15:19:43 -0400
Message-Id: <20080317191908.123631326@szeredi.hu>
User-Agent: quilt/0.45-1
Date: Mon, 17 Mar 2008 20:19:08 +0100
From: Miklos Szeredi <miklos@szeredi.hu>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       linux-mm@kvack.org
Subject: [patch 0/8] fuse: writable mmap + batched write
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andrew,

These are fuse updates for 2.6.26.

1-4) small tweaks to core code to make writable mmap in fuse possible
5) the fuse writable mmap support itself
6-7) allows buffered fuse writes to be bigger than 4k
8) handle short buffered reads better

Thanks,
Miklos
