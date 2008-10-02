Return-Path: <linux-kernel-owner+w=401wt.eu-S1754829AbYJBQP2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754829AbYJBQP2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Oct 2008 12:15:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753692AbYJBQPV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Oct 2008 12:15:21 -0400
Received: from an-out-0708.google.com ([209.85.132.249]:26131 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753556AbYJBQPU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Oct 2008 12:15:20 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=wmMzPLQ0J7gADKPNPkcRNX/Caa7NDR7YDuU/VjW//InTdTQT1GfPyMM9vW+9JUvNVu
         VAPciDlxgZmJlLLZ4ncQhMP+PL9qWdllcGkJJJaN1gT4yWt6Sgy72XQBm2OjRTWoZnIB
         HqQB873lpejzMox3NHwhhNZeybHOy6tt1P7Vg=
Message-ID: <c384c5ea0810020915r3023bapecc99b7fcd67b81c@mail.gmail.com>
Date: Thu, 2 Oct 2008 18:15:18 +0200
From: "Leon Woestenberg" <leon.woestenberg@gmail.com>
To: "Jens Axboe" <jens.axboe@oracle.com>
Subject: Re: disk IO directly from PCI memory to block device sectors
Cc: "Leisner, Martin" <Martin.Leisner@xerox.com>,
       "Alan Cox" <alan@lxorguk.ukuu.org.uk>, marty <martyleisner@yahoo.com>,
       linux-kernel@vger.kernel.org
In-Reply-To: <20081001190546.GQ19428@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <247018.46515.qm@web50603.mail.re2.yahoo.com>
	 <20080926094653.1e0a9260@lxorguk.ukuu.org.uk>
	 <20080926091135.GV2677@kernel.dk>
	 <556445368AFA1C438794ABDA8901891C0999203A@USA0300MS03.na.xerox.net>
	 <20080929130222.GX2677@kernel.dk> <20081001190546.GQ19428@kernel.dk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Jens,

On Wed, Oct 1, 2008 at 9:05 PM, Jens Axboe <jens.axboe@oracle.com> wrote:
> On Mon, Sep 29 2008, Jens Axboe wrote:
>> On Fri, Sep 26 2008, Leisner, Martin wrote:
>> IMHO, this interface totally rocks. It's really async like splice was
>
> Alright, so this one actually works :-)
> Apart from fixing the bugs in it, it's also more clever in using the bio
> for the write part. It'll reuse the same bio in the splice actor until
> it's full, only then submitting it and allocating a new one. The read
> part works the same way.
>
I have been following this thread trying to grasp a very nifty use
case (high speed acquisition and storage of data) of splice.

I think it would make a perfect example of splice functionality.

What would the user space part look like to exercise this interface?

And whoever writes Linux Device Drivers 4th edition or one of the
kernel books; make sure this topic in is :-)

Regards,
-- 
Leon
