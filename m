Return-Path: <linux-kernel-owner+w=401wt.eu-S1753320AbZG0Q7p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753320AbZG0Q7p (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jul 2009 12:59:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752792AbZG0Q7o
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Jul 2009 12:59:44 -0400
Received: from outbound-mail-17.bluehost.com ([69.89.20.232]:34759 "HELO
	outbound-mail-17.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752786AbZG0Q7o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jul 2009 12:59:44 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=FNnEm3ez5CrGGTFfbB1USXxjhgb9geshF9NBce7shz3dRKxQhDBvA0W3nz0e/VdjNgUPARBXF4s1Ugf+N9J3WHo132T3G80l/KVXjyN23sFQ2UENSJMF7PVUUXTEWfVJ;
Date: Mon, 27 Jul 2009 09:59:40 -0700
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Fabio Comolli <fabio.comolli@gmail.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, airlied@linux.ie
Subject: Re: Linux-2.6.31-rc4 - i915 errors
Message-ID: <20090727095940.28a94062@jbarnes-g45>
In-Reply-To: <b637ec0b0907250230q659ea4cckc78e98a778d87207@mail.gmail.com>
References: <b637ec0b0907250230q659ea4cckc78e98a778d87207@mail.gmail.com>
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.17.5; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.28.251 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 25 Jul 2009 11:30:42 +0200
Fabio Comolli <fabio.comolli@gmail.com> wrote:

> Hi.
> At boot time my eeepc says:
> 
> [    0.777082] render error detected, EIR: 0x00000010
> [    0.777086] page table error
> [    0.777089]   PGTBL_ER: 0x00000100
> [    0.777096] [drm:i915_driver_irq_handler] *ERROR* EIR stuck:
> 0x00000010, masking
> [    0.777105] render error detected, EIR: 0x00000010
> [    0.777108] page table error
> [    0.777111]   PGTBL_ER: 0x00000100
> 
> with vanilla 2.6.31-rc4.
> 
> Those lines weren't present with the previous kernels I used
> (2.6.29-stable). Everything works perfectly, actually better than
> ever.

We recently added some error detection & reporting to the driver.  On
some machines it's picking up what I think are errors in the initial
mode programming (possibly by the BIOS), where the display base
pointers are pointing at invalid addresses.  We fix those up shortly
after loading the module so the error should be harmless, but it would
be nice to get rid of it.

-- 
Jesse Barnes, Intel Open Source Technology Center
