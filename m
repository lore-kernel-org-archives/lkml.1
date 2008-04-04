Return-Path: <linux-kernel-owner+w=401wt.eu-S1756656AbYDDHUL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756656AbYDDHUL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Apr 2008 03:20:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751752AbYDDHT6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Apr 2008 03:19:58 -0400
Received: from oss.sgi.com ([192.48.170.157]:53538 "EHLO oss.sgi.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750770AbYDDHT6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Apr 2008 03:19:58 -0400
Date: Fri, 4 Apr 2008 08:19:50 +0100
From: Ralf Baechle <ralf@linux-mips.org>
To: Dmitri Vorobiev <dmitri.vorobiev@gmail.com>
Cc: linux-mips@linux-mips.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/5] [MIPS] unexport copy_user_highpage()
Message-ID: <20080404071950.GB12086@linux-mips.org>
References: <1207094318-21748-1-git-send-email-dmitri.vorobiev@gmail.com> <1207094318-21748-2-git-send-email-dmitri.vorobiev@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1207094318-21748-2-git-send-email-dmitri.vorobiev@gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 02, 2008 at 03:58:34AM +0400, Dmitri Vorobiev wrote:

> The copy_user_highpage() routine has no users outside of the
> core kernel code, so exporting this symbol is pointless.
> This patch removes EXPORT_SYMBOL(copy_user_highpage).
> 
> Signed-off-by: Dmitri Vorobiev <dmitri.vorobiev@gmail.com>

Queued for 2.6.26.  Thanks,

  Ralf
