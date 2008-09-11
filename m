Return-Path: <linux-kernel-owner+w=401wt.eu-S1756597AbYIKXux@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756597AbYIKXux (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2008 19:50:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754990AbYIKXup
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Sep 2008 19:50:45 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49535 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754334AbYIKXuo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2008 19:50:44 -0400
Date: Thu, 11 Sep 2008 16:50:39 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Harun Scheutzow <harun04@scheutzow.de>
Cc: linux-kernel@vger.kernel.org
Subject: Re: vfat file system extreme fragmentation on multiprocessor
Message-Id: <20080911165039.d129a559.akpm@linux-foundation.org>
In-Reply-To: <0ML29c-1KdqyO1YV1-0001g5@mrelayeu.kundenserver.de>
References: <0ML29c-1KdqyO1YV1-0001g5@mrelayeu.kundenserver.de>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 11 Sep 2008 20:01:16 +0200
Harun Scheutzow <harun04@scheutzow.de> wrote:

> I like to share the following observation made with different kernels of 2.6.x series

Yeah.  ext2 and ext3 also showed major, major, major differences in
layout quality (and hence performance) when switching between
uniprocessor and multiprocessor environments, for the same reason. (UP was
far better).

It was fixed in ext3/4 by the in-core reservations code (recently
ported into ext2 as well).

This is why filesystem performance testing is far from complete if it
is performed only on SMP (or UP) machines.

