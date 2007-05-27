Return-Path: <linux-kernel-owner+w=401wt.eu-S1761323AbXE1JHl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761323AbXE1JHl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 May 2007 05:07:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754649AbXE1JHZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 May 2007 05:07:25 -0400
Received: from m12-13.163.com ([220.181.12.13]:41820 "HELO m12-13.163.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753876AbXE1JHX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 May 2007 05:07:23 -0400
Subject: Re: 2.6.17-rc6 No volume groups found
From: freegnu <freegnu@163.com>
Reply-To: freegnu@163.com
To: Barry Scott <barry.scott@onelan.co.uk>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <4656AE10.4070104@onelan.co.uk>
References: <4491540A.6050806@onelan.co.uk>
	 <1180020784.9086.0.camel@localhost.localdomain>
	 <4656AE10.4070104@onelan.co.uk>
Content-Type: text/plain
Organization: gnu
Date: Mon, 28 May 2007 01:08:13 +0800
Message-Id: <1180285693.4209.6.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.2.2 (2.2.2-5) 
Content-Transfer-Encoding: 7bit
X-Coremail-Antispam: 1U3Yxn0WfASr-VFAUDIcSsGvfJ-kc8Ir4CE8sxKj4xv1VAv77
	x28xy5McIj6xIIjxv20xvE14v26r1j6r18MxCjnVAqn7xvrwAv7VC2z280aVAFwI0_Jr0_
	Gr1l14x267AKxVWUJVW8JwCjxxvEa2IrM7kC6x804xWl1IIY67AEw4v_Jr0_Jr4l5I8CrV
	ACY4xI64kE6c02F40Ex7xfMxkFs20EY4vEwck0b40E8IxJM7k0a2IF6F4Un29KB7ZKAUJU
	UUUUnxnvy29KBjDU0xZFpf9x07be38nUUUUU129KBjvJXoW7KrWkur1UZr18tF45CFW5GF
	g_yoW8AryxpF43KF1YkF1qyanrAw1Iv3Wj9342y3s3J3WUXrn0gr95Jrn09F4Iv34Yvw43
	uFyqqw4SkF1jkr1rXa4xu3WUZFJ==
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

yes, i have rebuilt the initrd by the command: /sbin/mkinitrd
--builtin=ata_piix /boot/initrd-2.6.14.img initrd-2.6.14

On Fri, 2007-05-25 at 10:36 +0100, Barry Scott wrote:
> freegnu wrote:
> > i have the same problem when i built kernel 2.6.14.
> > and the previous working kernel is 2.6.11 form Fedora Code 4
> >
> > anyone give me any adviece? thanks
> >
> >
> > On Thu, 2006-06-15 at 13:35 +0100, Barry Scott wrote:
> >   
> >> On my HP dc7600U having patch around the MCG problem
> >> I now get a bit further. Previous working kernel was 2.6.16
> >> from Fedora Code 4.
> >>
> >> I see:
> >>
> >> Uncompressing Linux... Ok, botinh the kernel.
> >> Red Hat nash version 4.2.15 starting
> >>   Reading all physical volumes.  This may take a while...
> >>   No volume groups found
> >>   Unable to find volume group "VolGroup00"
> >> ERROR: /bin/lvm exited abnormally with value 5 ! (pid 351)
> >>
> >> Then a few more errors and Kernel panic
> >>
> >> Where would the problem be?
> >>
> >> Barry
> >>
> >>     
> You have to rebuild the initrd to match the kernel and its modules.
> As the kernel develops the initrd scripts need to change to match changes
> in modules required to support the disks for the new kernel.
> I've no experience with 2.6.11 to 2.6.14. We now use 2.6.21
> and know a bit about how to support it on FC4.

yes, i have rebuilt the initrd by the command: 
/sbin/mkinitrd --builtin=ata_piix /boot/initrd-2.6.14.img initrd-2.6.14
> 
> What we did to find differences was to run later versions of Fedora Core
> that support the kernel we want to use out of the box. Then we break open
> the initrd and see what the differences are between the old and new initrd
> files.
how did you analysis the differences? the constent of the file is scale
of two. 
> 
> Barry
> 
> 


