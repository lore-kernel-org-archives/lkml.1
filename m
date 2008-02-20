Return-Path: <linux-kernel-owner+w=401wt.eu-S1761944AbYBTAJH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761944AbYBTAJH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2008 19:09:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753039AbYBTAIz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Feb 2008 19:08:55 -0500
Received: from web35715.mail.mud.yahoo.com ([66.163.179.169]:29370 "HELO
	web35715.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753566AbYBTAIy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2008 19:08:54 -0500
X-Greylist: delayed 396 seconds by postgrey-1.27 at vger.kernel.org; Tue, 19 Feb 2008 19:08:54 EST
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=X-YMail-OSG:Received:Date:From:Subject:To:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-ID;
  b=VKbiDC1qYAeD0MWR/GHMHPg4WlwCm1LqvepfstRhjYKE9HW9ApVJaf3ULEhnkNaNtl6vlr9OsRN+eUKK8ChKIDRKGyd8PcVX0JtSL9ZlbpQQPnjGh3pdImPtqLQArCriVri9qbJ3LEU6VE29mb9Pb4OnunfTyy5cdYS/8oJHBCY=;
X-YMail-OSG: 29lIF7AVM1l5HrYES4owaOv7unmo6.GtB6tiQCjqg2HEigZQm8B8xthqX4SaLM1tkHP8lQWlu8S4iiBKBBkipH1odZMK8abbCuIuE4gaRZ3H8jBMkgqpXpuC9cqa1g--
Date: Tue, 19 Feb 2008 16:02:13 -0800 (PST)
From: Mariella Petrini <mariellapetrini@yahoo.com>
Subject: Linux and SSD and how to decrease io delay : question, please
To: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Message-ID: <847418.75727.qm@web35715.mail.mud.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi All,

I have been running Linux kernel 2.6.23 with Debian on

a 2 CPUs Dual-Core AMD Opteron(tm) Processor 2218.
I have been using an SSD drive (MTRON) connected to a
raid controller (LSI      MegaRAID 8704ELP) to contain
data stored on several databases.
Each database contains 20,000 files and there are 50
databases total (1,000,000 files distributed across 50
directories on the filesystem on the ssd).

The database server uses the databases very "write"
intensively.
An approximate percentage could be 20% reads versus
80% random writes.

No matter which filesystem type is used (I have tried
ext3, xfs, jfs, reiserfs) I see every few seconds
snapshots (the could last in the worst case up to 200
seconds, depending on the filesystem type) 
where the iowait on the ssd device goes approximately
over 50% (up to 100%) and 
the database server threads go to wait (get
suspended).

Is there any Linux kernel parameter or any Linux
parameter that could be varied that could help to
decrease the time spent to sync all the data to the
SSD device ?

Thanks in advance for your help,

Mariella





      ____________________________________________________________________________________
Be a better friend, newshound, and 
know-it-all with Yahoo! Mobile.  Try it now.  http://mobile.yahoo.com/;_ylt=Ahu06i62sR8HDtDypao8Wcj9tAcJ 

