Return-Path: <linux-kernel-owner+w=401wt.eu-S968787AbXG3V0v@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S968787AbXG3V0v (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jul 2007 17:26:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S968099AbXG3V02
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jul 2007 17:26:28 -0400
Received: from wx-out-0506.google.com ([66.249.82.226]:56939 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S967692AbXG3V00 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jul 2007 17:26:26 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=nsCCSRpDP2MUkL1p3MuMqvxJadeq5LR5dHpyVkxYRt7oBxzk0ntVGO2xMR88rhnE91S/s1p8b/99b58oGAG6DcNiJ0u4b42Ss7rIH+f4rXhM8i/otLl0DIP6AwDtGnhEBQxrMSTbAaIdNXjkjZbLa/9dsSGL/112tUFGbjV18ks=
Message-ID: <dcf706c60707301426q4858d039hdfa49fb26835d367@mail.gmail.com>
Date: Mon, 30 Jul 2007 23:26:26 +0200
From: "Sasa Ostrouska" <casaxa@gmail.com>
To: "Avuton Olrich" <avuton@gmail.com>
Subject: Re: forcedeth ?
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <3aa654a40707301337w52bbe246o99db15b9f8e7a2c4@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <dcf706c60707301301j21d3cf60n59a686c9abb5e5b3@mail.gmail.com>
	 <3aa654a40707301337w52bbe246o99db15b9f8e7a2c4@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 7/30/07, Avuton Olrich <avuton@gmail.com> wrote:
> On 7/30/07, Sasa Ostrouska <casaxa@gmail.com> wrote:
> > Hi people,
> >
> > I'm using this on a x86-64 amd machine. During boot of the last
> > 2.6.22.1 kernel I get this error:
>
> Somewhat unrelated, but I had a similar forcedeth problem, I took the
> latest git forcedeth.c and put it into 2.6.22.1 and it worked for me.
>
> Good luck!
> --
> avuton

Ok, maybe I can try that. In any case I noticed another strange thing.
I have 2 nics in that machine.
One is a nvidia MPC61 using the forcedeth.c the other one is a Realtec
RTL8029 using the
ne2k_pci.
Now, whenever I compile them both as modules each reboot the cards get
inversed eth assignement. Suppose first boot, the forcedeth is eth0 ,
the next boot it is eth1 , this is very anoying as one cant make only
one boot, probably this is someway related to the bios.
Now I configured them one in the kernel and the other as a module so
they get each time assigned the same name. But when powerloss happens
(unplug the cable) the next boot they do not work. I see them assigned
the correct name, ifconfig shows the IP's but ping results in a
destination unreachable.

Any ideas ?

Rgds
Sasa
