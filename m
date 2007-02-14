Return-Path: <linux-kernel-owner+w=401wt.eu-S932158AbXBNH22@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932158AbXBNH22 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Feb 2007 02:28:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932175AbXBNH22
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Feb 2007 02:28:28 -0500
Received: from ug-out-1314.google.com ([66.249.92.172]:51435 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932158AbXBNH21 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Feb 2007 02:28:27 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=i+R9gE9wEuMExP7Ox07SYxtpCWggyfPUqDy17gLNaoUFJzsEkR0oXu6Bf1fwsYXyzOgKjpCWFHZVblULall9OLkHMmJYB45WW8+L3f/MLq1FFvq7UnH7HgWWA3HozGll/v1Nh4UDafc4tWNbCaCd2wAoVv9Ti7M6rkJApTVIn/s=
Message-ID: <8d158e1f0702132328u104c89d4r3154b87c2b5f6e5c@mail.gmail.com>
Date: Wed, 14 Feb 2007 08:28:25 +0100
From: "Patrick Ale" <patrick.ale@gmail.com>
To: "Bill Davidsen" <davidsen@tmr.com>
Subject: Re: [PROBLEM] Can't start MD devices by using /dev/disk/by-id
Cc: linux-kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <45D259DD.7040505@tmr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <8d158e1f0702131351l3e3e1ae2u71a13de655391fce@mail.gmail.com>
	 <45D259DD.7040505@tmr.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> >
> Just out of curiosity, why did you do this in such a manual way instead
> of just using the UUID? I would think every time you replace a failed
> drive you would have to go edit the files all over again.

Oh, there is a very simple reason for that.
These md arrays exist for a year of three allready, from the time I
used raidtool instead of mdadm.

So when I switched to to mdadm, I just got the /etc/raidtab file and
migrated it to /etc/mdadm.conf, since /etc/raidtab worked with
blockdevices and not UIDs (correct me if I am wrong and overlooked
this featute), the mdadm.conf ended up with these devices too.

Next to that, there is a, for me at least, practicle reason. I keep
adding harddisks, and when I use the block devices rather than UIDS,
and I get problems like yesterday, I have the blockdevice or serial
number of the disk, which makes it easier to look in my case where the
potential problem might be. If I work with UIDs and something goes
wrong when doing an mdadm --assemble, then I'll first have to look up
which disks belong to which UID, which costs time.

OR! which is also very possible, maybe there is a way easier way to
pinpoint which drives belong to which array before starting the array,
which I don't know about yet. So please, if you have suggestions, let
me know :)


Take care!

Patrick
