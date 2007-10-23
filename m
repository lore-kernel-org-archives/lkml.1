Return-Path: <linux-kernel-owner+w=401wt.eu-S1752637AbXJWFdm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752637AbXJWFdm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2007 01:33:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751363AbXJWFde
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Oct 2007 01:33:34 -0400
Received: from wa-out-1112.google.com ([209.85.146.182]:38720 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750852AbXJWFde (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2007 01:33:34 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=t2xTCdkYeZ8Bj2mfunRQyy0Z38d/agdFqGPHXu6FNN8qmRlKzwmEBG50Ete52hndYC56ut2TVQZA9Snk3gRUPpD0GitGkJE+y4aN935691jaFH6C8cva0Ba/5vll6Hticj2tHxBerJZnzTVluQrIF/hCp4AbSKkcs99ECNlIWMw=
Message-ID: <de4d25e80710222233l21e93909u373a58b780b526b7@mail.gmail.com>
Date: Tue, 23 Oct 2007 11:03:33 +0530
From: Shreyansh <shreyansh.jain@gmail.com>
To: "Boaz Harrosh" <bharrosh@panasas.com>
Subject: Re: Query about Bio submission / Direct IO
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <471C8114.7020702@panasas.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <loom.20071019T055230-553@post.gmane.org>
	 <471C8114.7020702@panasas.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi list and Boaz,

On 10/22/07, Boaz Harrosh <bharrosh@panasas.com> wrote:
> On Fri, Oct 19 2007 at 8:17 +0200, Shreyansh Jain <shreyansh.jain@gmail.com> wrote:
> > Hi List,
> >
-------8<---------
> > Any idea why it doesn't work (though I am expecting that this doc is 2.6
> > starting era and things might have changed a lot now).
> >
> > Any help would be highly appreciated. Apologies if my channel of approach is
> > wrong and if this post is huge (couldn't keep it shorter than this).
> >
> > Shreyansh
> >
> >
> > [PS: Is this situation something to do with request flags REQ_PC /
> > REQ_BLOCK_PC?? While searching code, I found these somewhere connected to
> > direct IO (bio_add_pc_page) and could find more about them]
> >
----------8<----------
> > -
>
> There was a related fix to a similar problem by Mike Christie, in resent
> Kernels, If there is no chance for you working on newer kernels, than you
> will have to back port it.
>
> it is:
> commit bd441deaf341c524b28fd72831ebf6fef88f1c41
> Author: Mike Christie <michaelc@cs.wisc.edu>
> Date:   Tue Mar 13 12:52:29 2007 -0500

Thanks a lot for pointing that out to me. I will have a look at that.

>
>     [SCSI] fix write buffer length in scsi_req_map_sg()
>
>
> look it up the git trees on kernel.org

Certainly I will do that :) ... Thanks

>
> Boaz
>

Shreyansh
