Return-Path: <linux-kernel-owner+w=401wt.eu-S1758244AbYDDHUr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758244AbYDDHUr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Apr 2008 03:20:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756972AbYDDHUP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Apr 2008 03:20:15 -0400
Received: from oss.sgi.com ([192.48.170.157]:53558 "EHLO oss.sgi.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756128AbYDDHUI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Apr 2008 03:20:08 -0400
Date: Fri, 4 Apr 2008 08:20:01 +0100
From: Ralf Baechle <ralf@linux-mips.org>
To: Dmitri Vorobiev <dmitri.vorobiev@gmail.com>
Cc: linux-mips@linux-mips.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/5] [MIPS] unexport copy_to_user_page()
Message-ID: <20080404072001.GC12086@linux-mips.org>
References: <1207094318-21748-1-git-send-email-dmitri.vorobiev@gmail.com> <1207094318-21748-3-git-send-email-dmitri.vorobiev@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1207094318-21748-3-git-send-email-dmitri.vorobiev@gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 02, 2008 at 03:58:35AM +0400, Dmitri Vorobiev wrote:

> The copy_to_user_page() function is called only in the core kernel
> code. Therefore, there is no need to export it. This patch removes
> EXPORT_SYMBOL(copy_to_user_page).
> 
> Signed-off-by: Dmitri Vorobiev <dmitri.vorobiev@gmail.com>

Queued for 2.6.26.  Thanks,

  Ralf
