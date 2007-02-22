Return-Path: <linux-kernel-owner+w=401wt.eu-S1751965AbXBVV5l@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751965AbXBVV5l (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Feb 2007 16:57:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751970AbXBVV5k
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Feb 2007 16:57:40 -0500
Received: from smtp.osdl.org ([65.172.181.24]:40353 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751965AbXBVV5i (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Feb 2007 16:57:38 -0500
Date: Thu, 22 Feb 2007 13:57:19 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Kumar Gala <galak@kernel.crashing.org>
Cc: stern@rowland.harvard.edu, hirofumi@mail.parknet.co.jp,
       linux-usb-devel@lists.sourceforge.net, zaitcev@redhat.com,
       gregkh@suse.de, linux-kernel@vger.kernel.org
Subject: Re: [linux-usb-devel] 2.6.20 kernel hang with USB drive and vfat
 doing ftruncate
Message-Id: <20070222135719.fb35535a.akpm@linux-foundation.org>
In-Reply-To: <0305C117-1099-49EA-B0F3-C0E31E18A19A@kernel.crashing.org>
References: <20070221125736.e5ff4206.akpm@linux-foundation.org>
	<Pine.LNX.4.44L0.0702211621310.3435-100000@iolanthe.rowland.org>
	<20070221133112.aec2bdac.akpm@linux-foundation.org>
	<F2C532BC-C83A-4DD5-BACE-49F8CC11236C@kernel.crashing.org>
	<0305C117-1099-49EA-B0F3-C0E31E18A19A@kernel.crashing.org>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.19; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> On Thu, 22 Feb 2007 12:20:06 -0600 Kumar Gala <galak@kernel.crashing.org> wrote:
> +       if ((gfp_mask & (__GFP_FS|__GFP_IO)) != (__GFP_FS|__GFP_IO)) {
> 
> The second seems to make more sense.  I tested with the first last  
> night which didn't help.
> 
> With the proper patch in place things look good.  Is this a candidate  
> for 2.6.20-stable?

I suppose so, yes.
