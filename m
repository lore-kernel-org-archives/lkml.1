Return-Path: <linux-kernel-owner+w=401wt.eu-S1752537AbYIAW2d@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752537AbYIAW2d (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Sep 2008 18:28:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751093AbYIAW2Z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Sep 2008 18:28:25 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:51415 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751235AbYIAW2Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Sep 2008 18:28:24 -0400
Date: Mon, 1 Sep 2008 23:28:23 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Helge Deller <deller@gmx.de>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Re: Linux 2.6.27-rc5
Message-ID: <20080901222823.GK28946@ZenIV.linux.org.uk>
References: <alpine.LFD.1.10.0808281555230.3300@nehalem.linux-foundation.org> <g9b7oa$g8l$1@ger.gmane.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <g9b7oa$g8l$1@ger.gmane.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 30, 2008 at 12:34:51PM +0200, Helge Deller wrote:
> commit da574983de9f9283ba35662c8723627096e160de
> Author: Al Viro <viro@zeniv.linux.org.uk>
> [PATCH] fix hpux_getdents() - Missing checks for -EFAULT, broken handling of
> overflow.
> 
> introduced a build breakage:
>   CC      arch/parisc/hpux/fs.o
> arch/parisc/hpux/fs.c: In function `filldir':
> arch/parisc/hpux/fs.c:107: error: `buffer' undeclared (first use in this
> function)
> make[1]: *** [arch/parisc/hpux/fs.o] Error 1
> 
> 
> This patch fixes it.
> 
> Signed-off-by: Helge Deller <deller@gmx.de>

Applied after fixing cut'n'paste damage.
