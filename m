Return-Path: <linux-kernel-owner+w=401wt.eu-S1756794AbZBRTTY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756794AbZBRTTY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Feb 2009 14:19:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755969AbZBRTSm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Feb 2009 14:18:42 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:36027 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755636AbZBRTSk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Feb 2009 14:18:40 -0500
Subject: Re: Ubuntu Jaunty ext3 --> ext4 upgrade issue
From: Peter Zijlstra <peterz@infradead.org>
To: tim.gardner@canonical.com
Cc: tytso@mit.edu,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <499C4F1E.8050901@canonical.com>
References: <499C4F1E.8050901@canonical.com>
Content-Type: text/plain
Date: Wed, 18 Feb 2009 20:18:37 +0100
Message-Id: <1234984717.4785.0.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.25.91 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-02-18 at 11:10 -0700, Tim Gardner wrote:
> Ted,
> 
> I've encountered a situation where the patches that you've proposed for
> stable updates might be causing some issues. This user ivoks appears to
> have an upgrade issue. I assume he's enabled ext4 on an existing ext3
> file system. Hopefully I can get more details. Have you seen anything
> like this?
> 
> After looking at your for-stable branch, I think I'm missing a couple of
> jbd2 patches. Could they be significant?
> 
> rtg
> 
> <ivoks> i'm getting 'Invalid or unsupported executable format' from grub
> on all jaunty's generic kernels since (including) 2.6.28-7

Does your grub have ext4 support? Otherwise I would suggest not
converting /boot (or whatever other partition is used to load the kernel
from).

