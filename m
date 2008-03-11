Return-Path: <linux-kernel-owner+w=401wt.eu-S1757977AbYCKPGc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757977AbYCKPGc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2008 11:06:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757794AbYCKPGT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Mar 2008 11:06:19 -0400
Received: from n23b.bullet.mail.sp1.yahoo.com ([69.147.64.243]:45140 "HELO
	n23b.bullet.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1757750AbYCKPGR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2008 11:06:17 -0400
X-Yahoo-Newman-Property: ymail-5
X-Yahoo-Newman-Id: 336165.8707.bm@omp401.mail.sp1.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=X-YMail-OSG:Received:Date:From:Subject:To:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-ID;
  b=aw0S/ZiEpfZlIDylDJpH6NmDSR8wov+9f+Qq9dQjpHIh8qqNUa07mRO/0H1J8NRkC4DTRv2GYf7GJ9CcliU3dFMS10XiS9JSv8UCryDYm4f5AaxOcPFh4beE8a3V4VaPj8hP5t0JZtFi+6a7ArrYx+VGTusXGkFjwrkd2J0MVqE=;
X-YMail-OSG: 0oW_3bYVM1ky25.Qu7sUkCpTQcmwEup_ZK0FZadLl2Cp1nEK3t8UMjPd75PClHM5djk8759QvdYY.fZnRWOsv3QOX0QonWqA3P5jO5FPE6jPs02nAXM-
Date: Tue, 11 Mar 2008 08:06:16 -0700 (PDT)
From: Thierry Godefroy <reserv0@yahoo.com>
Subject: [FIXED][BUG] 2.6.24.x can't boot (sysfs: could not mount)
To: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Message-ID: <15891.73472.qm@web45112.mail.sp1.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

OK... Sorry about the "noise". I traced the problem down to fs/super.c and a
the supermount patch I was using. Fixed now. Sorry again for the false alert...


--- Thierry Godefroy <reserv0@yahoo.com> wrote:

> Greetings,
> 
> I tried to upgrade the Linux kernel to 2.6.24.3 on my laptop computer (Clevo
> D470K), which is currently running happily under 2.6.23.17, but the new
> kernel
> panics at the very start of the boot up sequence (can't even produce a dmesg
> to
> post here), with the following error:
> 
> sysfs: could not mount !
> mnt_init: sysfs_init_error: -22
> 
> This computer ran the whole series of 2.6 kernels so far, and I'm using the
> same configuration with 2.6.24.3 as with 2.6.23.17.
> 
> It's a "vanilla" kernel with the exception of two patches: supermount (which
> is
> not even yet active when the panic occurs), and a patch to drivers/acpi/ec.c
> (ACPI_EC_DELAY set back to 50ms) because a change in 2.6.20 broke ACPI on
> this
> computer (slowing everything down to a crawl when ACPI_EC_DELAY is left to
> 500ms).
> 
> I also tried with v2.6.24 sources, with the same result.
> 
> Any idea ?


      ____________________________________________________________________________________
Looking for last minute shopping deals?  
Find them fast with Yahoo! Search.  http://tools.search.yahoo.com/newsearch/category.php?category=shopping

