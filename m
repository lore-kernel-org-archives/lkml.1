Return-Path: <linux-kernel-owner+w=401wt.eu-S932116AbXIUVCR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932116AbXIUVCR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2007 17:02:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764321AbXIUUte
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Sep 2007 16:49:34 -0400
Received: from e2.ny.us.ibm.com ([32.97.182.142]:44108 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1764318AbXIUUtc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2007 16:49:32 -0400
Date: Fri, 21 Sep 2007 15:49:35 -0500
From: "Jose R. Santos" <jrs@us.ibm.com>
To: Badari Pulavarty <pbadari@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       ext4 <linux-ext4@vger.kernel.org>, lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] ext4: FLEX_BG Kernel support v2.
Message-ID: <20070921154935.0b16c5ca@gara>
In-Reply-To: <1190406567.13955.1.camel@dyn9047017100.beaverton.ibm.com>
References: <20070921140649.4352.30055.stgit@toolssf2>
	<1190406567.13955.1.camel@dyn9047017100.beaverton.ibm.com>
X-Mailer: Claws Mail 3.0.1 (GTK+ 2.10.11; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 21 Sep 2007 13:29:27 -0700
Badari Pulavarty <pbadari@gmail.com> wrote:

> On Fri, 2007-09-21 at 09:06 -0500, Jose R. Santos wrote:
> > From: Jose R. Santos <jrs@us.ibm.com>
> > 
> > ext4: FLEX_BG Kernel support v2.
> > 
> 
> > @@ -702,13 +702,15 @@ static inline int ext4_valid_inum(struct super_block *sb, unsigned long ino)
> >  #define EXT4_FEATURE_INCOMPAT_META_BG		0x0010
> >  #define EXT4_FEATURE_INCOMPAT_EXTENTS		0x0040 /* extents support */
> >  #define EXT4_FEATURE_INCOMPAT_64BIT		0x0080
> > +#define EXT4_FEATURE_INCOMPAT_FLEX_BG		0x0200
> 
> Any reason why 0x100 is skipped ?
> 
> Thanks,
> Badari
> 

Because 0x0100 is reserved for EXT4_FEATURE_INCOMPAT_MMP in e2fsprogs.

-JRS
