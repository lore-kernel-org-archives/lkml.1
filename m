Return-Path: <linux-kernel-owner+w=401wt.eu-S1755162AbZC1Nsr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755162AbZC1Nsr (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Mar 2009 09:48:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753674AbZC1Nse
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Mar 2009 09:48:34 -0400
Received: from mu-out-0910.google.com ([209.85.134.186]:20318 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751791AbZC1NsV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Mar 2009 09:48:21 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-disposition:message-id:content-type
         :content-transfer-encoding;
        b=lTSbITElVBtlVurASBv0umEpANHpFFnwUVW8OKyvvIkX+9D0D9NRy3do2Yy1AOpvh+
         cZS0xRWoh6yd0AvF8vsp9Nlyy0dJjUJ+xE3eaRB2n1nxRsC1I3VfrR1AL9AWP0Cb6O7r
         BKWhY8X/MSni6ToOoalhXRQla8pobh+zDMdnM=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCHSET pata-2.6] ide: rq->buffer, data, special and misc cleanups
Date: Sat, 28 Mar 2009 14:51:01 +0100
User-Agent: KMail/1.11.1 (Linux/2.6.29-next-20090327-dirty; KDE/4.2.1; i686; ; )
Cc: linux-kernel@vger.kernel.org, axboe@kernel.dk, linux-ide@vger.kernel.org,
       Borislav Petkov <petkovbb@googlemail.com>
References: <1237910776-10983-1-git-send-email-tj@kernel.org>
In-Reply-To: <1237910776-10983-1-git-send-email-tj@kernel.org>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200903281451.01361.bzolnier@gmail.com>
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi,

On Tuesday 24 March 2009, Tejun Heo wrote:
> Hello, Bartlomiej, Jens.
> 
> This patchset contains mostly IDE cleanups around rq->buffer, data and
> special usage.  Over time, the meanings of those three fields became
> blurry.  Be default, they mean

[...]

> Bartlomiej, if you're okay with the changes and Jens acks the patches
> and pushing the first three patches via pata-2.6, please feel free to
> include these patches into your tree.

Everything looks fine to me.  Once I get Jens' ack (block bits)
and Borislav's one (ATAPI bits) I'll happily merge this patchset.

Thanks,
Bart
