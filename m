Return-Path: <linux-kernel-owner+w=401wt.eu-S1757721AbYBPWGW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757721AbYBPWGW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Feb 2008 17:06:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751720AbYBPWGQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 Feb 2008 17:06:16 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:56929 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750797AbYBPWGP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Feb 2008 17:06:15 -0500
Date: Sat, 16 Feb 2008 14:05:58 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Daniel Drake <dsd@gentoo.org>
Cc: Greg KH <greg@kroah.com>, linux kernel list <linux-kernel@vger.kernel.org>,
       matthew@wil.cx, andreas.eckstein@gmx.net,
       Ivan Kokshaysky <ink@jurassic.park.msu.ru>
Subject: Re: pci-disable-decoding-during-sizing-of-bars.patch no longer
 needed
Message-Id: <20080216140558.b986c56d.akpm@linux-foundation.org>
In-Reply-To: <47B75ABB.8000005@gentoo.org>
References: <47B75ABB.8000005@gentoo.org>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 16 Feb 2008 21:50:51 +0000 Daniel Drake <dsd@gentoo.org> wrote:

> Hi,
> 
> The patch titled pci-disable-decoding-during-sizing-of-bars.patch in -mm 
> was previously used as a candidate to fix a boot hang with Intel's Q35 
> chipset: https://bugs.gentoo.org/show_bug.cgi?id=198810
> 
> However, that particular issue is solved by commit a0ca9909609 in Linus 
> tree:
> 	PCI x86: always use conf1 to access config space below 256 bytes
> 
> So unless there are other reasons for keeping 
> pci-disable-decoding-during-sizing-of-bars around, I think we can drop it.
> 

Great, thanks for letting me know.
