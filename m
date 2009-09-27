Return-Path: <linux-kernel-owner+w=401wt.eu-S1753917AbZI0Q3S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753917AbZI0Q3S (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Sep 2009 12:29:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753644AbZI0Q3R
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Sep 2009 12:29:17 -0400
Received: from smtp5-g21.free.fr ([212.27.42.5]:39105 "EHLO smtp5-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753484AbZI0Q3R convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Sep 2009 12:29:17 -0400
Message-ID: <4ABF92D7.609@upmc.fr>
Date: Sun, 27 Sep 2009 18:29:11 +0200
From: Bernard Pidoux <bernard.pidoux@upmc.fr>
Organization: Universite Pierre & Marie Curie - Paris 6
User-Agent: Thunderbird 2.0.0.23 (X11/20090822)
MIME-Version: 1.0
To: Arjan van de Ven <arjan@infradead.org>
CC: linux-kernel@vger.kernel.org
Subject: Re: 2.6.31.1 BUG #include <asm/bitsperlong.h>
References: <4ABF4E36.4090703@upmc.fr>	<4ABF5328.8020901@upmc.fr>	<4ABF5E21.9080104@upmc.fr> <20090927151942.1c6a010a@infradead.org>
In-Reply-To: <20090927151942.1c6a010a@infradead.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If it was supposed to install bitsperlong.h in /asm/ magic did not work.

I am a little bit puzzled for the script writes 

  INSTALL include/asm (53 files)

and I can still only list one file in that directory. 


[root@f6bvp-11 linux-2.6.31.1]# make headers_install
  CHK     include/linux/version.h
  HOSTCC  scripts/unifdef
  INSTALL include/asm-generic (34 files)
  INSTALL include/drm (12 files)
  INSTALL include/linux/byteorder (2 files)
  INSTALL include/linux/can (4 files)
  INSTALL include/linux/dvb (8 files)
  INSTALL include/linux/hdlc (1 file)
  INSTALL include/linux/isdn (1 file)
  INSTALL include/linux/netfilter (58 files)
  INSTALL include/linux/netfilter_arp (2 files)
  INSTALL include/linux/netfilter_bridge (16 files)
  INSTALL include/linux/netfilter_ipv4 (46 files)
  INSTALL include/linux/netfilter_ipv6 (21 files)
  INSTALL include/linux/nfsd (6 files)
  INSTALL include/linux/raid (2 files)
  INSTALL include/linux/spi (1 file)
  INSTALL include/linux/sunrpc (1 file)
  INSTALL include/linux/tc_act (6 files)
  INSTALL include/linux/tc_ematch (4 files)
  INSTALL include/linux/usb (8 files)
  INSTALL include/linux/wimax (1 file)
  INSTALL include/linux (353 files)
  INSTALL include/mtd (5 files)
  INSTALL include/rdma (1 file)
  INSTALL include/scsi (4 files)
  INSTALL include/sound (9 files)
  INSTALL include/video (3 files)
  INSTALL include/xen (1 file)
  INSTALL include (0 file)
  INSTALL include/asm (53 files)
[root@f6bvp-11 linux-2.6.31.1]# ll include/asm/
total 8
-rw-r--r-- 1 root root 4890 2009-09-27 14:34 asm-offsets.h


Arjan van de Ven a écrit :
> On Sun, 27 Sep 2009 14:44:17 +0200
> Bernard Pidoux <bernard.pidoux@upmc.fr> wrote:
> 
>> I downloaded again linux-2.6.31.1.tar.bz2 and unpacked it.
>>
>> ll /usr/src/linux-2.6.31.1/include/
>> total 128
>> drwxrwxr-x   3 root root  4096 2009-09-24 17:45 acpi/
>> lrwxrwxrwx   1 root root     7 2009-09-27 14:34 asm -> asm-x86/
>> drwxrwxr-x   3 root root  4096 2009-09-24 17:45 asm-generic/
>> drwxr-xr-x   2 root root  4096 2009-09-27 14:34 asm-x86/
>>
>> and
>>
>> ll /usr/src/linux-2.6.31.1/include/asm/
>> total 8
>> -rw-r--r-- 1 root root 4890 2009-09-27 14:34 asm-offsets.h
>>
>> So, I think that the kernel header problem is in the linux package,
>> not in my system installation.
> 
> do not count until you have done "make headers_install"... there is
> magic there that fixes up a bunch of things.
> .
> 
> 

