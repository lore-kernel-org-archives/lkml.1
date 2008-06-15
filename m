Return-Path: <linux-kernel-owner+w=401wt.eu-S1758738AbYFOO5a@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758738AbYFOO5a (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Jun 2008 10:57:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758146AbYFOO5U
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Jun 2008 10:57:20 -0400
Received: from yw-out-2324.google.com ([74.125.46.29]:28059 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758095AbYFOO5T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Jun 2008 10:57:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-disposition:message-id:content-type
         :content-transfer-encoding;
        b=N3xbKWqC80jy1kqs0qN6t4Z7tYzQdA0xIidHSW8udpAGRQNGkNBmCNnDus3aD2Irfy
         HbkJyBeRof2B56k6M32qPjbaf3Awl5e5UF1blPgz5mvy8kjmV8Tt2UqUfbInGjPxfmtE
         FefCamWKvDFXDHSycbC2RAm0I9A3p9Ju4Dyq8=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: petkovbb@gmail.com
Subject: Re: [PATCH 13/18] ide-floppy: replace pc->c with rq->cmd
Date: Sun, 15 Jun 2008 16:57:49 +0200
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org
References: <1213252870-20474-1-git-send-email-petkovbb@gmail.com> <200806141940.22838.bzolnier@gmail.com> <20080615102124.GB7622@gollum.tnic>
In-Reply-To: <20080615102124.GB7622@gollum.tnic>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200806151657.49843.bzolnier@gmail.com>
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 15 June 2008, Borislav Petkov wrote:
> On Sat, Jun 14, 2008 at 07:40:22PM +0200, Bartlomiej Zolnierkiewicz wrote:
> > On Thursday 12 June 2008, Borislav Petkov wrote:
> > > This is the first one in the series attempting to phase out ide_atapi_pc and use
> > > block request structs. Also, the pc request type is now REQ_TYPE_BLOCK_PC. As a result,
> > > idefloppy_blockpc_cmd becomes unused and can go.
> > 
> > Do not attack too many dragons at once or they will slay you... ;)
> > 
> > IOW this patch mixes too many changes (some _really_ non-trivial)
> > in one go which results in rather bad outcome...
> 
> yeah, this was more of a RFC patch for me not intended in any way for submission
> but instead to get your comments on it. Atapi-land is full of surprises and you
> have to be _really_ careful when changing stuff around. I got bitten by that
> couple times when preparing those patches. Anyways, don't take those seriously,
> they were simply a warmup :).

I'm not worried at all - I'm sure that if you keep fighting these dragons
one by one they won't stand a chance... :)
