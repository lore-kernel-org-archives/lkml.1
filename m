Return-Path: <linux-kernel-owner+w=401wt.eu-S1756157AbZDTOZW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756157AbZDTOZW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Apr 2009 10:25:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755866AbZDTOZI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Apr 2009 10:25:08 -0400
Received: from yx-out-2324.google.com ([74.125.44.29]:35673 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755768AbZDTOZH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Apr 2009 10:25:07 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=oq4ZCwAsmV4ZGX9VhSCMAj89O+Zxg8UM4msQycoluACDlBK8nDNYL7FYAfMmZpUf8c
         tYfuxp7hIrBazIm1/jEi9XDFmr/EX7ZYE81u+uKGGPMm8wyA8SwyfOg9REOoIKIzDvRh
         KKBLBWyGsTrfWnMo42+11uVde7X4PbVWEVyMo=
MIME-Version: 1.0
In-Reply-To: <49EC8317.9080300@suse.com>
References: <a4423d670904161223r2e026b6u903137c709318551@mail.gmail.com>
	 <49EC8317.9080300@suse.com>
Date: Mon, 20 Apr 2009 18:25:05 +0400
Message-ID: <a4423d670904200725x69d28139h812524390c6de8e5@mail.gmail.com>
Subject: Re: 2.6.30-rc2: reiserfs_delete_xattrs: Couldn't delete all xattrs 
	(-13)
From: Alexander Beregalov <a.beregalov@gmail.com>
To: Jeff Mahoney <jeffm@suse.com>
Cc: ReiserFS Development List <reiserfs-devel@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/4/20 Jeff Mahoney <jeffm@suse.com>:
> -----BEGIN PGP SIGNED MESSAGE-----
> Hash: SHA1
>
> Alexander Beregalov wrote:
>> Hi Jeff
>>
>> The kernel prints this message every 20seconds
>> [  836.973100]
>> [  836.983494] REISERFS warning (device sda2): jdm-20004
>> reiserfs_delete_xattrs: Couldn't delete all xattrs (-13)
>> [  836.983496]
>> [  894.203634] REISERFS warning (device sda2): jdm-20004
>> reiserfs_delete_xattrs: Couldn't delete all xattrs (-13)
>> [  894.203636]
>> [  894.205784] REISERFS warning (device sda2): jdm-20004
>> reiserfs_delete_xattrs: Couldn't delete all xattrs (-13)
>>
>> commit a41f1a4715
>>
>> CONFIG_REISERFS_FS=y
>> # CONFIG_REISERFS_CHECK is not set
>> # CONFIG_REISERFS_PROC_INFO is not set
>> # CONFIG_REISERFS_FS_XATTR is not set
>>
>> I did not enable XATTR before,
>> should I enable it now ?
>
> You shouldn't need to, and you shouldn't be seeing those messages.
>
> What are you doing to reproduce it? I disabled the xattr config option,
> copied a directory tree over and removed it. I didn't see anything.
Just regular work. For example kernel compiling.
I see that messages on 2 of 3 systems (x86 and parisc). The third
system is x86 also,
no messages at all. I do not know how to "switch" messages on.
Let me know if I can help, perhaps dump superblock or something.
