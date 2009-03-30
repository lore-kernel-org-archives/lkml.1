Return-Path: <linux-kernel-owner+w=401wt.eu-S1754731AbZC3OrT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754731AbZC3OrT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Mar 2009 10:47:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751977AbZC3OrE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Mar 2009 10:47:04 -0400
Received: from mail-fx0-f158.google.com ([209.85.220.158]:64769 "EHLO
	mail-fx0-f158.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751327AbZC3OrC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Mar 2009 10:47:02 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-disposition:message-id:content-type
         :content-transfer-encoding;
        b=oqYhwNwcMyLr+sz/oQZ9H9iHTLMUsTMVwSedRqwQ0kpKLEF8kYVbE08UavrjtWo8Iq
         TDZeZQoaxHJ34fBUqJlbUzAvSLMybC8cpMUIfpV0SIXtf/Bn5Ah5uVIlv5+3TBcO8Y37
         g+LzW3668hjyXfV09iWGiMlpWtNjBeWYLuq7Q=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCHSET pata-2.6] ide: rq->buffer, data, special and 
 =?utf-8?q?misc=09cleanups?=
Date: Mon, 30 Mar 2009 16:50:11 +0200
User-Agent: KMail/1.11.1 (Linux/2.6.29-next-20090327-dirty; KDE/4.2.1; i686; ; )
Cc: petkovbb@gmail.com, linux-kernel@vger.kernel.org, axboe@kernel.dk,
       linux-ide@vger.kernel.org, Boaz Harrosh <bharrosh@panasas.com>
References: <1237910776-10983-1-git-send-email-tj@kernel.org> <20090328140405.GA2741@liondog.tnic> <49D08CEC.3010705@kernel.org>
In-Reply-To: <49D08CEC.3010705@kernel.org>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200903301650.11429.bzolnier@gmail.com>
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 30 March 2009, Tejun Heo wrote:
> Borislav Petkov wrote:
> > On Sat, Mar 28, 2009 at 02:51:01PM +0100, Bartlomiej Zolnierkiewicz wrote:
> > 
> > [..]
> > 
> >>> Bartlomiej, if you're okay with the changes and Jens acks the patches
> >>> and pushing the first three patches via pata-2.6, please feel free to
> >>> include these patches into your tree.
> >> Everything looks fine to me.  Once I get Jens' ack (block bits)
> >> and Borislav's one (ATAPI bits) I'll happily merge this patchset.
> > 
> > Yep, I just finished testing the whole series here so you can go ahead
> > and apply them pending a recast of patch 07/14 you'll hopefully be
> > receiving soon from Tejun.
> 
> After the earlier discussion with Boaz Harrosh, I ended up redoing the
> blk_rq_map_{kern|user}_*() stuff and am now in the process of testing
> it.  The patchset is rather large (20+ patches).  As the prealloc
> patch would fit on top of that series, I think it would be better to
> sequence things via git merge.  Is there a git tree I can use for
> pata-2.6 changes?  Or is the current linus master okay?

Not yet, we discussed this two weeks ago and the only thing that changed
in the meantime is that we are in the merge window now and I'm ultra busy
instead of being just really busy.  Do not worry though -- your last two
patchsets are a very good motivator for quilt->git conversion (much better
than i.e. some unproductive preaching).

Thanks,
Bart
