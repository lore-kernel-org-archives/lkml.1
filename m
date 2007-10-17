Return-Path: <linux-kernel-owner+w=401wt.eu-S932456AbXJQRU2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932456AbXJQRU2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2007 13:20:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759322AbXJQRUE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Oct 2007 13:20:04 -0400
Received: from exchange.comtrol.com ([204.73.219.163]:44476 "EHLO
	Exchange.comtrol.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760908AbXJQRUA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2007 13:20:00 -0400
X-Greylist: delayed 793 seconds by postgrey-1.27 at vger.kernel.org; Wed, 17 Oct 2007 13:20:00 EDT
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Subject: Re: RocketPort Linux driver errors on module reload
Date: Wed, 17 Oct 2007 12:06:47 -0500
Message-ID: <B1F576FE19C55C43B8D2E31F061B50C062C3EE@exchange.comtrol.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: Re: RocketPort Linux driver errors on module reload
Thread-Index: AcgQ4Bn5/4pAOErXQ1GlecOUGLjRHQ==
From: "Nick Thompson" <Nick.Thompson@comtrol.com>
To: <linux-kernel@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

>On 10/15/2007 02:57 PM, Ferenc Wagner wrote:
>> You are the man, Jiri!  That indeed fixes the problem.
>> Thank you very much.  What a turnaround...
>
>You're welcome, that's why we're here.
>
>> Shouldn't Documentation/rocket.txt also be changed?  I'm not sure
>> whether that support email is still valid.
>
>And so am I. I wouldn't change it, maybe they will contact you some later ;).
>

Darn. I don't read the mailing list for one day and there is a Comtrol related post. ;)
Anyhow, as far as the support address, Comtrol and Comtrol UK are now separate companies. I work for Comtrol. The address you will want to send Linux related Comtrol issues to is support@comtrol.com. You can also email me directly if you wish, as I handle Linux issues here in tech support at Comtrol. As far as changing the address in the rocket.txt file, it would be a good idea to change it to support@comtrol.com.

>Anyway the driver faces another problem with pci refcounting (it doesn't
>increment the counter) and the device might be removed from it any time the pci
>bus code decides. Are you willing to test to-pci-probing patches (i.e. patches
>which converts the driver to the model introduced in linux 2.4)? If not, I'll
>only increment the counter on modprobe and decrement it on rmmod, since it would
>be a safe (in the meaning of not changing that much code) way of fixing the problem.
>
>thanks,
>-- 
>Jiri Slaby (jirislaby@gmail.com)
>Faculty of Informatics, Masaryk University

I've been wanting to get the driver that is included in the kernel up to date, and there is an active project here at comtrol to get the current code (driver version 3.08 beta) up to Linux kernel programming standards. The driver version that is included in the kernel (and has been patched a bit I'm sure since it's been in there a while) is version 2.09. The latest version (3.08 beta) can be obtained from: 

ftp://ftp.comtrol.com/beta/rport/drivers/u_pci/linux/rocketport-linux-3.08.tar.gz

If anyone has any helpful pointers (no pun intended) or comments on the code, I'd love to listen. 

Regards,

Nick

Nick Thompson
Technical Support Specialist nick.thompson@comtrol.com
Comtrol Corporation ftp://ftp.comtrol.com
6655 Wedgwood Rd. Ste 120 http://www.comtrol.com
Maple Grove, MN. 55311 Sales: (800)GO-ROCKET
