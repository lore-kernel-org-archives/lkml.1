Return-Path: <linux-kernel-owner+w=401wt.eu-S933566AbZHDW4U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933566AbZHDW4U (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Aug 2009 18:56:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933556AbZHDW4T
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Aug 2009 18:56:19 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42692 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933554AbZHDW4R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Aug 2009 18:56:17 -0400
Date: Tue, 4 Aug 2009 15:55:50 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Albin Tonnerre <albin.tonnerre@free-electrons.com>
Cc: sam@ravnborg.org, hpa@zytor.com, linux@arm.linux.org.uk, alain@knaff.lu,
       linux-kernel@vger.kernel.org, linux-embedded@vger.kernel.org,
       albin.tonnerre@free-electrons.com
Subject: Re: [PATCH 2/6] include/linux/unaligned/{l,b}e_byteshift.h: Fix
 usage for compressed kernels
Message-Id: <20090804155550.3203f5f4.akpm@linux-foundation.org>
In-Reply-To: <1249311501-23102-2-git-send-email-albin.tonnerre@free-electrons.com>
References: <20090731093107.GA29704@merkur.ravnborg.org>
	<1249311501-23102-1-git-send-email-albin.tonnerre@free-electrons.com>
	<1249311501-23102-2-git-send-email-albin.tonnerre@free-electrons.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon,  3 Aug 2009 16:58:17 +0200
Albin Tonnerre <albin.tonnerre@free-electrons.com> wrote:

> When unaligned accesses are required for uncompressing a kernel (such as
> for LZO decompression on ARM in a patch that follows), including
> <linux/kernel.h> causes issues as it brings in a lot of things that are
> not available in the decompression environment.
> However, those files apparently use nothing from <linux/kernel.h>, all
> they need is the declaration of types such as u32 or u64, so
> <linux/types.h> should be enough

Again, please provide a full description of thes "issues" which a patch
addresses so that the patch's importance can be understood by others,
thanks.
