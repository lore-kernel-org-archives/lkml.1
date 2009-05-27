Return-Path: <linux-kernel-owner+w=401wt.eu-S1757491AbZE0VKe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757491AbZE0VKe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 May 2009 17:10:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756203AbZE0VK1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 May 2009 17:10:27 -0400
Received: from smtp.gentoo.org ([140.211.166.183]:47548 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754945AbZE0VK1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 May 2009 17:10:27 -0400
From: Mike Frysinger <vapier@gentoo.org>
Organization: wh0rd.org
To: uclinux-dev@uclinux.org
Subject: Re: [uClinux-dev] [PATCH] FLAT: make sure data section is aligned at 32 bytes
Date: Wed, 27 May 2009 17:10:26 -0400
User-Agent: KMail/1.11.3 (Linux/2.6.29.2; KDE/4.2.3; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, uclinux-dist-devel@blackfin.uclinux.org,
       Jie Zhang <jie.zhang@analog.com>
References: <1243411102-24630-1-git-send-email-vapier@gentoo.org>
In-Reply-To: <1243411102-24630-1-git-send-email-vapier@gentoo.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200905271710.28330.vapier@gentoo.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 27 May 2009 03:58:22 Mike Frysinger wrote:
> From: Jie Zhang <jie.zhang@analog.com>
>
> If a structure in the data section attempts to force a larger alignment,
> the FLAT loader will break this when working with shared flat libraries
> by inserting a few words before the data section.

i guess ignore this due to the resurrected "flat: fix data sections alignment" 
thread.  once that gets merged, we'll recheck the need for this patch.
-mike
