Return-Path: <linux-kernel-owner+w=401wt.eu-S1754600AbYJ1Vn4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754600AbYJ1Vn4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2008 17:43:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754099AbYJ1Vni
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Oct 2008 17:43:38 -0400
Received: from casper.infradead.org ([85.118.1.10]:50804 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753738AbYJ1Vng (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2008 17:43:36 -0400
Date: Tue, 28 Oct 2008 14:44:01 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: Andreas Dilger <adilger@sun.com>
Cc: Josef Bacik <jbacik@redhat.com>, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
       rwheeler@redhat.com
Subject: Re: [PATCH] improve jbd fsync batching
Message-ID: <20081028144401.07b7546d@infradead.org>
In-Reply-To: <20081028213805.GC3184@webber.adilger.int>
References: <20081028201614.GA21600@unused.rdu.redhat.com>
	<20081028213805.GC3184@webber.adilger.int>
Organization: Intel
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.12; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 28 Oct 2008 15:38:05 -0600
Andreas Dilger <adilger@sun.com> wrote:

> On Oct 28, 2008  16:16 -0400, Josef Bacik wrote:
> > I also have a min() check in there to make sure we don't sleep
> > longer than a jiffie in case our storage is super slow, this was
> > requested by Andrew.
> 
> Is there a particular reason why 1 jiffie is considered the "right
> amount" of time to sleep, given this is a kernel config parameter and
> has nothing to do with the storage?  Considering a seek time in the
> range of ~10ms this would only be right for HZ=100 and the wait would

well... my disk does a 50 usec seek time or so.. so I don't mind ;-)

in fact it sounds awefully long to me.

-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
