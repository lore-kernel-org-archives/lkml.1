Return-Path: <linux-kernel-owner+w=401wt.eu-S933577AbXGTHS7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933577AbXGTHS7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jul 2007 03:18:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759613AbXGTHSv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Jul 2007 03:18:51 -0400
Received: from courier.cs.helsinki.fi ([128.214.9.1]:58644 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759307AbXGTHSu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jul 2007 03:18:50 -0400
Date: Fri, 20 Jul 2007 10:18:49 +0300 (EEST)
From: Pekka J Enberg <penberg@cs.helsinki.fi>
To: Roland Dreier <rdreier@cisco.com>
cc: Andi Kleen <ak@suse.de>, Christoph Lameter <clameter@sgi.com>,
       torvalds@osdl.org, linux-kernel@vger.kernel.org,
       "Michael S. Tsirkin" <mst@dev.mellanox.co.il>
Subject: Re: kmalloc zero size changes break i386
In-Reply-To: <Pine.LNX.4.64.0707201009580.1209@sbz-30.cs.Helsinki.FI>
Message-ID: <Pine.LNX.4.64.0707201017450.1209@sbz-30.cs.Helsinki.FI>
References: <200707191201.35777.ak@suse.de> <84144f020707190708p1c4d63cnbb0397a602c3527d@mail.gmail.com>
 <adamyxsfmnc.fsf@cisco.com> <Pine.LNX.4.64.0707201009580.1209@sbz-30.cs.Helsinki.FI>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 20 Jul 2007, Pekka J Enberg wrote:
> There's some heavy-duty function inlining going on in__kmalloc so could 
> you please work out the exact location of the oops as described in 
> Documentation/BUG-HUNTING (look for the "use GDB to translate" part).

And, of course, please check if a5c96d8a1c67f31ef48935a78da2d2076513842b 
fixes it.

				Pekka
