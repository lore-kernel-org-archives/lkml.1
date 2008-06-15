Return-Path: <linux-kernel-owner+w=401wt.eu-S1757653AbYFOKVo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757653AbYFOKVo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Jun 2008 06:21:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757068AbYFOKVe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Jun 2008 06:21:34 -0400
Received: from fk-out-0910.google.com ([209.85.128.191]:41361 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757022AbYFOKVd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Jun 2008 06:21:33 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=date:to:cc:subject:message-id:reply-to:mail-followup-to:references
         :mime-version:content-type:content-disposition:in-reply-to
         :user-agent:from;
        b=cojq6MdENlD1ZBOWYkZIitRbUdA6rpf+kqTGUplUCOec9AwJ+DIFphEH1p17YFwll0
         HRhHekYQumV6q6TNceXRupOrDSSW2VKiEvRIj0KHMc/tmCWRO0J1b8mAZJOCuK/mtVUT
         lCgUuuN3rlPj6GO3zZ+u0QJsh2ZvqJe7ujEpo=
Date: Sun, 15 Jun 2008 12:21:24 +0200
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org
Subject: Re: [PATCH 13/18] ide-floppy: replace pc->c with rq->cmd
Message-ID: <20080615102124.GB7622@gollum.tnic>
Reply-To: petkovbb@gmail.com
Mail-Followup-To: petkovbb@gmail.com,
	Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
	linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org
References: <1213252870-20474-1-git-send-email-petkovbb@gmail.com> <1213252870-20474-14-git-send-email-petkovbb@gmail.com> <200806141940.22838.bzolnier@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200806141940.22838.bzolnier@gmail.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
From: Borislav Petkov <petkovbb@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jun 14, 2008 at 07:40:22PM +0200, Bartlomiej Zolnierkiewicz wrote:
> On Thursday 12 June 2008, Borislav Petkov wrote:
> > This is the first one in the series attempting to phase out ide_atapi_pc and use
> > block request structs. Also, the pc request type is now REQ_TYPE_BLOCK_PC. As a result,
> > idefloppy_blockpc_cmd becomes unused and can go.
> 
> Do not attack too many dragons at once or they will slay you... ;)
> 
> IOW this patch mixes too many changes (some _really_ non-trivial)
> in one go which results in rather bad outcome...

yeah, this was more of a RFC patch for me not intended in any way for submission
but instead to get your comments on it. Atapi-land is full of surprises and you
have to be _really_ careful when changing stuff around. I got bitten by that
couple times when preparing those patches. Anyways, don't take those seriously,
they were simply a warmup :).

Thanks,
Boris.
