Return-Path: <linux-kernel-owner+w=401wt.eu-S1753457AbYJNSvz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753457AbYJNSvz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Oct 2008 14:51:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751533AbYJNSvq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Oct 2008 14:51:46 -0400
Received: from palinux.external.hp.com ([192.25.206.14]:34597 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751505AbYJNSvp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Oct 2008 14:51:45 -0400
Date: Tue, 14 Oct 2008 12:51:44 -0600
From: Matthew Wilcox <matthew@wil.cx>
To: Julia Lawall <julia@diku.dk>
Cc: kristen.c.accardi@intel.com, linux-pci@vger.kernel.org,
       linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH 1/2] drivers/pci/hotplug/cpqphp_ctrl.c: Convert && to ||
Message-ID: <20081014185143.GH15064@parisc-linux.org>
References: <Pine.LNX.4.64.0810141759300.20451@pc-004.diku.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0810141759300.20451@pc-004.diku.dk>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 14, 2008 at 05:59:50PM +0200, Julia Lawall wrote:
> From: Julia Lawall <julia@diku.dk>
> 
> The pattern !E && !E->fld is nonsensical.  The patch below updates this
> according to the assumption that && should be ||.  But perhaps another
> solution was intended.
> 
> Signed-off-by: Julia Lawall <julia@diku.dk>

I think that's the right solution for this case.

Reviewed-by: Matthew Wilcox <willy@linux.intel.com>

-- 
Matthew Wilcox				Intel Open Source Technology Centre
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
