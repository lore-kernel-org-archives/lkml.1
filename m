Return-Path: <linux-kernel-owner+w=401wt.eu-S1756676AbYEJRfG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756676AbYEJRfG (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 May 2008 13:35:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752466AbYEJRey
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 May 2008 13:34:54 -0400
Received: from mail.gmx.net ([213.165.64.20]:47621 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1750799AbYEJRey (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 May 2008 13:34:54 -0400
X-Authenticated: #9962044
X-Provags-ID: V01U2FsdGVkX1+vk4Rsy0ivP/zma20NzMHqkzfO5sbJ41SH5jKNe8
	fafUIbjiaUcrdw
From: Marvin <marvin24@gmx.de>
To: linux-kernel@vger.kernel.org
Subject: page vs. fs-cache
Date: Sat, 10 May 2008 19:34:47 +0200
User-Agent: KMail/1.9.9
Cc: cbe-oss-dev@ozlabs.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200805101934.48199.marvin24@gmx.de>
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

what is the status of fs-cache? 

I'm asking, because the PS3 gained access to the video memory as a block 
device recently. I'm using it as a swap device and set swappiness to 100. 

Since the PS3 has only little (main)-memory (< 256MB), it would be more 
effective to use the video memory (~180MB) primary as the file system cache 
and all the main-memory as page cache (swappiness = 0?).

I know that fs-cache is for network-fs caching, but could it be used to cache 
ext3/4 filesystem?

Greetings

Marvin

