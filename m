Return-Path: <linux-kernel-owner+w=401wt.eu-S1752656AbZIXDHc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752656AbZIXDHc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Sep 2009 23:07:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752659AbZIXDHa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Sep 2009 23:07:30 -0400
Received: from an-out-0708.google.com ([209.85.132.244]:6946 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752575AbZIXDH2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Sep 2009 23:07:28 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=EHZZnRwERu0n0L+WSzZcUvWlCsdvV1k4HOM0iaMOgQ8sqxgsrFfawx+Z1oaX/C6f3W
         MzkHkJrQo3HM7lGe80YVF3cbtwmC+7L1aEKyKrfN83kb96AvEpNYFkeY7AfBkEhaVPGi
         4AFhTyom6XSzKSkSnqPRwo08uvxgdVmB9Mcrs=
Message-ID: <4ABAE271.80309@gmail.com>
Date: Wed, 23 Sep 2009 21:07:29 -0600
From: Robert Hancock <hancockrwd@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.1) Gecko/20090814 Fedora/3.0-2.6.b3.fc11 Thunderbird/3.0b3
MIME-Version: 1.0
To: whansard@sbcglobal.net
CC: linux-kernel@vger.kernel.org
Subject: Re: disk speed regression kernel 2.6.29 and after
References: <4ABA0FDA.9090707@sbcglobal.net>
In-Reply-To: <4ABA0FDA.9090707@sbcglobal.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/23/2009 06:08 AM, will wrote:
> I had been using an old 2.6.22 kernel on my machine, and I often backup
> one partition of my main hard drive to a partition on a second hard
> drive. The main hard drive is sata 640 gigs, and the second is a pata
> 320 gig. copying this partition from one drive to the other with dd
> takes about 3 minutes and 30 seconds. When I installed kernel 2.6.30,
> and 2.6.31, the time took 9 minutes and 20 seconds. I decided to go to
> the trouble of compiling all the kernels between, and kernels
> 2.6.22-2.6.28 all do the operation in about 3 minutes and 30 seconds.
> 2.6.29- newer all take about 9 minutes and 20 seconds. The partition is
> 16 gigs. each drive seems to be as fast as before otherwise, it's just
> much slower copying from one drive to another, which I do very often.
> This is an nforce 3 based motherboard, amd southbridge, i think, with 4
> gigs of ram, athlon 64x2. 32 bit kernel. has anyone heard of this problem?
> I currently have 3 hard drives hooked up.
> a 200 gig on a promise controller,
> a 320 gig on the amd pata?
> a 640 sata on the nv i think.
> The motherboard is a Asrock-AM2NF3-VSTA
> copying this partition with dd or cat or schily's dd between any of these 3
> different hard drives takes different times depending on the speed of
> the drive with
> kernels 2.6.22-2.6.28, but takes about 9 minutes and 30 seconds on any
> of the drives
> with the kernels 2.6.29 and after.
> Please cc me with any followups or anything. thanks.

Can you post the dmesg output from bootup on both the good and bad kernels?
