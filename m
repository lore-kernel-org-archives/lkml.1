Return-Path: <linux-kernel-owner+w=401wt.eu-S1756825AbZDURmc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756825AbZDURmc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Apr 2009 13:42:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753559AbZDURmX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Apr 2009 13:42:23 -0400
Received: from gw-ca.panasas.com ([209.116.51.66]:12509 "EHLO
	laguna.int.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753191AbZDURmW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Apr 2009 13:42:22 -0400
Message-ID: <49EE056C.1060605@panasas.com>
Date: Tue, 21 Apr 2009 20:42:04 +0300
From: Benny Halevy <bhalevy@panasas.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.1b3pre) Gecko/20090223 Thunderbird/3.0b2
MIME-Version: 1.0
To: Trond Myklebust <trond.myklebust@fys.uio.no>
CC: subrata@linux.vnet.ibm.com, NFS list <linux-nfs@vger.kernel.org>,
       Stephen Rothwell <sfr@canb.auug.org.au>,
       linux-next <linux-next@vger.kernel.org>,
       sachinp <sachinp@linux.vnet.ibm.com>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Alexander Beregalov <a.beregalov@gmail.com>,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: [BUILD FAILURE 03/04] Next April 21 : x86_64 randconfig	[fs/nfs/nfs.ko]
References: <1240332715.9110.39.camel@subratamodak.linux.ibm.com>
In-Reply-To: <1240332715.9110.39.camel@subratamodak.linux.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 21 Apr 2009 17:42:16.0073 (UTC) FILETIME=[82C0AF90:01C9C2A8]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Apr. 21, 2009, 19:51 +0300, Subrata Modak <subrata@linux.vnet.ibm.com> wrote:
> I think i am observing this for the first time in any randconfig builds:
> 
> BUILD   arch/x86/boot/bzImage
> Root device is (8, 3)
> Setup is 13020 bytes (padded to 13312 bytes).
> System is 5625 kB
> CRC a80d60ee
> Kernel: arch/x86/boot/bzImage is ready  (#1)
>   Building modules, stage 2.
>   MODPOST 514 modules
> ERROR: "find_last_bit" [fs/nfs/nfs.ko] undefined!
> make[1]: *** [__modpost] Error 1
> make: *** [modules] Error 2
> ---
> 
> Regards--
> Subrata
> 

Trond, can you please merge
http://git.linux-nfs.org/?p=bhalevy/linux-pnfs.git;a=commitdiff;h=9f32944d1bca79038ef3e9c9a27f11803d093d8e
into your nfsv41 and linux-next branches?

I've placed it right before "nfs41: free slot"
in git://git.linux-nfs.org/projects/bhalevy/linux-pnfs.git nfs41-for-2.6.31

(see also this thread:
http://article.gmane.org/gmane.linux.kernel.next/6951)

Thanks,

Benny
