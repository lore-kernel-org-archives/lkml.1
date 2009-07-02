Return-Path: <linux-kernel-owner+w=401wt.eu-S1755608AbZGBVZu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755608AbZGBVZu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jul 2009 17:25:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754401AbZGBVZm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Jul 2009 17:25:42 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:42388 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754261AbZGBVZm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jul 2009 17:25:42 -0400
Date: Thu, 2 Jul 2009 22:27:04 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: "Doug Graham" <dgraham@nortel.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: V3 minixfs bug
Message-ID: <20090702222704.15305c09@lxorguk.ukuu.org.uk>
In-Reply-To: <4A4D2306.2000208@nortel.com>
References: <4A4D2306.2000208@nortel.com>
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 02 Jul 2009 17:13:42 -0400
"Doug Graham" <dgraham@nortel.com> wrote:

> Is anybody interested in bugs in the minixfs V3 support that probably
> only turn up on big-endian machines, or on filesystems with more than
> 64K inodes?

If you've found them then yes.

> The problem is that that there are a few places (three that I've found)
> where the "inode" field of a minix_dir_entry is used without checking
> first to see if the dirent is really a minix3_dir_entry.  The inode number
> in a V1/V2 dirent is 16 bits, whereas that in a V3 dirent is 32 bits.  
> Accessing
> it as a 16 bit field when it really should be accessed as a 32 bit field
> probably kinda sorta works on a little-endian machine, but leads to some
> rather odd behaviour on big-endian machines.
> 
> Here's a patch:

The one thing this needs for application is a Signed-off-by: line (see
Documentation/SubmittingPatches). 

Alan
