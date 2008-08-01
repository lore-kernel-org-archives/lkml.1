Return-Path: <linux-kernel-owner+w=401wt.eu-S1754023AbYHAA2T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754023AbYHAA2T (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2008 20:28:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752244AbYHAA2G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Jul 2008 20:28:06 -0400
Received: from rv-out-0506.google.com ([209.85.198.227]:14735 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752216AbYHAA2D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2008 20:28:03 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:mime-version:content-type
         :content-transfer-encoding:content-disposition:x-google-sender-auth;
        b=CQNLoS+afOzTRIGpvtd4cKuvNLSkBmQoLr0AN7OlIQyOuAQbrUxcenMe5HneNwBGvm
         uX6AQViU9XBZAqT8Kw96NMRV159fD8AUqYl/7VS2jmf0XH98ilF+MocafzHBZNuulIRb
         HFZb7hB+ymOuLk/dwEw2V0d9FuYBnWJ+1fffE=
Message-ID: <1bcc666d0807311727u1be8bc41t41ee6b8741f6b6cf@mail.gmail.com>
Date: Thu, 31 Jul 2008 17:27:54 -0700
From: "Nancy Isaac" <nancy.isaac@pobox.com>
To: linux-kernel@vger.kernel.org
Subject: JFFS2 Questions
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
X-Google-Sender-Auth: 808d8423c7416d9c
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Please let me know if I have emailed the wrong group with these questions.

I have been working on bringing up an embedded system with 8313
processor, 128MB ram, 32MB  NOR and 512MB NAND flash.
We are using 2.6.21 kernel.  We boot out of NOR using u-boot and
program the NAND flash with jffs2 images for kernel and root file
system.
My first question is very basic. my rootfs.jffs2 image is 59MB when I
create it using mkfs.jffs2 and do an ls -l on the file.
What is the size of the image stored in the NAND flash?  I have
compression enabled, so I expected it to be still 50MB.  When I do a
du on the root file system after it's been mounted on the NAND flash,
it shows the size as 114MB.  I am wondering about the difference
because I need to figure out how much space to allocate to accomodate
an upgrade.  Do I base it on the 59MB size or the 114MB size?

The second question is about the boot time.  With the 59MB file
system, it takes about 5 minutes to boot up and mount the file system.
 I know that JFFS2 is slower for boot up due to the scanning that
happens at the beginning, but 5 minutes seems too long and makes me
think I am doing something really wrong.  I added printk time stamps
to see if I can see where the time is being spent. It looks like the
kernel bootup is pretty fast (30secs), but after I get to "Freeing
unused kernel memory", it stays there for a long time with no output
to the screen and then finally the init scripts start running and I
get some output.  Are there any other tools I can use to figure out
what's going on at this time?

Thanks
Nancy
