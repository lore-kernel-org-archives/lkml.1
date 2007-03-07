Return-Path: <linux-kernel-owner+w=401wt.eu-S965544AbXCGRWV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965544AbXCGRWV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2007 12:22:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422927AbXCGRVU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Mar 2007 12:21:20 -0500
Received: from smtp004.mail.ukl.yahoo.com ([217.12.11.35]:36579 "HELO
	smtp004.mail.ukl.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1422957AbXCGRVI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2007 12:21:08 -0500
X-Greylist: delayed 400 seconds by postgrey-1.27 at vger.kernel.org; Wed, 07 Mar 2007 12:21:08 EST
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=Received:X-YMail-OSG:From:Organization:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=v4v6FDZy9AnbmOY18aeLvykrqDX5p6ysVcDqNcP9hLbMrFdIs23GhXsSgvjRPDVXwXCVxWXbmnnL7sPk5ptMYZYvRijv0y4j0MHPmCQ11rF941v/2cudm6/1v1fLRxNrlVvkCAiZ6b0CnQixE6JjwgiYekL6+UQcIvhZvjiXOSo=  ;
X-YMail-OSG: m0yubUsVM1mBKsmk9dT2or2kPiJLAlM1IpzlD.Dw_cDxr2DC6o1gSETAlTW1lHSjNToz1mktyoCyfCRYidBR7JZ8lZqOmwXTAv_0Q.Tnfir.nTSDUMn_g7qtfZApOLqduW43vOTjo9FC
From: Stephen Mollett <molletts@yahoo.com>
Organization: Organisation? What's that?
To: linux-parport@lists.infradead.org
Subject: Re: [Linux-parport] Linux v2.6.21-rc3
Date: Wed, 7 Mar 2007 17:14:21 +0000
User-Agent: KMail/1.9.6
Cc: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Tim Waugh <tim@cyberelk.net>
References: <Pine.LNX.4.64.0703062050570.5963@woody.linux-foundation.org> <45EEB99D.7020406@googlemail.com>
In-Reply-To: <45EEB99D.7020406@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200703071714.21572.molletts@yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 07 Mar 2007, Michal Piotrowski wrote:
> BTW. Does anyone care about parport console?
> console=lp0 hangs since at least 2.6.18

For the record, I used console=lp0 quite recently (stock 2.6.19 according to 
the printout, running on i386) [to find out what was causing a panic that 
immediately vanished off the top of the screen because of "atkbd.c: Spurious 
ACK..."s from the flashing kb LEDs] and it worked just fine.

The parport-related lines went:

lp: driver loaded but no devices found
parport: PnPBIOS parport detected.
parport0: PC-style at 0x378, irq 7 [PCSPP,TRISTATE,EPP]
parport0: Printer, EPSON Stylus COLOR 600
lp0: using parport0 (interrupt-driven)
lp0: console ready

... then the kernel continued booting until the panic occurred (it was a silly 
storage-related misconfig on my part).

If anyone wants me to try anything (newer kernel or different parport-related 
BIOS settings, perhaps, to see if I can duplicate the problem?) and report 
back, let me know.

Stephen
