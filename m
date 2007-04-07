Return-Path: <linux-kernel-owner+w=401wt.eu-S965796AbXDGLHo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965796AbXDGLHo (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Apr 2007 07:07:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965808AbXDGLHo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Apr 2007 07:07:44 -0400
Received: from tmailer.gwdg.de ([134.76.10.23]:39930 "EHLO tmailer.gwdg.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965796AbXDGLHn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Apr 2007 07:07:43 -0400
Date: Sat, 7 Apr 2007 13:07:10 +0200 (MEST)
From: Jan Engelhardt <jengelh@linux01.gwdg.de>
To: JanuGerman <doublemalam@yahoo.co.uk>
cc: linuxkernel <linux-kernel@vger.kernel.org>
Subject: Re: Two questions regarding Opening files within Kernel!
In-Reply-To: <400855.99642.qm@web86903.mail.ukl.yahoo.com>
Message-ID: <Pine.LNX.4.61.0704071304240.22181@yvahk01.tjqt.qr>
References: <400855.99642.qm@web86903.mail.ukl.yahoo.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Spam-Report: Content analysis: 0.0 points, 6.0 required
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Apr 7 2007 06:58, JanuGerman wrote:
>Hi Every one,
>
>  I have got two questions regarding opening files within the Linux 
>  kernel. If some body can help me, in sorting out this problem, i will 
>  be very thankful.
>
>1)   I have just a file path with me, an absolute path, but no dentry, 
>   no inode, no vfsmount object, which function i can call to get a 
>   "file" object associated with the absoulte file path. I have surfed 
>   arround the source code especially fs/open.c and some other files, 
>   but each function requires a parameter "mode" and "fd" beside file 
>   path. Actually, i was confuse about the "mode" parameter (and its 
>   differece with "flag"), like what to send, and secondly for "fd", i 
>   am not sure, what value to send as there is no file infact and only 
>   file path exists. Any idea?

Not sure if this is the right function, but it should get you started...

struct dentry *foooobar = lookup_one_len("/foo/bar", current->fs->root);

>2) Any functionality within linux kernel source code, to read one line 
>   per file? or some indirect way to set buffer size for one read?. 
>   That is, any existing header file for doing text I/O rather than 
>   binary within the kernel source code?

http://kernelnewbies.org/FAQ/WhyWritingFilesFromKernelIsBad
(same goes for reading)


Jan
-- 
