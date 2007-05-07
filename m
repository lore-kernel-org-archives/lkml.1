Return-Path: <linux-kernel-owner+w=401wt.eu-S1754785AbXEGSmd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754785AbXEGSmd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 May 2007 14:42:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754767AbXEGSmc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 May 2007 14:42:32 -0400
Received: from main.gmane.org ([80.91.229.2]:52611 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754766AbXEGSmb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 May 2007 14:42:31 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Bill Davidsen <davidsen@tmr.com>
Subject: Re: mkfs.ext2 triggerd RAM corruption
Date: Mon, 07 May 2007 14:42:18 -0400
Message-ID: <f1nrtn$qqv$1@sea.gmane.org>
References: <200705041659.51675.bs@q-leap.de> <20070504203956.GL25077@lug-owl.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Complaints-To: usenet@sea.gmane.org
X-Gmane-NNTP-Posting-Host: mail.tmr.com
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.0.8) Gecko/20061105 SeaMonkey/1.0.6
In-Reply-To: <20070504203956.GL25077@lug-owl.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jan-Benedict Glaw wrote:
> On Fri, 2007-05-04 16:59:51 +0200, Bernd Schubert <bs@q-leap.de> wrote:
>> To see whats going on, I copied the entire / (so the initrd) into a tmpfs 
>> root, chrooted into it, also bind mounted the main / into this chroot and 
>> compared several times /bin of chroot/bin and the bind-mounted /bin while the 
>> mkfs.ext2 command was running.
>>
>> beo-05:/# diff -r /bin /oldroot/bin/
>> beo-05:/# diff -r /bin /oldroot/bin/
>> beo-05:/# diff -r /bin /oldroot/bin/
>> Binary files /bin/sleep and /oldroot/bin/sleep differ
>> beo-05:/# diff -r /bin /oldroot/bin/
>> Binary files /bin/bsd-csh and /oldroot/bin/bsd-csh differ
>> Binary files /bin/cat and /oldroot/bin/cat differ
>> ...
>>
>> Also tested different schedulers, at least happens with deadline and 
>> anticipatory.
>>
>> The corruption does NOT happen on running the mkfs command on /dev/sda1, but 
>> happens with sda2, sda3 and sda3. Also doesn't happen with extended 
>> partitions of sda1.
> 
> Is sda2 the largest filesystem out of sda2, sda3 (and the logical
> partitions within the extended sda1, if these get mkfs'ed, too)?
> 
> I'm not too sure that this is a kernel bug, but probably a bad RAM
> chip. Did you run memtest86 for a while? ...and can you reproduce this
> problem on different machines?
> 
> MfG, JBG
> 
Was this missing from your copy of the original post, or did you delete 
it without reading? Note last sentence...

> Summary: The system ramdisk (initrd) gets corrupted while running 
> mkfs.ext2 on a local sata disk partition.
> 
> Reproduced on kernel versions: vanilla 2.6.16 - 2.6.20 (<2.6.16 
> doesn't run on any of the systems I can do tests with). Please note:
> I could reproduce this on serveral systems, all of them use ECC
> memory and the memory of most of them the memory is monitored using
> EDAC.


-- 
Bill Davidsen <davidsen@tmr.com>
   "We have more to fear from the bungling of the incompetent than from
the machinations of the wicked."  - from Slashdot

