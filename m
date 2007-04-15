Return-Path: <linux-kernel-owner+w=401wt.eu-S1753381AbXDOTIn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753381AbXDOTIn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Apr 2007 15:08:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753394AbXDOTIn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Apr 2007 15:08:43 -0400
Received: from mu-out-0910.google.com ([209.85.134.184]:37831 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753381AbXDOTIl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Apr 2007 15:08:41 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:from:to:subject:date:user-agent:references:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=B4IlUZsvxbet2/aOeuleN+iIrenhG55Sys286XSBy7oJDsoePJ3W/Eh3rs7F5PVAHOVxa2l5Rw4xrmKFXKIg0VwVdj2RHaBuQ/WUXyQORxcLWqDnZ9kmNyYZ5UbMsQMzeA/ruESvsuxPSGp/8kRTI7D1eYgbCJ4DK+fJ6ubWKwI=
From: auxsvr@gmail.com
To: linux-kernel@vger.kernel.org
Subject: Re: Loud "pop" coming from hard drive on reboot
Date: Sun, 15 Apr 2007 22:06:25 +0300
User-Agent: KMail/1.9.5
References: <461D4E2C.6000704@redhat.com> <461D54AF.3060706@redhat.com> <414cba4e0704150907r215bf196n637070dd40bccc3b@mail.gmail.com>
In-Reply-To: <414cba4e0704150907r215bf196n637070dd40bccc3b@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200704152206.26430.auxsvr@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 15 April 2007 19:07, emisca wrote:
> I can confirm this, I have a Seagate Momentus 5400.3 sata disk, and it
> spins off, respin up and again off when I halt my notebook.
> I had before this disk an IBM/Hitachi one, and it doesn't have this
> behaviour.
>
> Take a look at this bug report:
> https://bugs.launchpad.net/ubuntu/+source/linux-source-2.6.17/+bug/67810
>
> There are some references and some patches against 2.6.20 kernel. This
> bug is confirmed there.
>
> Bye
>

I had the same problem with 2 WD disks on a desktop machine for 2 years, until 
I activated ACPI S3 (suspend to RAM) in the BIOS. According to this bug 
report (https://bugzilla.novell.com/show_bug.cgi?id=229210) the problem may 
be due to bad interaction between libata and the shutdown command. Tejun Heo, 
whom I thank for his support, has already proposed a patch to fix this. From 
the description there, it looks like it may also fix the reboot problem this 
thread is about.

Regards
