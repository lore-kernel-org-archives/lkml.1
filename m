Return-Path: <linux-kernel-owner+w=401wt.eu-S1755676AbZLEOtr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755676AbZLEOtr (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Dec 2009 09:49:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755419AbZLEOtp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 Dec 2009 09:49:45 -0500
Received: from g1t0028.austin.hp.com ([15.216.28.35]:24092 "EHLO
	g1t0028.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754035AbZLEOto (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Dec 2009 09:49:44 -0500
Subject: Re: [PATCH v2] PCI: Always set prefetchable base/limit upper32
 registers
From: Alex Williamson <alex.williamson@hp.com>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: yinghai@kernel.org, linux-pci@vger.kernel.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <20091204160158.1b591cb1@jbarnes-piketon>
References: <20091130214954.10845.23072.stgit@debian.lart>
	 <20091204160158.1b591cb1@jbarnes-piketon>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 05 Dec 2009 07:49:28 -0700
Message-ID: <1260024568.3678.1.camel@2710p.home>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-12-04 at 16:01 -0800, Jesse Barnes wrote:
> On Mon, 30 Nov 2009 14:51:44 -0700
> Alex Williamson <alex.williamson@hp.com> wrote:
> 
> > Prior to 1f82de10 we always initialized the upper 32bits of the
> > prefetchable memory window, regardless of the address range used.
> > Now we only touch it for a >32bit address, which means the upper32
> > registers remain whatever the BIOS initialized them too.
> > 
> > It's valid for the BIOS to set the upper32 base/limit to
> > 0xffffffff/0x00000000, which makes us program prefetchable ranges
> > like 0xffffffffabc00000 - 0x00000000abc00000
> > 
> > Revert the chunk of 1f82de10 that made this conditional so we always
> > write the upper32 registers and remove now unused pref_mem64 variable.
> > 
> > Signed-off-by: Alex Williamson <alex.williamson@hp.com>
> > ---
> > 
> 
> Applied this one, though it looks like your diff had some context that
> wasn't in my tree.  Please double check that I fixed it up correctly.

Yep, looks fine.  Thanks Jesse.

Alex

