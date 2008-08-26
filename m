Return-Path: <linux-kernel-owner+w=401wt.eu-S1758989AbYHZQny@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758989AbYHZQny (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2008 12:43:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757365AbYHZQnq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Aug 2008 12:43:46 -0400
Received: from py-out-1112.google.com ([64.233.166.183]:39760 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757205AbYHZQnq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2008 12:43:46 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=g/YdSuOQPI7ubt1NC2NOh5se2hQwBjj2xBfykNFYgR9qa3mKu+lq6LJ2ohxedniolM
         OzTvFyDZhBPM/qHF1apcUlb+QJvpNVbDKez/iw+14kKEayKn/pgF2Sqv4oiBP9lyHFg5
         3Mkfs6RJHnzTOyZva0Nfyu1fcxtfAoq3haPxs=
Message-ID: <86802c440808260943k210be3edp54aebc9fea5366f5@mail.gmail.com>
Date: Tue, 26 Aug 2008 09:43:44 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Helge Hafting" <helge.hafting@aitel.hist.no>
Subject: Re: 2.6.27 mtrr fixes do not work when X starts
Cc: "Alexander Huemer" <alexander.huemer@sbg.ac.at>,
       "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "Andi Kleen" <andi@firstfloor.org>
In-Reply-To: <48B3CDAF.604@aitel.hist.no>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <4899AF8E.20105@sbg.ac.at> <48A43CB5.8010709@sbg.ac.at>
	 <86802c440808141031p2712976cqe2c34d3b986ad810@mail.gmail.com>
	 <48AD8125.7050104@sbg.ac.at>
	 <86802c440808210827y72bb1ec0ndcb97b00d6af3a9c@mail.gmail.com>
	 <48AE90BB.5090800@aitel.hist.no>
	 <86802c440808221024u1f152a73hf060f70e1b16dccb@mail.gmail.com>
	 <48B29320.5070903@aitel.hist.no>
	 <86802c440808251308i609a1c8ay6a7300bf4d0e0758@mail.gmail.com>
	 <48B3CDAF.604@aitel.hist.no>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 26, 2008 at 2:32 AM, Helge Hafting
<helge.hafting@aitel.hist.no> wrote:
> Yinghai Lu wrote:
>
>> please use "mtrr_spare_reg_nr=3 debug"
>>
>> you missed _nr.
>>
> Sorry. I got it right this time, and mtrr setup succeeded:
>
..
> $ cat /proc/mtrr
> reg00: base=0x00000000 (   0MB), size=1024MB: write-back, count=1
> reg01: base=0x40000000 (1024MB), size= 512MB: write-back, count=1
> reg02: base=0x60000000 (1536MB), size= 256MB: write-back, count=1
> reg03: base=0x70000000 (1792MB), size= 256MB: write-back, count=1
> reg04: base=0x7ff00000 (2047MB), size=   1MB: uncachable, count=1
> reg05: base=0xf3c00000 (3900MB), size=   2MB: write-combining, count=1
> reg06: base=0xf3800000 (3896MB), size=   4MB: write-combining, count=1
> reg07: base=0xf3000000 (3888MB), size=   8MB: write-combining, count=1
>
> This time X got its 3 regions, and no sluggishness when moving
> opaque windows. :-)

good.

>
> I hope this helps so the extra bootup parameters can be avoided in the
> release kernel.

that is a little bit hard.

YH
