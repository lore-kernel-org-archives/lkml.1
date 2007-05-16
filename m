Return-Path: <linux-kernel-owner+w=401wt.eu-S1761276AbXEPG6x@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761276AbXEPG6x (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2007 02:58:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759676AbXEPG6p
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 May 2007 02:58:45 -0400
Received: from vervifontaine.sonytel.be ([80.88.33.193]:42874 "EHLO
	vervifontaine.sonycom.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753569AbXEPG6o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2007 02:58:44 -0400
Date: Wed, 16 May 2007 08:58:39 +0200 (CEST)
From: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
To: Christoph Lameter <clameter@sgi.com>
cc: Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Development <linux-kernel@vger.kernel.org>,
       linux-mm@kvack.org, Linux/PPC Development <linuxppc-dev@ozlabs.org>
Subject: Re: Slab allocators: Define common size limitations
In-Reply-To: <Pine.LNX.4.64.0705152313490.5832@schroedinger.engr.sgi.com>
Message-ID: <Pine.LNX.4.62.0705160855470.24080@pademelon.sonytel.be>
References: <Pine.LNX.4.64.0705152313490.5832@schroedinger.engr.sgi.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 15 May 2007, Christoph Lameter wrote:
> So define a common maximum size for kmalloc. For conveniences sake
> we use the maximum size ever supported which is 32 MB. We limit the maximum
> size to a lower limit if MAX_ORDER does not allow such large allocations.

What are the changes a large allocation will actually succeed?
Is there an alignment rule for large allocations?

E.g. for one of the PS3 drivers I need a physically contiguous 256 KiB-aligned
block of 256 KiB. Currently I'm using __alloc_bootmem() for that, but maybe
kmalloc() becomes a suitable alternative now?

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- Sony Network and Software Technology Center Europe (NSCE)
Geert.Uytterhoeven@sonycom.com ------- The Corporate Village, Da Vincilaan 7-D1
Voice +32-2-7008453 Fax +32-2-7008622 ---------------- B-1935 Zaventem, Belgium
