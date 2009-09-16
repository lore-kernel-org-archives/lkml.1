Return-Path: <linux-kernel-owner+w=401wt.eu-S1758882AbZIPSlR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758882AbZIPSlR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Sep 2009 14:41:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758811AbZIPSlO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Sep 2009 14:41:14 -0400
Received: from mail-bw0-f219.google.com ([209.85.218.219]:41458 "EHLO
	mail-bw0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756892AbZIPSlH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Sep 2009 14:41:07 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :content-type:content-transfer-encoding;
        b=BoWb9VkVIMHcq/NNoCMImJds1gqyzUZaIjc8Rjh8XOm0De3YKTZXcbjnn8vyXXOxbf
         ut4yULnTtBrMNmd8/NbNdg31/+BrxqarDO+9ecnJ+EwS1/BMnhOihxEXM71CzXfU5keU
         FgKLAVnZs59vDqSxa136tKOsIDqndT7ztCyiM=
MIME-Version: 1.0
In-Reply-To: <20090916163822.GA15451@mit.edu>
References: <194f62550909090403x16e61cc1g3a23593085de0b@mail.gmail.com>
	 <194f62550909160532q248cb45coee639a2da10292a@mail.gmail.com>
	 <20090916163822.GA15451@mit.edu>
Date: Wed, 16 Sep 2009 14:41:09 -0400
Message-ID: <194f62550909161141n5730049cra2643ce1654a7aaf@mail.gmail.com>
Subject: Re: Howto switch off ext4's delayed allocation?
From: Clemens Eisserer <linuxhippy@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Theodore,

Thanks a lot for your work on linux filesystems through the years.

> Sounds like eclipse is broken; most Unix editors (emacs, vim, etc.) do
> correctly use fsync() when writing precious files, such people's
> source files.  In addition, it must be writing the data through a
> decidedly non-standard way.  Is it out-and-out deleting the file
> before writing the new version of the file, or something insane like
> that?  Ext4's hueristics are designed so that for the most common ways
> that applications update files, the data gets forced to disk.  It
> sounds like Eclipse is doing something decidedly non-standard.

I've seen zero-length files after crashes (mostly caused by the intel
2D driver, just updated from 2.8.0 to 2.8.99, hope its better now) by
files edited with kwrite, eclipse and I've even had empty
.bash_history files.
I understand these are application's faults, but for now I had more
troubles with this feature than the additional performance is worth
for me.
My machine is a laptop, where is quite common to suddenly loose power
(my battery is dead).

> If you can run a strace on eclipse while and then arrange to edit an
> existing file and save it, it would be interesting to see what the
> heck it is doing.
I'll have a look.


>> Isn't there a way to switch off the more "dangerous" optimizations in ext4?
>
> The mount option nodelalloc will turn off delayed allocation.  This is
> documented in Documentation/filesystems/ext4.txt.
Thanks :)

- Clemens
