Return-Path: <linux-kernel-owner+w=401wt.eu-S1760270AbXIYEU3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760270AbXIYEU3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2007 00:20:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752883AbXIYEUS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Sep 2007 00:20:18 -0400
Received: from smtpoutm.mac.com ([17.148.16.77]:52294 "EHLO smtpoutm.mac.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750764AbXIYEUQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2007 00:20:16 -0400
In-Reply-To: <20070924173223.GL5386@csclub.uwaterloo.ca>
References: <200709211201.24475.vda.linux@googlemail.com> <200709211905.23946.vda.linux@googlemail.com> <p73ps0b93ph.fsf@bingen.suse.de> <200709212337.53043.vda.linux@googlemail.com> <20070924173223.GL5386@csclub.uwaterloo.ca>
Mime-Version: 1.0 (Apple Message framework v752.2)
Content-Type: text/plain; charset=US-ASCII; delsp=yes; format=flowed
Message-Id: <1565FDF8-3BC6-4E46-93E1-48F40C7E1F8D@mac.com>
Cc: Denys Vlasenko <vda.linux@googlemail.com>,
       Andi Kleen <andi@firstfloor.org>, David Miller <davem@davemloft.net>,
       jeff@garzik.org, mchan@broadcom.com, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org
Content-Transfer-Encoding: 7bit
From: Kyle Moffett <mrmacman_g4@mac.com>
Subject: Re: [PATCH 1/2] bnx2: factor out gzip unpacker
Date: Tue, 25 Sep 2007 00:20:10 -0400
To: Lennart Sorensen <lsorense@csclub.uwaterloo.ca>
X-Mailer: Apple Mail (2.752.2)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sep 24, 2007, at 13:32:23, Lennart Sorensen wrote:
> On Fri, Sep 21, 2007 at 11:37:52PM +0100, Denys Vlasenko wrote:
>> But I compile net/* into bzImage. I like netbooting :)
>
> Isn't it possible to netboot with an initramfs image?  I am pretty  
> sure I have seen some systems do exactly that.

Yeah, I've got Debian boxes that have never *not* netbooted (one Dell  
Op^?^?Craptiplex box whose BIOS and ACPI sucks so bad it can't even  
load GRUB/LILO, although Windows somehow works fine).  So they boot  
PXELinux using the PXE boot ROM on the NICs and it loads both a  
kernel and an initramfs into memory.  Kernel is stock Debian and  
hardly has enough built-in to spit at you, let alone find network/ 
disks, but it manages to load everything it needs off the  
automagically-generated initramfs.

Cheers,
Kyle Moffett

