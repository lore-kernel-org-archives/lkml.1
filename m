Return-Path: <linux-kernel-owner+w=401wt.eu-S1754840Ab0AEX7V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754840Ab0AEX7V (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jan 2010 18:59:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753326Ab0AEX7U
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Jan 2010 18:59:20 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40919 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752914Ab0AEX7U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jan 2010 18:59:20 -0500
Date: Tue, 5 Jan 2010 15:59:00 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Cc: Debora Velarde <debora@linux.vnet.ibm.com>,
       Rajiv Andrade <srajiv@linux.vnet.ibm.com>,
       Marcel Selhorst <m.selhorst@sirrix.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] tpm_infineon: Fix suspend/resume handler for pnp_driver
Message-Id: <20100105155900.7cf92358.akpm@linux-foundation.org>
In-Reply-To: <87d41xu18p.fsf@devron.myhome.or.jp>
References: <87d41xu18p.fsf@devron.myhome.or.jp>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 30 Dec 2009 02:41:10 +0900
OGAWA Hirofumi <hirofumi@mail.parknet.co.jp> wrote:

> Hi,
> 
> With recent quick review, I found the bug of tpm_infineon. (I don't have
> this device, and compile test only)
> 

hm.  What bug?  Is there a bugzilla reference, or do you have a
description of that bug?  Perhaps the device is not functional after
suspend/resume?

This matters because people who are experiencing problems with this
device will want to know whether this patch is likely to fix them
(although that'll be pretty obvious in this case).

It also matters because people (ie: me) will want to know whether the
bug is sufficiently serious to warrant backporting the fix into earlier
-stable kernels.

Is the patch actually needed in earlier kernels?  It applies cleanly. 
When did this pnp_driver->suspend/resume requirement come about?

> PNP driver must use pnp_driver->suspend/resume anymore.

I assume this text should have read "PNP driver must use
pnp_driver->suspend/resume.".


