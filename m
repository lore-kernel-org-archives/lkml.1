Return-Path: <linux-kernel-owner+w=401wt.eu-S965417AbXDGHFe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965417AbXDGHFe (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Apr 2007 03:05:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965442AbXDGHFe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Apr 2007 03:05:34 -0400
Received: from web86903.mail.ukl.yahoo.com ([217.12.13.55]:37397 "HELO
	web86903.mail.ukl.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S965417AbXDGHFd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Apr 2007 03:05:33 -0400
X-Greylist: delayed 400 seconds by postgrey-1.27 at vger.kernel.org; Sat, 07 Apr 2007 03:05:33 EDT
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.co.uk;
  h=X-YMail-OSG:Received:X-Mailer:Date:From:Subject:To:MIME-Version:Content-Type:Message-ID;
  b=uTblpwOChlW7IJbYQTC9DewwWR4qbgwRHqXDmBlVva99xFDKkAuKFhH4ide693vbcDWYYWR/OG4QzX4IGiMV6/sYTpXehFwxqng/ymr8mdN9+grFB1PZ2T7ynyKUFzc1wwVG54Igrp9T8fFjgTDlk6ZsRC8ZB0PvEq7Bgy0WeE0=;
X-YMail-OSG: Hyg84i0VM1ntA6s3X4sIn4B..V1U7ISN0nWbnt3Le7JB2y.PwT85uybo9Tjydinzk.JWnd6IBfDGAt4I3KFXay8KNEc.CeNWUC5hd9oQgW2u2AsBUV57
X-Mailer: YahooMailRC/478 YahooMailWebService/0.7.41.8
Date: Sat, 7 Apr 2007 06:58:51 +0000 (GMT)
From: JanuGerman <doublemalam@yahoo.co.uk>
Subject: Two questions regarding Opening files within Kernel!
To: linuxkernel <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ascii
Message-ID: <400855.99642.qm@web86903.mail.ukl.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Every one,

  I have got two questions regarding opening files within the Linux kernel. If some body can help me, in sorting out this problem, i will be very thankful.

1)   I have just a file path with me, an absolute path, but no dentry, no inode, no vfsmount object, which function i can call to get a "file" object associated with the absoulte file path. I have surfed arround the source code especially fs/open.c and some other files, but each function requires a parameter "mode" and "fd" beside file path. Actually, i was confuse about the "mode" parameter (and its differece with "flag"), like what to send, and secondly for "fd", i am not sure, what value to send as there is no file infact and only file path exists. Any idea?

2) Any functionality within linux kernel source code, to read one line per file? or some indirect way to set buffer size for one read?. That is, any existing header file for doing text I/O rather than binary within the kernel source code?

Thanks,
JG


		
___________________________________________________________ 
The all-new Yahoo! Mail goes wherever you go - free your email address from your Internet provider. http://uk.docs.yahoo.com/nowyoucan.html
