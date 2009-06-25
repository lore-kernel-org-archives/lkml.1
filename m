Return-Path: <linux-kernel-owner+w=401wt.eu-S1759834AbZFYJE2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759834AbZFYJE2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jun 2009 05:04:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751486AbZFYJER
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Jun 2009 05:04:17 -0400
Received: from ey-out-2122.google.com ([74.125.78.26]:39901 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759552AbZFYJEP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jun 2009 05:04:15 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding
         :content-disposition:message-id;
        b=UbnjR42eJz1VcznbdTok8mfa85JnCk4b7SQrjDk/kBJ9phsMnS5/25FRtdXbwvrLfT
         lZqDH+aCez81wp0Lx9/H0dX2aXUYHpMRz26SVI53cJJiqSyyfH2DmpMzsndlYNaenlQw
         Mt+3BlUTwreHGX9+FSCMfERdSgDew8W3sAJno=
From: Florian Fainelli <florian@openwrt.org>
To: Mike Rapoport <mike@compulab.co.il>
Subject: Re: Status of bzip2 and lzma kernel compression for ARM?
Date: Thu, 25 Jun 2009 11:04:01 +0200
User-Agent: KMail/1.9.9
Cc: Michael Opdenacker <michael-lists@free-electrons.com>,
       Alain Knaff <alain@knaff.lu>,
       Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
       Russell King - ARM Linux <linux@arm.linux.org.uk>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-arm-kernel@lists.arm.linux.org.uk,
       linux-embedded mailing list <linux-embedded@vger.kernel.org>
References: <4A428AFF.20307@free-electrons.com> <4A433BCD.2030506@compulab.co.il>
In-Reply-To: <4A433BCD.2030506@compulab.co.il>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200906251104.02830.florian@openwrt.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Michael, Mike

Le Thursday 25 June 2009 10:56:45 Mike Rapoport, vous avez écrit :
> Hi Michael,
>
> Michael Opdenacker wrote:
> > Hi Alain,
> >
> > I would like to test bzip2 and lzma compression on ARM.
> >
> > Would you mind telling me what the status of your patches on ARM is, now
> > that the x86  and architecture independent code has been merged? Have
> > you or has anyone already updated them for 2.6.30, or shall I update
> > them by myself?
>
> I'm not sure what exactly do you mean by "test bzip2 and lzma compression
> on ARM", but if you refer to internal initramfs compression, I can tell
> that I've used lzma compression on PXA270 and it works fine.

I think Michael refers to the lzma decompressor which allows you to use a 
lzma-compressed kernel as a (b)zImage with its architecture specific 
decompressor piggy-backed in the (b)zImage.

Such thing would also be very useful on MIPS and PowerPC as well.
-- 
Best regards, Florian Fainelli
Email : florian@openwrt.org
http://openwrt.org
-------------------------------
