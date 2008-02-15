Return-Path: <linux-kernel-owner+w=401wt.eu-S1761945AbYBOSAw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761945AbYBOSAw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2008 13:00:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761702AbYBOSAc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Feb 2008 13:00:32 -0500
Received: from wa-out-1112.google.com ([209.85.146.180]:47473 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761654AbYBOSA3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2008 13:00:29 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=JcCPWyHGuS1fZduWNKqP+e/es21VWOKp6fbiNjkostqQ7ZX67uzUGiCtiHn9B11rIQrL52h8B0gu2hUsTYqLd4y5mbT//eF8vM+xhvmn6fqFFNHjZ4cDqkJfvEZFhlpMnTK/niIrcqAbRQMK9Jyix8Tx4Ji+oIxw9avATFu06b4=
Message-ID: <4779de450802151000o2c06df0fq6d0daa22c43b935b@mail.gmail.com>
Date: Fri, 15 Feb 2008 10:00:28 -0800
From: "Dan Gora" <dan.gora@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: Re: PCI Bursting with PIO
In-Reply-To: <20080215130244.780285cf@core>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <4779de450802141928led16cebkfb989551eb88a8cb@mail.gmail.com>
	 <20080215130244.780285cf@core>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 15, 2008 at 5:02 AM, Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:
> > Is there any way to get PIO to burst over the PCI bus in the read and
>  > write direction?  My device has 4 BAR registers, but the area where I
>
>  I think you are doign about as well as the X folks did when they spent
>  time on trying to optimise pio transfers to and from graphics card RAM.
>

That's good to know.  Do you have a link or anything to their
discussion or some key words that I could hunt it down?

>
>  > Any ideas would be really appreciated,
>
>  Put a DMA controller on it ;)

Ugh.. sadly that's what's coming.  I really don't get why the
northbridge cannot burst however.  If the memory is mapped
prefetchable and you have to do a PCI read through 3 PCIe bridges to
finally get to your device it seems like it would _really_ behoove the
bridge to do a Memory read multiple and get the whole cache line.  I
have searched around a lot and there doesn't seem to be any info at
all on how you can persuade these bridges to do different PCI commands
or burst.  I don't know why....

thanks again for your help,

dan
