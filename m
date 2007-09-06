Return-Path: <linux-kernel-owner+w=401wt.eu-S933071AbXIFXhv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933071AbXIFXhv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Sep 2007 19:37:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932661AbXIFXhj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Sep 2007 19:37:39 -0400
Received: from smtpoutm.mac.com ([17.148.16.73]:54451 "EHLO smtpoutm.mac.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932621AbXIFXhi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Sep 2007 19:37:38 -0400
X-Greylist: delayed 355 seconds by postgrey-1.27 at vger.kernel.org; Thu, 06 Sep 2007 19:37:38 EDT
In-Reply-To: <20070906150616.GA28565@fieldses.org>
References: <Pine.LNX.4.64.0708301610290.24730@fbirervta.pbzchgretzou.qr> <1188484155.6755.38.camel@heimdal.trondhjem.org> <1188484337.6755.41.camel@heimdal.trondhjem.org> <Pine.LNX.4.64.0708301640030.24730@fbirervta.pbzchgretzou.qr> <1188486240.6755.51.camel@heimdal.trondhjem.org> <20070830214431.GF10808@fieldses.org> <alpine.LFD.0.999.0709061333410.3781@enigma.security.iitk.ac.in> <20070906150616.GA28565@fieldses.org>
Mime-Version: 1.0 (Apple Message framework v752.2)
Content-Type: text/plain; charset=US-ASCII; delsp=yes; format=flowed
Message-Id: <0D66E86D-8D97-45D7-9C2A-7AB5F42845B5@mac.com>
Cc: Satyam Sharma <satyam@infradead.org>,
       Trond Myklebust <trond.myklebust@fys.uio.no>,
       Jan Engelhardt <jengelh@computergmbh.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Transfer-Encoding: 7bit
From: Kyle Moffett <mrmacman_g4@mac.com>
Subject: Re: NFS4 authentification / fsuid
Date: Thu, 6 Sep 2007 19:30:25 -0400
To: "J. Bruce Fields" <bfields@fieldses.org>
X-Mailer: Apple Mail (2.752.2)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sep 06, 2007, at 11:06:16, J. Bruce Fields wrote:
> On Thu, Sep 06, 2007 at 01:44:05PM +0530, Satyam Sharma wrote:
>> Like Trond said, there are very high number of ways in which  
>> privileged userspace can compromise a running kernel if it really  
>> wants to do that, root-is-God has always been *the* major problem  
>> with Unix :-)
>>
>> The only _real_ way a kernel can lock itself completely against  
>> malicious userspace involves trusted tamperproof hardware,
>
> The question of how to protect against someone with *physical*  
> access certainly is more difficult, but surely that's a separate  
> problem.

Actually, that's a fairly simple problem (barring disassembling the  
system and attaching a hardware debugger).  You encrypt the root  
filesystem and require a password to boot (See: LUKS).  Debian has  
built-in support for installing onto fs-on-LVM-on-crypt-on-RAID, and  
it works quite well on all the laptops I use regularly.  It's not  
even much of a speed penalty; once you take the overhead of hitting a  
5400RPM laptop drive you can chew thousands of cycles of CPU without  
anybody noticing (much).  Then all you have to do is burn a copy of  
your /boot with bootloader onto some read-only media (like a  
finalized CDROM/DVDROM) and you're set to go.

Cheers,
Kyle Moffett
