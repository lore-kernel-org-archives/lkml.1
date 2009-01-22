Return-Path: <linux-kernel-owner+w=401wt.eu-S1755628AbZAVQL0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755628AbZAVQL0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2009 11:11:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753304AbZAVQLQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Jan 2009 11:11:16 -0500
Received: from mail-ew0-f20.google.com ([209.85.219.20]:46737 "EHLO
	mail-ew0-f20.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751161AbZAVQLP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2009 11:11:15 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        b=jNV741aiW1CrqkeKKK1+aIzw0JXkUia7MW+twmrMBYsOxX7zUzLwegX831r1EBV4DQ
         8bY3FoDx5Xx0EtnOfcpKcOHXMDw2lPW9ZGT8mvtV8KxgSoczmcpaqfIwwqv+GBI9S4u5
         /36nJCwVPdI0yEqIdDa1zpLqFB+RPmPRyc9CU=
Date: Fri, 23 Jan 2009 00:11:04 +0800
From: =?utf-8?Q?Am=C3=A9rico?= Wang <xiyou.wangcong@gmail.com>
To: Chris Mason <chris.mason@oracle.com>
Cc: Josef Bacik <jbacik@redhat.com>, linux-btrfs@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>, Andrew Morton <akpm@osdl.org>
Subject: Re: [Patch] Btrfs: use BTRFS_VOL_NAME_MAX for struct
	btrfs_ioctl_vol_args
Message-ID: <20090122161104.GF9732@hack.private>
References: <20090119125732.GA7424@hack.private> <20090119130337.GA25475@unused.rdu.redhat.com> <20090119131224.GC7424@hack.private> <1232550248.17244.7.camel@think.oraclecorp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1232550248.17244.7.camel@think.oraclecorp.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 21, 2009 at 10:04:08AM -0500, Chris Mason wrote:
>On Mon, 2009-01-19 at 21:12 +0800, Américo Wang wrote:
>> On Mon, Jan 19, 2009 at 08:03:37AM -0500, Josef Bacik wrote:
>> >On Mon, Jan 19, 2009 at 08:57:32PM +0800, Américo Wang wrote:
>> >> 
>> >> I found userspace tool, btrfsctl, uses BTRFS_VOL_NAME_MAX, and
>> >> it also looks that this one is more proper.
>> >> 
>> >> Kill BTRFS_PATH_NAME_MAX since no one will use it.
>> >> 
>> >
>> >Nope, BTRFS_PATH_NAME_MAX is specifically used for the ioctl stuff, makes the
>> >arguments 4k aligned, this patch is incorrect.  Thanks,
>> 
>> Ok, then what is BTRFS_VOL_NAME_MAX? :)
>
>Right now it is only used in the progs.  The disk format doesn't really
>have a max there, it is just to keep names usable.  But, we should add a
>check in the kernel ioctl side, are you interested in sending a patch
>for it?
>

Yup, I will do.

Thanks.

-- 
"Against stupidity, the gods themselves, contend in vain."

