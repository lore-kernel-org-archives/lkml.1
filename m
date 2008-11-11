Return-Path: <linux-kernel-owner+w=401wt.eu-S1755460AbYKKLUJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755460AbYKKLUJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2008 06:20:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755490AbYKKLTp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Nov 2008 06:19:45 -0500
Received: from ik-out-1112.google.com ([66.249.90.177]:62116 "EHLO
	ik-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755421AbYKKLTo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2008 06:19:44 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=nz+CbUgy9KY2fokdK83CmlgCTe7YDd/meD+1RfJ7m3KDieMmT29+02FaQyEi155utS
         LJ2NOQ/p3qgCg9UfqE5C2X773WMzQjPHMGqQ1zlgMmnms/PhzsFeN2NrVV2FeuGOvl23
         ga/IBxKOSFgWo2SiYxCF2QDKL2FsCFiWF/XXM=
Date: Tue, 11 Nov 2008 11:19:22 +0000
From: =?utf-8?Q?Am=C3=A9rico?= Wang <xiyou.wangcong@gmail.com>
To: Eric Buddington <ebuddington@verizon.net>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com
Subject: Re: /init not found in initramfs in 2.6.27.[34]
Message-ID: <20081111111922.GA8485@hack.voiplan.pt>
References: <20081110232313.GA29539@pool-96-236-120-128.spfdma.east.verizon.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081110232313.GA29539@pool-96-236-120-128.spfdma.east.verizon.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 10, 2008 at 11:23:14PM +0000, Eric Buddington wrote:
>I am successfully booting into an initramfs under 2.6.26.5.
>
>However, on 2.6.27.3 and 2.6.27.4, the kernel uncompresses the
>initramfs, then complains that it can't find /init. I am using the
>same initramfs.cpio.gz in all cases, and the newer kernels have a
>.config derived from the working kernel
>
>I have tried compiling the initramfs into the kernel, loading it via
>the initrd= parameter, and doing both simultaneously, with no success.
>
>I see no discussion of this on the lists, so it's probable that I'm
>doing something stupid - but I can't see what would have changed
>between kernels and I know the initramfs.cpio.gz is good.
>

Looks weird...


>Here is the .config from my non-working 2.6.27.4:
>

<snip>

Do you use the same config for 2.6.26.5 and 2.6.27.4 ?
If not, could you please send the diff between these two configs?

Thanks.

Cc: hpa@zytor.com

-- 
"Sometimes The Only way to stay sane is to go a little crazy."

