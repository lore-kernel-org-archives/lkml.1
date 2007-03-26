Return-Path: <linux-kernel-owner+w=401wt.eu-S1752216AbXCZLri@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752216AbXCZLri (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Mar 2007 07:47:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752184AbXCZLri
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Mar 2007 07:47:38 -0400
Received: from ojjektum.uhulinux.hu ([62.112.194.64]:39140 "EHLO
	ojjektum.uhulinux.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752109AbXCZLrh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Mar 2007 07:47:37 -0400
X-Greylist: delayed 1567 seconds by postgrey-1.27 at vger.kernel.org; Mon, 26 Mar 2007 07:47:37 EDT
Date: Mon, 26 Mar 2007 13:21:27 +0200
From: Pozsar Balazs <pozsy@uhulinux.hu>
To: Arjan van de Ven <arjan@infradead.org>
Cc: Mike Snitzer <snitzer@gmail.com>, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: forced umount?
Message-ID: <20070326112127.GA3097@ojjektum.uhulinux.hu>
References: <170fa0d20703162106v47dc13e1u1ae5381576f372ed@mail.gmail.com> <1174245379.3538.252.camel@laptopd505.fenrus.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1174245379.3538.252.camel@laptopd505.fenrus.org>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Mar 18, 2007 at 08:16:19PM +0100, Arjan van de Ven wrote:
> On Fri, 2007-03-16 at 23:06 -0500, Mike Snitzer wrote:
> > I'm interested in understanding the state of Linux with regard to
> > _really_ forcing a filesystem to unmount.
> > 
> > There is a (stale) project at OSDL that has various implementations:
> > http://developer.osdl.org/dev/fumount/
> 
> 
> the problem with the people who say they want forced umount is.. that
> most of the time they either want
> 1) get rid of the namespace entry
> or
> 2) want to stop any and all IO to a certain device/partition 
> 
> 1) is already supported with lazy umount (umount -l)
> for 2), it's not forced umount that they want, it's really an IO
> disconnect (which scsi supports btw in 2.6 kernels).


Could please tell me more about this IO disconnect?
How to trigger it etc, any pointers welcome.


thanks,
-- 
pozsy
