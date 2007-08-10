Return-Path: <linux-kernel-owner+w=401wt.eu-S1756718AbXHJVbU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756718AbXHJVbU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Aug 2007 17:31:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751594AbXHJVbL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Aug 2007 17:31:11 -0400
Received: from smtp105.rog.mail.re2.yahoo.com ([206.190.36.83]:24974 "HELO
	smtp105.rog.mail.re2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751583AbXHJVbK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Aug 2007 17:31:10 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=rogers.com;
  h=Received:X-YMail-OSG:From:To:Subject:Date:User-Agent:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=gmV4jrVOfFvyObT6obSZs52suhdYc/c0/frwQEEG1eAx5LGylOlxfHm4FN//E41LFSyeR0wigvH0s36LP2ZY/7sovoW8HKyupKh+yl21RRvj6rbZc9aq1nu7EjyfYFF7T9F20pq46avOc8IKhaUJcP4nUG/WTn5GFvMaejrcCt0=  ;
X-YMail-OSG: 1bjDdPkVM1nCZUo7torp1eEcZvAIoqZkoJTZh47wZCyUo0p7pg6mNfxD_jqvqIFAyA--
From: Mark Cannon <random.bits@rogers.com>
To: linux-kernel@vger.kernel.org
Subject: Use of directories to hold root?
Date: Fri, 10 Aug 2007 17:24:26 -0400
User-Agent: KMail/1.9.6
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200708101724.26724.random.bits@rogers.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

You pass the kernel the root option to specify the root partition.
Is there a way to identify a directory in that partition that holds the
root or something equivalent to this?

Something like:

kernel /vmlinuz26 root=/dev/sda3 root-directory=ker2621

If you independently examined /dev/sda3 you would find
/ker2611/
 ker2621/

with the regular root structure under them (usr,bin,sbin,var,....)

We have 70+ remote machines we wish to bring up to date, and they
were not set up with any extra partitions. They are remote in that they
only connect briefly and have to be automatically updated. 

I am open to other suggestions. The only other idea I have is to remotely/automatically
re-partition the disk to allow multiple roots in the future - scary stuff.

Please CC me when replying to this posting.

Thank you,
Mark


