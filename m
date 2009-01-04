Return-Path: <linux-kernel-owner+w=401wt.eu-S1760664AbZADTvk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760664AbZADTvk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Jan 2009 14:51:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758709AbZADTvc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Jan 2009 14:51:32 -0500
Received: from ug-out-1314.google.com ([66.249.92.174]:22635 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758697AbZADTvb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Jan 2009 14:51:31 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references:x-google-sender-auth;
        b=Txx+A212MOZK3+N6tlnQJNZKJH24mcS5N1Ax72w+z4m9NYBBrc3lJ9BrKRxY+CrEVi
         8/beMT0kHUFtHKsNY3L8iMCCd1+QQmsls0j3WFauV2yGNOVUc9tGVp8EF533XRbDz11U
         Ut6nEA96z11cbxYWpiuU2gLXh/BeaEMf+Pj44=
Message-ID: <e9e943910901041151x4f251224w63df1e6237ec48cb@mail.gmail.com>
Date: Sun, 4 Jan 2009 19:51:27 +0000
From: "Duane Griffin" <duaneg@dghda.com>
To: "Theodore Tso" <tytso@mit.edu>,
       "Geert Uytterhoeven" <geert@linux-m68k.org>,
       "Duane Griffin" <duaneg@dghda.com>, Valdis.Kletnieks@vt.edu,
       "=?WINDOWS-1252?Q?Martin_MOKREJ=8A?=" 
	<mmokrejs@ribosome.natur.cuni.cz>,
       "Pavel Machek" <pavel@suse.cz>,
       "kernel list" <linux-kernel@vger.kernel.org>,
       "Andrew Morton" <akpm@osdl.org>, mtk.manpages@gmail.com,
       rdunlap@xenotime.net, linux-doc@vger.kernel.org
Subject: Re: document ext3 requirements
In-Reply-To: <20090104193637.GB22958@mit.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <495FEE66.9080903@ribosome.natur.cuni.cz>
	 <495FF9CE.2020908@ribosome.natur.cuni.cz>
	 <e9e943910901031600o1705dfb3j197f90b62d1f75a6@mail.gmail.com>
	 <495FFECB.5040001@ribosome.natur.cuni.cz>
	 <e9e943910901031641x4c900b6ar5d0f50b648584b7b@mail.gmail.com>
	 <15786.1231041158@turing-police.cc.vt.edu>
	 <e9e943910901040624y69c01b43p1655c0078b969ea6@mail.gmail.com>
	 <20090104184040.GC17558@mit.edu>
	 <Pine.LNX.4.64.0901042015230.31141@anakin>
	 <20090104193637.GB22958@mit.edu>
X-Google-Sender-Auth: 63b2b15c1ab0800a
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/1/4 Theodore Tso <tytso@mit.edu>:
> On Sun, Jan 04, 2009 at 08:21:06PM +0100, Geert Uytterhoeven wrote:
>> As for mounting the root file system read-only during early boot up, and
>> remounting it read-write later, I guess it's quite complicated to replay the
>> journal (in RAM) on read-only mount, and deferring the replay writeback until
>> remounting read-write?
>
> It's not *that* hard; if someone would like to cons up a patch, please
> feel free....  but it's certainly not a high priority for me or most
> of the other ext3 filesystem developers.

If anyone is interested I'd be happy to dust off and send them my old
patches to implement this. There are a couple of issues with it.
First, I never got around to implementing remount R/W support. Second,
I had to introduce a rather nasty hack in order to handle un-escaping
JFS magic numbers.

>                                        - Ted

Cheers,
Duane.

-- 
"I never could learn to drink that blood and call it wine" - Bob Dylan
