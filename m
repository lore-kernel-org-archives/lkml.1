Return-Path: <linux-kernel-owner+w=401wt.eu-S1756212AbYABDNV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756212AbYABDNV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jan 2008 22:13:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753803AbYABDNO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Jan 2008 22:13:14 -0500
Received: from smtpoutm.mac.com ([17.148.16.71]:52266 "EHLO smtpoutm.mac.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753657AbYABDNN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jan 2008 22:13:13 -0500
In-Reply-To: <1199241738.3300.63.camel@perihelion>
References: <Pine.LNX.4.44.0712311233290.17732-100000@hpcnc.cpe.ku.ac.th> <1199241738.3300.63.camel@perihelion>
Mime-Version: 1.0 (Apple Message framework v752.2)
Content-Type: text/plain; charset=US-ASCII; delsp=yes; format=flowed
Message-Id: <B7507F00-92C9-4632-9A4C-D969AB03A090@mac.com>
Cc: Theewara Vorakosit <thvo@hpcnc.cpe.ku.ac.th>, linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 7bit
From: Kyle Moffett <mrmacman_g4@mac.com>
Subject: Re: Get physical MAC address
Date: Tue, 1 Jan 2008 22:12:23 -0500
To: Jon Masters <jonathan@jonmasters.org>
X-Mailer: Apple Mail (2.752.2)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Jan 01, 2008, at 21:42:18, Jon Masters wrote:
> On Mon, 2007-12-31 at 12:39 +0700, Theewara Vorakosit wrote:
>> I get MAC address from ioctl. However, ifconfig can change this   
>> MAC address. Can I get a real physical MAC address of the NIC?
>
> Forgive me reading into your mail...this smells a bit like some  
> kind of licensing/compliance thing. Just bear in mind that using  
> the MAC to verify the identity of a machine is utterly useless and  
> pointless - anyone can trivially fool your software[0] to see what  
> it "wants".

Not necessarily;  I can easily see distros wanting to have a "Restore  
defaults" button in their network config windows which also includes  
restoring the default MAC address to the NIC.  It should also be  
pointed out that anybody with one of a selection of re-flashable NICS  
(or NICS with removable EEPROMS) can easily change the MAC address on  
their NIC.  Other alternatives includes renaming eth0 to mynet0 and  
creating a downed dummy interface called "eth0" with the desired MAC  
addr.


> [0] We used to have to do far worse kludgery in college, in order  
> to prevent the silly powers that be who "banned" network cards  
> other than those made by one manufacturer from being used on their  
> little network.

Well for basically any userspace-level check, all it takes is  
somebody who knows ASM and has about 5 minutes to track down the  
problematic branch instructions.  Then they just have to write a 10- 
line GDB script which starts the program, traps the appropriate  
instructions, and then changes a "0" to a "1" (or vice versa) before  
the conditional branch.  On Windows it's vaguely practical (albeit  
crash-prone) to load a kernel hack which prevents your program from  
being debugged, but under Linux it's effectively impossible

Cheers,
Kyle Moffett

