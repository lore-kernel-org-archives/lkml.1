Return-Path: <linux-kernel-owner+w=401wt.eu-S1753675AbYJTQdp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753675AbYJTQdp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2008 12:33:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752357AbYJTQda
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Oct 2008 12:33:30 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:58909 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752139AbYJTQda (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2008 12:33:30 -0400
Date: Mon, 20 Oct 2008 12:33:27 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Alexander Beregalov <a.beregalov@gmail.com>
Cc: Arjan van de Ven <arjan@infradead.org>,
       Christoph Hellwig <hch@infradead.org>, xfs@oss.sgi.com,
       linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: BUG: sleeping function called from invalid context at
	kernel/rwsem.c:131 XFS? (was: Re: linux-next: Tree for October 17)
Message-ID: <20081020163327.GA15651@infradead.org>
References: <a4423d670810170543vd6b4c39p44bf125610d8540@mail.gmail.com> <20081017164116.GA17375@infradead.org> <a4423d670810170954h7ca130aaw8895380a4c6b125@mail.gmail.com> <20081017165738.GA20818@infradead.org> <a4423d670810171013g5bc19c1cm3f7d9c014ee70349@mail.gmail.com> <20081017203710.GA27187@infradead.org> <20081017135510.7127c4e7@infradead.org> <a4423d670810200758m3cea3841h40988afc8eaf81@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a4423d670810200758m3cea3841h40988afc8eaf81@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 20, 2008 at 06:58:09PM +0400, Alexander Beregalov wrote:
> Hi Christoph
> 
> I have the same result with next-1020 and today's xfs-2.6.git/master
> (
> commit bfd2bd10da76378dc4afd87d7d204a1d3d70b347
> Author: David Chinner <david@fromorbit.com>
> Date:   Fri Oct 17 15:36:23 2008 +1000
>     Inode: Allow external list initialisation
> )
> 
> Should I start bisecting?

That would be extremely helpful! 


And as mentioned in the other mail I still can't reproduce it, but I can
currently only test on x86-32, not x86-64.
