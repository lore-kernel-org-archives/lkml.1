Return-Path: <linux-kernel-owner+w=401wt.eu-S1755310AbXD0EwO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755310AbXD0EwO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2007 00:52:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755312AbXD0EwO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Apr 2007 00:52:14 -0400
Received: from courier.cs.helsinki.fi ([128.214.9.1]:40816 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755310AbXD0EwN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2007 00:52:13 -0400
Date: Fri, 27 Apr 2007 07:52:11 +0300 (EEST)
From: Pekka J Enberg <penberg@cs.helsinki.fi>
To: Nigel Cunningham <nigel@nigel.suspend2.net>
cc: Linus Torvalds <torvalds@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: Back to the future.
In-Reply-To: <1177617379.4737.29.camel@nigel.suspend2.net>
Message-ID: <Pine.LNX.4.64.0704270750320.13539@sbz-30.cs.Helsinki.FI>
References: <1177567481.5025.211.camel@nigel.suspend2.net> 
 <84144f020704260028q190fc90fs8f9ea703e42e7910@mail.gmail.com> 
 <1177573348.5025.224.camel@nigel.suspend2.net> 
 <alpine.LFD.0.98.0704260941310.9964@woody.linux-foundation.org>
 <1177617379.4737.29.camel@nigel.suspend2.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2007-04-26 at 09:56 -0700, Linus Torvalds wrote:
> >    which will map in the snapshot, return the mapped address and the size 
> >    (and if you want to support snapshots > 4GB, be my guest, but I suspect 
> >    you're actually *better* off just admitting that if you cannot shrink 
> >    the snapshot to less than 32 bits, it's not worth doing)
 
On Fri, 27 Apr 2007, Nigel Cunningham wrote:
> That inherently limits the image to half of available ram (you need
> somewhere to store the snapshot), so you won't get the full image you
> express interest in below.

It doesn't. We can make the userspace mapped pages copy-on-write. As long 
as the userspace makes sure there's not much activity during 
snapshot/shutdown, we will be fine. What we probably do need to copy is 
kernel pages.

			Pekka
