Return-Path: <linux-kernel-owner+w=401wt.eu-S1758079AbZFDGBv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758079AbZFDGBv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Jun 2009 02:01:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757549AbZFDGAY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Jun 2009 02:00:24 -0400
Received: from mail-bw0-f213.google.com ([209.85.218.213]:59535 "EHLO
	mail-bw0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757541AbZFDGAV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Jun 2009 02:00:21 -0400
X-Greylist: delayed 37292 seconds by postgrey-1.27 at vger.kernel.org; Thu, 04 Jun 2009 02:00:21 EDT
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=O5RZGfPJNhLhZE75ztNMhFAAiReNKvKkgJB0/lY68ytD01RbzUy8xwFzvNgce91z92
         yEe/E5Lh/TC0gWCVNTrb7HFwUIUQ62aUjTuqmkpo+5PWZJp/G2npnArLSo4c1n66QCKl
         uGYCqOrlbTfPtejdWtOEeauDLZofGxcLb2nu0=
MIME-Version: 1.0
In-Reply-To: <1244060503.11698.3.camel@localhost>
References: <64bb37e0905261214g2957924ar837339367f320d4c@mail.gmail.com>
	 <4A1C7DDB.9010605@gmail.com>
	 <64bb37e0906031230m22234268k9fdcd43dc1d35f18@mail.gmail.com>
	 <1244060503.11698.3.camel@localhost>
Date: Thu, 4 Jun 2009 08:00:22 +0200
Message-ID: <64bb37e0906032300h5ff0878agf312ba43df2d991@mail.gmail.com>
Subject: Re: sata_sil24 0000:04:00.0: DMA-API: device driver frees DMA sg list 
	with different entry count [map count=13] [unmap count=10]
From: Torsten Kaiser <just.for.lkml@googlemail.com>
To: Kasper Sandberg <lkml@metanurb.dk>
Cc: Robert Hancock <hancockrwd@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       SCSI development list <linux-scsi@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 3, 2009 at 10:21 PM, Kasper Sandberg <lkml@metanurb.dk> wrote:
> On Wed, 2009-06-03 at 21:30 +0200, Torsten Kaiser wrote:
>> On Wed, May 27, 2009 at 1:40 AM, Robert Hancock <hancockrwd@gmail.com> wrote:
>> > Torsten Kaiser wrote:
>> >>
>> >> On upgrading to 2.6.30-rc1 I enable the DMA-Debugging option
>> >> CONFIG_DMA_API_DEBUG=y
>> >> Since then I get the following or similar errors on each boot:
>> >
>> > Please retest with a newer -rc, this patch likely fixes it:
>> >
>> > http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=5825627c9463581fd9e70f8285685889ae5bb9bb
>> >
>>
>> Still happens with 2.6.30-rc8 (see trace at the end of the email)
>>
> <snip>
>
> Does this actually give you any problems? should I be scared to give .30
> a test?

No, other then the warning from this debug code I do not have any problems.

As I'm using Gentoo unstable this is triggered most often when I
install an upgrade to some package.
I would expect, if this really would write wrong data to the harddisk,
I would have already destroyed my system.

So while I think there is a problem somewhere that should be fixed,
I'm still using the .30 kernel for my system.

Torsten
