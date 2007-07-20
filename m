Return-Path: <linux-kernel-owner+w=401wt.eu-S932153AbXGTHM6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932153AbXGTHM6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jul 2007 03:12:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753428AbXGTHMv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Jul 2007 03:12:51 -0400
Received: from courier.cs.helsinki.fi ([128.214.9.1]:42166 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753805AbXGTHMu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jul 2007 03:12:50 -0400
Date: Fri, 20 Jul 2007 10:12:48 +0300 (EEST)
From: Pekka J Enberg <penberg@cs.helsinki.fi>
To: Roland Dreier <rdreier@cisco.com>
cc: Andi Kleen <ak@suse.de>, Christoph Lameter <clameter@sgi.com>,
       torvalds@osdl.org, linux-kernel@vger.kernel.org,
       "Michael S. Tsirkin" <mst@dev.mellanox.co.il>
Subject: Re: kmalloc zero size changes break i386
In-Reply-To: <adamyxsfmnc.fsf@cisco.com>
Message-ID: <Pine.LNX.4.64.0707201009580.1209@sbz-30.cs.Helsinki.FI>
References: <200707191201.35777.ak@suse.de> <84144f020707190708p1c4d63cnbb0397a602c3527d@mail.gmail.com>
 <adamyxsfmnc.fsf@cisco.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Roland,

On Thu, 19 Jul 2007, Roland Dreier wrote:
> [ 1350.668590] Unable to handle kernel NULL pointer dereference at 0000000000000028 RIP:
> [ 1350.674068]  [<ffffffff8027b373>] __kmalloc+0x51/0xaf

There's some heavy-duty function inlining going on in__kmalloc so could 
you please work out the exact location of the oops as described in 
Documentation/BUG-HUNTING (look for the "use GDB to translate" part).

And to double-check, this is SLAB with CONFIG_DEBUG_SLAB enabled? Do you 
see this with SLUB?

				Pekka
