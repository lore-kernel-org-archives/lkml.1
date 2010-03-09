Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932142Ab0CICnD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Mar 2010 21:43:03 -0500
Received: from mail-gy0-f174.google.com ([209.85.160.174]:63865 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932092Ab0CICnA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Mar 2010 21:43:00 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=jiKzMF3m21mpt7DR8Xf/9p7mwt+4Ei2PIYDh3ZLJYhBPBNb8THNYn9JYy3f3zdE41S
         owhW02LCAYdFJSBQtHkwXFCNUbq+MmheZnGFP0/Em3KrPxlwdbP/Kvh8fPkp4jiD1o9/
         /o9hLnXEFTcgFvQtnO9CRNnBG6KjIpMh8Af5k=
Message-ID: <4B95B5AC.8050101@gmail.com>
Date: Tue, 09 Mar 2010 11:42:52 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091130 SUSE/3.0.0-1.1.1 Thunderbird/3.0
MIME-Version: 1.0
To: Karel Zak <kzak@redhat.com>
CC: "Martin K. Petersen" <martin.petersen@oracle.com>,
       "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>,
       lkml <linux-kernel@vger.kernel.org>,
       Daniel Taylor <Daniel.Taylor@wdc.com>, Jeff Garzik <jeff@garzik.org>,
       Mark Lord <kernel@teksavvy.com>, tytso@mit.edu,
       "H. Peter Anvin" <hpa@zytor.com>, hirofumi@mail.parknet.co.jp,
       Andrew Morton <akpm@linux-foundation.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, irtiger@gmail.com,
       Matthew Wilcox <matthew@wil.cx>, aschnell@suse.de, knikanth@suse.de,
       jdelvare@suse.de, Jim Meyering <jim@meyering.net>
Subject: Re: ATA 4 KiB sector issues.
References: <4B947393.2050002@kernel.org> <yq1zl2ic058.fsf@sermon.lab.mkp.net> <20100308195847.GC18077@nb.net.home> <4B95B39C.70402@kernel.org>
In-Reply-To: <4B95B39C.70402@kernel.org>
X-Enigmail-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, again.

On 03/09/2010 11:34 AM, Tejun Heo wrote:
>>  - parted uses 1MiB alignment for disks with unknown topology, disks
>>    with topology information are aligned to optimal (or minimum) I/O
>>    size (parted >= 2.1)
> 
> This will result in incorrect alignment for drives which lie about the
> physical sector size to work around BIOS/drivers issues (C-1).  It
> would probably be best to align to at least 1MiB.

I misread it.  C-1 would be disks w/o alignment information which will
be aligned to optimal_io_size which again would be 0 and thus 1MiB
alignment.  So, this should work, right?

Thanks.

-- 
tejun
