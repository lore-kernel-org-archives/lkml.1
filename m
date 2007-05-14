Return-Path: <linux-kernel-owner+w=401wt.eu-S1760399AbXENUf7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760399AbXENUf7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2007 16:35:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758153AbXENUfu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 May 2007 16:35:50 -0400
Received: from an-out-0708.google.com ([209.85.132.247]:24173 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758747AbXENUft (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2007 16:35:49 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:sender:to:subject:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=mRBn0zV334xtivlLBOHHiZ8FVyms1O5xyWyYJvLO2UzE59yvMkx9i0KpwjSHs5aSsqLQfniFLDEqK6/YiVZxJ5OaeM5PEkCqBFF6LV8PGBzbH0XbOX5VfeYONzm0lIJykaGqNZQvRmGr8tC2blcS53fEKxuxMZQA/97NMi39400=
Message-ID: <4de7f8a60705141335m7214e8e9k9f96244738dd2b4@mail.gmail.com>
Date: Mon, 14 May 2007 22:35:47 +0200
From: "Jan Blunck" <jblunck@suse.de>
To: "Bharata B Rao" <bharata@linux.vnet.ibm.com>, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, "Jan Blunck" <j.blunck@tu-harburg.de>,
       "Theodore Ts'o" <tytso@mit.edu>
Subject: Re: [RFC][PATCH 13/14] ext3 whiteout support
In-Reply-To: <20070514201706.GD5286@schatzie.adilger.int>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070514093722.GB4139@in.ibm.com>
	 <20070514094450.GO4139@in.ibm.com>
	 <20070514201706.GD5286@schatzie.adilger.int>
X-Google-Sender-Auth: 1ee39538a46e5471
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/14/07, Andreas Dilger <adilger@clusterfs.com> wrote:
> On May 14, 2007  15:14 +0530, Bharata B Rao wrote:
> >  #define EXT3_FEATURE_INCOMPAT_JOURNAL_DEV    0x0008 /* Journal device */
> >  #define EXT3_FEATURE_INCOMPAT_META_BG                0x0010
> > +#define EXT3_FEATURE_INCOMPAT_WHITEOUT               0x0020
>
> Is this flag reserved with Ted?  It isn't listed in the e2fsprogs repo.
>

I don't know. I tried to contact him a few weeks ago but failed.
Guess, maybe he isn't reading the @thunk.org email anymore which was
reference in the e2fsprogs source I used.

Ted,
from ext2_fs.h I learn that the value 0x0020 is left unused.

#define EXT2_FEATURE_INCOMPAT_META_BG           0x0010
#define EXT3_FEATURE_INCOMPAT_EXTENTS           0x0040
#define EXT4_FEATURE_INCOMPAT_64BIT             0x0080

Is this intentionally?

Cheers,
Jan
