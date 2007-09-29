Return-Path: <linux-kernel-owner+w=401wt.eu-S1757557AbXI2SmO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757557AbXI2SmO (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Sep 2007 14:42:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756391AbXI2Sl6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 29 Sep 2007 14:41:58 -0400
Received: from mexforward.lss.emc.com ([128.222.32.20]:12561 "EHLO
	mexforward.lss.emc.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756306AbXI2Sl5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Sep 2007 14:41:57 -0400
X-Greylist: delayed 3418 seconds by postgrey-1.27 at vger.kernel.org; Sat, 29 Sep 2007 14:41:56 EDT
Date: Sat, 29 Sep 2007 13:44:16 -0400
To: "Andreas Dilger" <adilger@clusterfs.com>,
       =?iso-8859-15?Q?J=F6rn_Engel?= <joern@logfs.org>
Subject: Re: Versioning file system
From: "Sorin Faibish" <sfaibish@emc.com>
Cc: alan <alan@clueserver.org>, "H. Peter Anvin" <hpa@zytor.com>,
       "Jack Stone" <jack@hawkeye.stone.uk.eu.org>,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       akpm@linux-foundation.org, viro@zeniv.linux.org.uk
Content-Type: text/plain; format=flowed; delsp=yes; charset=iso-8859-15
MIME-Version: 1.0
References: <46731169.2090002@hawkeye.stone.uk.eu.org> <467314E2.9010306@zytor.com> <Pine.LNX.4.64.0706151547200.27993@blackbox.fnordora.org> <20070616145337.GA13391@lazybastard.org> <20070618094524.GF5181@schatzie.adilger.int>
Content-Transfer-Encoding: 8bit
Message-ID: <op.tzffj2horwwil4@champion.corp.emc.com>
In-Reply-To: <20070618094524.GF5181@schatzie.adilger.int>
User-Agent: Opera Mail/9.23 (Win32)
X-PMX-Version: 4.7.1.128075, Antispam-Engine: 2.5.1.298604, Antispam-Data: 2007.8.30.51425
X-PerlMx-Spam: Gauge=, SPAM=0%, Reasons='EMC_BODY_1+ -3, EMC_FROM_0+ -3, __C230066_P5 0, __CP_URI_IN_BODY 0, __CT 0, __CTE 0, __CT_TEXT_PLAIN 0, __HAS_MSGID 0, __MIME_TEXT_ONLY 0, __MIME_VERSION 0, __SANE_MSGID 0, __USER_AGENT 0'
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Interesting that you mention the multitude of file systems because
I was very surprised to see NILFS being promoted in the latest Linux
Magazine but no mention of the other more important file systems
currently in work like UnionFS ChunkFS or ext4 so publisized.
I can say I was disapointed of the article. I still didn't
see any real prove that NILFS is the best file system since bread.
Neither I see any comments on nilfs from Andrew and others and
yet this is the best new file system coming to Linux. Maybe I missed
something that happened in Ottawa.

/Sorin


On Mon, 18 Jun 2007 05:45:24 -0400, Andreas Dilger <adilger@clusterfs.com>  
wrote:

> On Jun 16, 2007  16:53 +0200, Jörn Engel wrote:
>> On Fri, 15 June 2007 15:51:07 -0700, alan wrote:
>> > >Thus, in the end it turns out that this stuff is better handled by
>> > >explicit version-control systems (which require explicit operations  
>> to
>> > >manage revisions) and atomic snapshots (for backup.)
>> >
>> > ZFS is the cool new thing in that space.  Too bad the license makes it
>> > hard to incorporate it into the kernel.
>>
>> It may be the coolest, but there are others as well.  Btrfs looks good,
>> nilfs finally has a cleaner and may be worth a try, logfs will get
>> snapshots sooner or later.  Heck, even my crusty old cowlinks can be
>> viewed as snapshots.
>>
>> If one has spare cycles to waste, working on one of those makes more
>> sense than implementing file versioning.
>
> Too bad everyone is spending time on 10 similar-but-slightly-different
> filesystems.  This will likely end up with a bunch of filesystems that
> implement some easy subset of features, but will not get polished for
> users or have a full set of features implemented (e.g. ACL, quota, fsck,
> etc).  While I don't think there is a single answer to every question,
> it does seem that the number of filesystem projects has climbed lately.
>
> Maybe there should be a BOF at OLS to merge these filesystem projects
> (btrfs, chunkfs, tilefs, logfs, etc) into a single project with multiple
> people working on getting it solid, scalable (parallel readers/writers on
> lots of CPUs), robust (checksums, failure localization), recoverable,  
> etc.
> I thought Val's FS summits were designed to get developers to  
> collaborate,
> but it seems everyone has gone back to their corners to work on their own
> filesystem?
>
> Working on getting hooks into DM/MD so that the filesystem and RAID  
> layers
> can move beyond "ignorance is bliss" when talking to each other would be
> great.  Not rebuilding empty parts of the fs, limit parity resync to  
> parts
> of the fs that were in the previous transaction, use fs-supplied  
> checksums
> to verify on-disk data is correct, use RAID geometry when doing  
> allocations,
> etc.
>
> Cheers, Andreas
> --
> Andreas Dilger
> Principal Software Engineer
> Cluster File Systems, Inc.
>
> -
> To unsubscribe from this list: send the line "unsubscribe linux-fsdevel"  
> in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
>
>



-- 
Best Regards
Sorin Faibish
Senior Technologist
Senior Consulting Software Engineer Network Storage Group

        EMC²
where information lives

Phone: 508-435-1000 x 48545
Cellphone: 617-510-0422
Email : sfaibish@emc.com
