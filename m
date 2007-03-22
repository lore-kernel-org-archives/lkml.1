Return-Path: <linux-kernel-owner+w=401wt.eu-S932456AbXCVNwo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932456AbXCVNwo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Mar 2007 09:52:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932536AbXCVNwn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Mar 2007 09:52:43 -0400
Received: from pfx2.jmh.fr ([194.153.89.55]:50993 "EHLO pfx2.jmh.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932456AbXCVNwn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Mar 2007 09:52:43 -0400
Date: Thu, 22 Mar 2007 14:52:45 +0100
From: Eric Dumazet <dada1@cosmosbay.com>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: Tomas M <tomas@slax.org>, linux-kernel@vger.kernel.org
Subject: Re: max_loop limit
Message-Id: <20070322145245.a49fefeb.dada1@cosmosbay.com>
In-Reply-To: <20070322134230.GP19922@kernel.dk>
References: <460236CE.1030303@slax.org>
	<20070322110058.GB23664@tatooine.rebelbase.local>
	<46026A92.4020106@slax.org>
	<20070322144210.73dfaf83.dada1@cosmosbay.com>
	<20070322134230.GP19922@kernel.dk>
X-Mailer: Sylpheed 2.3.1 (GTK+ 2.10.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 22 Mar 2007 14:42:31 +0100
Jens Axboe <jens.axboe@oracle.com> wrote:


> > This time, you would be limited to 16384 loop devices on x86_64, 32768 on i386 :)
> 
> But this still wastes memory, why not just allocate each loop device
> dynamically when it is set up? The current approach is crap, it is just
> wasting memory for loop devices, queues, etc.
> 

Sure, but it's the first Tomas patch :)

Apparently the 'current crap' didnt caugth someone else attention.
