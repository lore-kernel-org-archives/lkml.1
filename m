Return-Path: <linux-kernel-owner+w=401wt.eu-S1759502AbYBYUjn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759502AbYBYUjn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Feb 2008 15:39:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757697AbYBYUjd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Feb 2008 15:39:33 -0500
Received: from lazybastard.de ([212.112.238.170]:54566 "EHLO
	longford.lazybastard.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756389AbYBYUjc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Feb 2008 15:39:32 -0500
Date: Mon, 25 Feb 2008 21:38:53 +0100
From: =?utf-8?B?SsO2cm4=?= Engel <joern@logfs.org>
To: Dave McCracken <dave.mccracken@oracle.com>
Cc: Andy Whitcroft <apw@shadowen.org>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org
Subject: Re: Page scan keeps touching kernel text pages
Message-ID: <20080225203852.GA15904@lazybastard.org>
References: <20080224144710.GD31293@lazybastard.org> <20080225185319.GA14699@lazybastard.org> <20080225192127.GA20322@shadowen.org> <200802251346.32289.dave.mccracken@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <200802251346.32289.dave.mccracken@oracle.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 25 February 2008 13:46:32 -0600, Dave McCracken wrote:
> On Monday 25 February 2008, Andy Whitcroft wrote:
> > I thought that init sections were deliberatly pushed to the end of the
> > kernel when linked, cirtainly on my laptop here that seems to be so.
> > That would make the first two "after" the kernel.  The other two appear
> > to be before the traditional kernel load address, which is 0x100000, so
> > those pages are before not in the kernel?
> 
> I believe the memory below the kernel load address on x86 is returned to the 
> free memory pool at some point during boot, which would explain those 
> addresses.

It does explain all pages.  Sorry about the noise from an mm-newbie.

Jörn

-- 
Joern's library part 14:
http://www.sandpile.org/
