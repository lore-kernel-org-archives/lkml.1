Return-Path: <linux-kernel-owner+w=401wt.eu-S933549AbXJPO3T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933549AbXJPO3T (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2007 10:29:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932588AbXJPO3K
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Oct 2007 10:29:10 -0400
Received: from smtp106.plus.mail.re1.yahoo.com ([69.147.102.69]:46377 "HELO
	smtp106.plus.mail.re1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S932412AbXJPO3J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2007 10:29:09 -0400
X-Greylist: delayed 400 seconds by postgrey-1.27 at vger.kernel.org; Tue, 16 Oct 2007 10:29:09 EDT
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=Received:X-YMail-OSG:Date:From:X-X-Sender:To:cc:Subject:In-Reply-To:Message-ID:References:MIME-Version:Content-Type;
  b=akM0+42tI/BIy9qBq8LPS2ng6yVM0NcC0Mg7LDGOlqtRIli5Wr9YpZeuBdIaixNDttJFESksHCINMFwCHFqiG2vS7FzlvI2rfr/auhTUYyrKQDRv5oz7LkK87KhaNiBKfoxR3mo3U/py+gO7SykHAKYdR4XhlJB06Qnu52+Og9M=  ;
X-YMail-OSG: _jSJVpsVM1lwdW4ofPMRs0DecSg.HJPA71EbCNv9BGrEQfHFyTTIWoMIhTAfxjgOywITMgKmWrtWfF4fjCCZMBo.gMRMfMy86xnVqkyylZGBXtKzuvqr2.gidDcA
Date: Tue, 16 Oct 2007 10:13:38 -0400 (EDT)
From: "J. Scott Kasten" <jscottkasten@yahoo.com>
X-X-Sender: jsk@pixie.tetracon-eng.net
To: veerasena reddy <veerasena_b@yahoo.co.in>
cc: "linux-kernel.org" <linux-kernel@vger.kernel.org>,
       linux-mips <linux-mips@linux-mips.org>
Subject: Re: how to use TLB to prevent Linux accessing a particular memory
 region 
In-Reply-To: <431051.14949.qm@web8408.mail.in.yahoo.com>
Message-ID: <Pine.LNX.4.64.0710161001550.21385@pixie.tetracon-eng.net>
References: <431051.14949.qm@web8408.mail.in.yahoo.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Really, it sounds more like you want a custom driver that "owns" that 
region of memory so it's marked as used and this driver is the gate 
keeper.  I wonder if the console frame buffer driver for the mips ip32 
arch might be a good example for you as it swallows a several meg chunk of 
memory for the display.

-S-

On Tue, 16 Oct 2007, veerasena reddy wrote:

> Hi,
>
> I have a board, which has two processors ( one is MIPS
> on which Linux-2.6.18 kernel runs and another is DSP
> based processor) and 32MB DDR.
>
> Out of 32MB of DDR 8MB is reserved for use by DSP
> processor. But the MIPS processor downloads firmware
> into this reserved memory for the DSP.
>
> Now, is it possible to use the TLB to prevent Linux
> from accessing the reserved memory after the firmware
> has been downloaded?
>
> Also we'd need to remove those TLB entries if the
> firmware would ever need to be reloaded to the DSP'
> memory region.
>
> What are the APIs to be used to achieve the above?
>
>
> Thanks in advance.
>
> Regards,
> Veerasena.
>
>
>      5, 50, 500, 5000 - Store N number of mails in your inbox. Go to http://help.yahoo.com/l/in/yahoo/mail/yahoomail/tools/tools-08.html
>
>
