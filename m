Return-Path: <linux-kernel-owner+w=401wt.eu-S1758531AbZEEWaD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758531AbZEEWaD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 May 2009 18:30:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754467AbZEEW3v
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 May 2009 18:29:51 -0400
Received: from yw-out-2324.google.com ([74.125.46.31]:54172 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754316AbZEEW3u convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 May 2009 18:29:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=utr60PQpgxHvgt7ZPYs4xibunUnlIyD87r/mMxP0fvn4P9E4ZMwnkD8o2p5juJsacp
         KkecX8biOeOvUP+y+jf+c8WfaTlRt9lughfPQkxKzpb4OjooEtlp/S6p6VaFNKhSn+1Q
         IFUJs3BGhIQUCWO4Gwtz2KDVEMJTRXdwJyF2Y=
MIME-Version: 1.0
In-Reply-To: <20090505210438.GA1325@infradead.org>
References: <20090504132119.GX8822@parisc-linux.org>
	 <20090504150834.GZ8822@parisc-linux.org>
	 <1241451391.20170.12.camel@norville.austin.ibm.com>
	 <m14ow0hnal.fsf@fess.ebiederm.org>
	 <1241453259.20170.17.camel@norville.austin.ibm.com>
	 <m1k54wal0j.fsf@fess.ebiederm.org> <20090504230357.GI6766@mit.edu>
	 <4A001E51.4070903@davidnewall.com>
	 <109151.1241556990@turing-police.cc.vt.edu>
	 <20090505210438.GA1325@infradead.org>
Date: Tue, 5 May 2009 17:29:49 -0500
Message-ID: <524f69650905051529i6d48a63au9d71b07de06ab196@mail.gmail.com>
Subject: Re: [PATCH] Add CONFIG_VFAT_NO_CREATE_WITH_LONGNAMES option
From: Steve French <smfrench@gmail.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: Valdis.Kletnieks@vt.edu, David Newall <davidn@davidnewall.com>,
       Theodore Tso <tytso@mit.edu>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Chris Friesen <cfriesen@nortel.com>,
       Dave Kleikamp <shaggy@linux.vnet.ibm.com>,
       Matthew Wilcox <matthew@wil.cx>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, tridge@samba.org,
       Al Viro <viro@zeniv.linux.org.uk>, Pavel Machek <pavel@ucw.cz>,
       Ogawa Hirofumi <hirofumi@mail.parknet.co.jp>,
       linux-fsdevel <linux-fsdevel@vger.kernel.org>,
       Michael Tokarev <mjt@tls.msk.ru>, LKML <linux-kernel@vger.kernel.org>,
       Olivier Galibert <galibert@pobox.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 5, 2009 at 4:04 PM, Christoph Hellwig <hch@infradead.org> wrote:
> On Tue, May 05, 2009 at 04:56:30PM -0400, Valdis.Kletnieks@vt.edu wrote:
>> Well, VFAT was in Windows for Workgroups 3.11 or so, back in 1982, and a patent
>
> VFAT was introduced in Windows 95.  OS/2 had it's own long filename
> extensions longe before as did Linux (umsdos)
Yes, Christoph is correct we did implement long file name support long
ago in OS/2.

OS/2 long filenames for FAT were stored as the .LONGFILE extended
attribute.  With
extended attribute emulation on vfat a similar approach could be used, although
presumably with different ondisk format for "EA DATA. SF" system file (which
stores extended attributes).   If anyone is interested in more detail on this
(probably would be boring to most), we can explain the details.



-- 
Thanks,

Steve
