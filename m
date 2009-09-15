Return-Path: <linux-kernel-owner+w=401wt.eu-S1752911AbZIOLD6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752911AbZIOLD6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Sep 2009 07:03:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752821AbZIOLDy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Sep 2009 07:03:54 -0400
Received: from smtp.nokia.com ([192.100.122.230]:63872 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752805AbZIOLDx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Sep 2009 07:03:53 -0400
Subject: Re: [PATCH take 3][RFC] fat: Save FAT root directory timestamps to
	volume label
From: =?ISO-8859-1?Q?J=F6rg?= Schummer <ext-jorg.2.schummer@nokia.com>
Reply-To: jorg@ml1.net
To: "hirofumi@mail.parknet.co.jp" <hirofumi@mail.parknet.co.jp>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
       jorg@ml1.net
In-Reply-To: <1252420448-7282-1-git-send-email-ext-jorg.2.schummer@nokia.com>
References: <1252420131.5782.2.camel@jorg-desktop>
	 <1252420448-7282-1-git-send-email-ext-jorg.2.schummer@nokia.com>
Content-Type: text/plain; charset=UTF-8
Date: Tue, 15 Sep 2009 14:03:42 +0300
Message-Id: <1253012622.5740.4.camel@jorg-desktop>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 8bit
X-OriginalArrivalTime: 15 Sep 2009 11:03:44.0703 (UTC) FILETIME=[31306CF0:01CA35F4]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-09-08 at 16:34 +0200, Schummer Jorg.2
(EXT-TietoEnator/Helsinki) wrote:
> Standard FAT implementations cannot store any of the FAT root directory's
> timestamps. This commit adds the mount option 'rootts', which allows saving
> the FAT root directory timestamps as the timestamps of the FAT volume label
> directory entry. At least Mac OS X is known to support the same mechanism
> and interoperate with this commit.
> 
> When mounting, the following values can be specified for the 'rootts' mount
> option:
> 
>   "rootts=ignore"   ignores root directory timestamps. All timestamps are
>                     reset to 0 (1/1/1970). This has been the FAT behaviour
>                     prior to this patch.
> 
>   "rootts=preserve" tries to load and save the root directory's timestamps
>                     if a volume label entry exists. The mtime and atime are
>                     corrected based on root directory entries' ctime. This
>                     is the default.
> 
>   "rootts=save"     tries to load and save the root directory's timestamps.
>                     The mtime and atime are corrected based on root
>                     directory entries' ctime. If the root directory was
>                     accessed but no volume label entry exists, the label
>                     "NO NAME" is created.

Hello again,

in case anyone would like to send some feedback or comments about the
patch, please use this email address from now on: jorg@ml1.net .

Thanks,
Jörg


