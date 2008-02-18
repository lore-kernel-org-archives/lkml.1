Return-Path: <linux-kernel-owner+w=401wt.eu-S1758611AbYBREKa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758611AbYBREKa (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Feb 2008 23:10:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756128AbYBREKW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Feb 2008 23:10:22 -0500
Received: from fg-out-1718.google.com ([72.14.220.156]:48318 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755845AbYBREKV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Feb 2008 23:10:21 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=EuU5z+th6RjcFZOwmYrJzBOZWBIITYZAJyzfMUpsMMW2o/Yh8bLaYpeBuc2baIjikt0QVsZHTtaNM5OxNB44D9qYi30JSUgsmoWzWVPvCGVxXY3omq35i2vNuvtY7A4V+iRzNIZ7CbFFDZzPz6r3GSEtFH0siLfUpzBR+bIzFMw=
Message-ID: <524f69650802172010vcd1c357nf39baf6cd3cdf9d1@mail.gmail.com>
Date: Sun, 17 Feb 2008 22:10:19 -0600
From: "Steve French" <smfrench@gmail.com>
To: "Randy Dunlap" <randy.dunlap@oracle.com>
Subject: Re: 2.6.25-rc2-mm1 (cifs build errs)
Cc: "Andrew Morton" <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       sfrench@samba.org
In-Reply-To: <20080217161435.345829cf.randy.dunlap@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080216002522.9c4bd0fb.akpm@linux-foundation.org>
	 <20080217161435.345829cf.randy.dunlap@oracle.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks for spotting this - it only would happen if CONFIG_PROC_FS is disabled.
I have fixed it in the cifs-2.6.git tree so should be fine next time akpm pulls.

On Feb 17, 2008 6:14 PM, Randy Dunlap <randy.dunlap@oracle.com> wrote:
> On Sat, 16 Feb 2008 00:25:22 -0800 Andrew Morton wrote:
>
> >
> > ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.25-rc2/2.6.25-rc2-mm1/
>
> CIFS has some build problems:
>
> linux-2.6.25-rc2-mm1/fs/cifs/cifs_debug.c:922: error: static declaration of 'cifs_proc_init' follows non-static declaration
> linux-2.6.25-rc2-mm1/fs/cifs/cifsproto.h:112: error: previous declaration of 'cifs_proc_init' was here
> linux-2.6.25-rc2-mm1/fs/cifs/cifs_debug.c:926: error: static declaration of 'cifs_proc_clean' follows non-static declaration
> linux-2.6.25-rc2-mm1/fs/cifs/cifsproto.h:113: error: previous declaration of 'cifs_proc_clean' was here
> make[3]: *** [fs/cifs/cifs_debug.o] Error 1
>
> .config is attached.
>
> ---
> ~Randy
>



-- 
Thanks,

Steve
