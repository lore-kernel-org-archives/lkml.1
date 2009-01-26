Return-Path: <linux-kernel-owner+w=401wt.eu-S1752014AbZAZIn0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752014AbZAZIn0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2009 03:43:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750861AbZAZInS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Jan 2009 03:43:18 -0500
Received: from rv-out-0506.google.com ([209.85.198.237]:51113 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750777AbZAZInR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2009 03:43:17 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :content-type:content-transfer-encoding;
        b=MjTkZN3rf0+Tfc1dUuVqBkflpOfStppowBQQawjTCLU5UyT8OjQ6jBdonlJVygXtUa
         5FSHilbhb1AdgsY8Rfflj5Yz5OOo4R2vtd/9UqZGiXkWgbzPZBFE4QzEaoitzjYasXm+
         WSOX0jF75vNiUE3oMkb0VmEzh4SqQrUHTq6Qk=
MIME-Version: 1.0
In-Reply-To: <51ac1bba0901252140h60ecd54ds84c354a3796e7eff@mail.gmail.com>
References: <3f9a31f40901251239k3e368feeib33661d82497725b@mail.gmail.com>
	 <497CD30D.80203@tmr.com>
	 <3f9a31f40901251310g38ecfe61t97e119533215d271@mail.gmail.com>
	 <200901252249.17410.bzolnier@gmail.com>
	 <3f9a31f40901252031l3bb0ec39nd077ff8f13df73bd@mail.gmail.com>
	 <51ac1bba0901252130t408ab568k3b156e130f140a24@mail.gmail.com>
	 <51ac1bba0901252140h60ecd54ds84c354a3796e7eff@mail.gmail.com>
Date: Mon, 26 Jan 2009 14:13:16 +0530
Message-ID: <51ac1bba0901260043l2e601156sce007f667d26ccc9@mail.gmail.com>
Subject: Re: hdb: status error: error=0x40 <3>{ UncorrectableError }
From: Jaswinder Singh Rajput <jaswindercluster@gmail.com>
To: Discussion of Rocks Clusters <npaci-rocks-discussion@sdsc.edu>,
       Bill Davidsen <davidsen@tmr.com>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       James Bottomley <James.Bottomley@hansenpartnership.com>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, greg.bruno@gmail.com,
       mason.katz@gmail.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 26, 2009 at 11:10 AM, Jaswinder Singh
<jaswindercluster@gmail.com> wrote:
> On Mon, Jan 26, 2009 at 11:00 AM, Jaswinder Singh
> <jaswindercluster@gmail.com> wrote:
>> Story is like this:
>>
>> I was using Fedora 8 on my machine with one hard disk, So I was
>> planning to add another OS 'Rock Cluster 5.1', so I added another
>> working drive as primary slave and start loading Rock cluster 5.1
>> during installation machine reboots so when I log on to Fedora 8
>> machine I get uncorrectable error, I thought may be somehow this drive
>> is broken so I connected another drive as primary slave and I also
>> verified that it is mounting on Fedora 8 and also showing correct
>> data.
>>
>> So I again started Rock Cluster frontend installation , I did manual
>> partition on hdb and during format it shows me unrecoverable error. So
>> when I started Fedora 8 it also show uncorrectable error on another
>> drive also.
>>
>> So I am still trying what goes wrong.
>>

The problem was these drives was having old Redhat partitions and
installation process was not able to delete them properly.

After deleting all old partitions manually now harddisk start working.

Thanks for all your help.

--
JSR
