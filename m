Return-Path: <linux-kernel-owner+w=401wt.eu-S1758587AbXI3RxP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758587AbXI3RxP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Sep 2007 13:53:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757448AbXI3RxA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 30 Sep 2007 13:53:00 -0400
Received: from nz-out-0506.google.com ([64.233.162.235]:5393 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757345AbXI3Rw7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Sep 2007 13:52:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=oHup35OG4txFhqDdFYgzKx+AKtJgodnGYZCVY46lrfIY/53T1kfru/G/Ce+m1QrbinXQIYa9PEDMMw/vZz5ZYfKdw4pqzTf7YxRBtXhdK2TLkBOcWpEvP6Q1knkqqaqf8PBgBQXxB1DGM4uIKWlbdpO14qreJp5y+l+TB0B6HFY=
Message-ID: <46FFE218.5000607@gmail.com>
Date: Sun, 30 Sep 2007 10:51:20 -0700
From: Tejun Heo <htejun@gmail.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070728)
MIME-Version: 1.0
To: Mark Lord <lkml@rtr.ca>
CC: Mark Lord <liml@rtr.ca>, Jeff Garzik <jeff@garzik.org>,
       Paolo Ornati <ornati@fastwebnet.it>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-ide@vger.kernel.org
Subject: Re: [PATCH] blacklist NCQ on Seagate Barracuda ST380817AS
References: <20070930160548.235be972@localhost>	<20070930152908.1f58d39d@the-village.bc.nu> <20070930164610.20818867@localhost> <46FFBB2D.6060004@garzik.org> <46FFDC5A.7070509@rtr.ca> <46FFDCE5.4060900@gmail.com> <46FFE047.7030102@rtr.ca>
In-Reply-To: <46FFE047.7030102@rtr.ca>
X-Enigmail-Version: 0.95.3
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Mark Lord wrote:
> Tejun Heo wrote:
>> Mark Lord wrote:
>> If there was such a bug, the aborted commands list should contain both
>> FPDMA commands and FLUSH commands.  I don't think command filtering
>> itself is broken.  Possibly another quirky firmware but it's strange
>> that this is the only Seagate drive showing this problem.
> 
> Yeah, that's the strange bit.
> 
> Surely someone at SuSE must have a drive like that,
> which they could set up with XFS and reproduce the same results?

I wish we had a detailed hardware catalog.  I'll give a shot at the
internal mailing list.

Thanks.

-- 
tejun
