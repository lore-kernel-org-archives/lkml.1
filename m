Return-Path: <linux-kernel-owner+w=401wt.eu-S1761094AbZASNM5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761094AbZASNM5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2009 08:12:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760128AbZASNMp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Jan 2009 08:12:45 -0500
Received: from yw-out-2324.google.com ([74.125.46.28]:14567 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759392AbZASNMn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2009 08:12:43 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        b=aggGw1DKM53OfTb50h1NgtE+wWfdd0bl/IXvJLGm60OQi5gTqT2eCpA9cP5V6++Rj8
         q6hYvTole7UXFtuHisSfV9YKtFf2EsfDBbdgpuHcNxrgnRKyMrqhdoKdZOdid7Gle4FS
         OGbJQfKj2xTMvU0jpL7g6gQ/WUWuJTQlsv5o0=
Date: Mon, 19 Jan 2009 21:12:24 +0800
From: =?utf-8?Q?Am=C3=A9rico?= Wang <xiyou.wangcong@gmail.com>
To: Josef Bacik <jbacik@redhat.com>
Cc: =?utf-8?Q?Am=C3=A9rico?= Wang <xiyou.wangcong@gmail.com>,
       linux-btrfs@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       Chris Mason <chris.mason@oracle.com>, Andrew Morton <akpm@osdl.org>
Subject: Re: [Patch] Btrfs: use BTRFS_VOL_NAME_MAX for struct
	btrfs_ioctl_vol_args
Message-ID: <20090119131224.GC7424@hack.private>
References: <20090119125732.GA7424@hack.private> <20090119130337.GA25475@unused.rdu.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20090119130337.GA25475@unused.rdu.redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 19, 2009 at 08:03:37AM -0500, Josef Bacik wrote:
>On Mon, Jan 19, 2009 at 08:57:32PM +0800, Américo Wang wrote:
>> 
>> I found userspace tool, btrfsctl, uses BTRFS_VOL_NAME_MAX, and
>> it also looks that this one is more proper.
>> 
>> Kill BTRFS_PATH_NAME_MAX since no one will use it.
>> 
>
>Nope, BTRFS_PATH_NAME_MAX is specifically used for the ioctl stuff, makes the
>arguments 4k aligned, this patch is incorrect.  Thanks,

Ok, then what is BTRFS_VOL_NAME_MAX? :)


-- 
"Against stupidity, the gods themselves, contend in vain."

