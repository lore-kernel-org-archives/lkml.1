Return-Path: <linux-kernel-owner+w=401wt.eu-S966253AbXDGSov@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966253AbXDGSov (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Apr 2007 14:44:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966263AbXDGSov
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Apr 2007 14:44:51 -0400
Received: from tmailer.gwdg.de ([134.76.10.23]:51889 "EHLO tmailer.gwdg.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966253AbXDGSou (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Apr 2007 14:44:50 -0400
Date: Sat, 7 Apr 2007 20:44:35 +0200 (MEST)
From: Jan Engelhardt <jengelh@linux01.gwdg.de>
To: JanuGerman <doublemalam@yahoo.co.uk>
cc: linuxkernel <linux-kernel@vger.kernel.org>
Subject: Re: Two questions regarding Opening files within Kernel!
In-Reply-To: <249860.22361.qm@web86911.mail.ukl.yahoo.com>
Message-ID: <Pine.LNX.4.61.0704072042400.22181@yvahk01.tjqt.qr>
References: <249860.22361.qm@web86911.mail.ukl.yahoo.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Spam-Report: Content analysis: 0.0 points, 6.0 required
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Apr 7 2007 16:57, JanuGerman wrote:
>
>Thanks Jan for the response.
>
>>struct dentry *foooobar = lookup_one_len("/foo/bar", current->fs->root);
>
>But that gives me a dentry, where as file object is still not reachable.

So use filp_open.

>Question: I am currently using a function called fs.h/dentry_open which takes
>a "dentry", "vfsmount" object and flag (usually RW i.e. 2), and gives me the
>file object. with your suggested method, vfsmount is still not available. In
>this regard, any idea about a function, which gives directly the file object
>instead of dentry will be highly appreciated.
>
>
>OR,  (Kindly see the code below), i need some thing for "missing vfsmount".
>
>
>    struct dentry *foooobar = lookup_one_len("/foo/bar", current->fs->root);
>    struct file *file1 = dentry_open(foooobar, "missing vfsmount here",2)
>
>
>
>Thanks,
>JG
>
>
>	
>	
>		
>___________________________________________________________ 
>New Yahoo! Mail is the ultimate force in competitive emailing. Find out more at the Yahoo! Mail Championships. Plus: play games and win prizes. 
>http://uk.rd.yahoo.com/evt=44106/*http://mail.yahoo.net/uk 
>

Jan
-- 
