Return-Path: <linux-kernel-owner+w=401wt.eu-S1757359AbYCYRXw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757359AbYCYRXw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Mar 2008 13:23:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755857AbYCYRXp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Mar 2008 13:23:45 -0400
Received: from n5a.bullet.mail.ac4.yahoo.com ([76.13.13.68]:31209 "HELO
	n5a.bullet.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755051AbYCYRXo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Mar 2008 13:23:44 -0400
X-Yahoo-Newman-Property: ymail-3
X-Yahoo-Newman-Id: 188603.89221.bm@omp107.mail.mud.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.de;
  h=X-YMail-OSG:Received:Date:From:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-ID;
  b=uiXk34jo26N1R6v/3bmLSA+PIs1Igvtz7tiDOERFUKrJP3K0i75tinbKMO7Jjde8DYmcPyQlvRSd/dz7NuWsWVRA4vKBM70g0kQRa52+QlCgJ2E6XVNeRBWVM7IYrbvx4cprDdYfMvZmVkxI5yCU0/sq+p3INwDvMmnxCcIjiBc=;
X-YMail-OSG: NtHZJYAVM1nbsZafDO3Fi2QX9VdeDqk8bUdDBEEpS6wtrOTXfa4MZEX9t1iFDRjVs4iqnTBOa0VpcSswGWkXXlYiWce7PJvMnCvUayBjDbgu5RbW2DtDx2kApLw-
Date: Tue, 25 Mar 2008 18:23:41 +0100 (CET)
From: Michael Meyer <mike65134@yahoo.de>
Subject: Re: performance differences: "maxcpus=1" vs. "echo 0 > /sys/devices/system/cpu/cpu1/online"
To: Andi Kleen <andi@firstfloor.org>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <87abkmhgg0.fsf@basil.nowhere.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Message-ID: <57127.43039.qm@web25812.mail.ukl.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--- Andi Kleen <andi@firstfloor.org> schrieb:

> Luciano Rocha <luciano@eurotux.com> writes:
> 
> > On Tue, Mar 25, 2008 at 02:47:50PM +0100, Michael
> Meyer wrote:
> > > Hi, 
> > > 
> > > what is the difference between booting a dual
> core
> > > machine with "maxcpus=1" or by deactivating the
> second
> > > core at run time with "echo 0 >
> > > /sys/devices/system/cpu/cpu1/online"?
> > 
> > maxcpus=1 should turn off the SMP alternative and
> switch to UP only,
> > optimising some locks and instructions.
> 
> CPU hot unplug will do the same. But it is unlikely
> it accounts
> for that much performance difference.
> 
> If he used maxcpus=0 it would make sense. maxcpus=0
> disables
> the IO-APIC which likely makes a large difference.
> But it should
> be actually slower.
> 
> There should be actually no difference in theory
> between max_cpus=1
> and hot unplug to one CPU. Might be some bug.

I had the following time values:

maxcpus=1:
real	0m1.642s
user	0m1.528s
sys	0m0.068s

maxcpus=2 and 
echo 1 > /sys/devices/system/cpu/cpu1/online:
real	0m2.579s
user	0m4.096s
sys	0m0.160s

maxcpus=2 and
echo 0 > /sys/devices/system/cpu/cpu1/online:
real	0m3.757s
user	0m3.632s
sys	0m0.112s







      Lesen Sie Ihre E-Mails jetzt einfach von unterwegs.
www.yahoo.de/go

