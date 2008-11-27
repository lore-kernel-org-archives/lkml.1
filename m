Return-Path: <linux-kernel-owner+w=401wt.eu-S1753391AbYK0RjW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753391AbYK0RjW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2008 12:39:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751706AbYK0RjL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Nov 2008 12:39:11 -0500
Received: from cavan.codon.org.uk ([93.93.128.6]:54590 "EHLO
	vavatch.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751448AbYK0RjK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2008 12:39:10 -0500
Date: Thu, 27 Nov 2008 17:39:06 +0000
From: Matthew Garrett <mjg@redhat.com>
To: =?iso-8859-1?Q?P=E1draig?= Brady <P@draigBrady.com>
Cc: Karel Zak <kzak@redhat.com>, Randy Dunlap <randy.dunlap@oracle.com>,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       mingo@redhat.com, val.henson@gmail.com, matthew@wil.cx,
       util-linux-ng@vger.kernel.org
Subject: Re: [PATCH v2 2/2] relatime: Allow making relatime the default	behaviour
Message-ID: <20081127173906.GA24126@srcf.ucam.org>
References: <20081126195457.GA3541@srcf.ucam.org> <20081126195824.GB3541@srcf.ucam.org> <492DD035.5020705@oracle.com> <20081127150126.GA20941@srcf.ucam.org> <20081127150341.GB20941@srcf.ucam.org> <20081127160353.GQ2961@nb.net.home> <492ED945.5010600@draigBrady.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <492ED945.5010600@draigBrady.com>
User-Agent: Mutt/1.5.12-2006-07-14
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@codon.org.uk
X-SA-Exim-Scanned: No (on vavatch.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 27, 2008 at 05:30:45PM +0000, Pádraig Brady wrote:
> Karel Zak wrote:
> > On Thu, Nov 27, 2008 at 03:03:41PM +0000, Matthew Garrett wrote:
> >> Also add a MS_NORELATIME mount option
> > [...]
> >> +#define MS_NORELATIME	(1<<24)	/* Disable relatime even if the default */
> > 
> >  CC: util-linux-ng@vger.kernel.org
> 
> That's useful. Without this, to disable relatime you needed to:
> 
> echo 0 > /proc/sys/fs/default_relatime
> mount -o remount,atime /mnt/point/

I'm dropping that hunk - it's easier to default to relatime in 
userspace, so there's no need to have a kernel fs parameter to forcibly 
disable it.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
