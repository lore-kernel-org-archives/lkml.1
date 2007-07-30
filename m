Return-Path: <linux-kernel-owner+w=401wt.eu-S969076AbXG3WIR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S969076AbXG3WIR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jul 2007 18:08:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966163AbXG3WID
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jul 2007 18:08:03 -0400
Received: from nf-out-0910.google.com ([64.233.182.188]:41509 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S968386AbXG3WIB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jul 2007 18:08:01 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:content-type:content-transfer-encoding;
        b=UEg2+VuzGtpVb/DlMMUT5M9VwCOvfBdnvQuA5h0t78Ds6FFXDQ3Paq7azFi8Qbk3DmffZLPaI8MvyLpGKK+6A2tNlLbwSVsMvN2jaouON0Nh5CWpbySYgtnQFDuKoe+UUyqYclYYe7B0hpgzHFhLM6gVpsRQshDc7THuBs43ltc=
Message-ID: <46AE6029.60308@googlemail.com>
Date: Tue, 31 Jul 2007 00:03:21 +0200
From: Gabriel C <nix.or.die@googlemail.com>
User-Agent: Thunderbird 2.0.0.5 (X11/20070721)
MIME-Version: 1.0
To: Sasa Ostrouska <casaxa@gmail.com>
CC: Avuton Olrich <avuton@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: forcedeth ?
References: <dcf706c60707301301j21d3cf60n59a686c9abb5e5b3@mail.gmail.com>	 <3aa654a40707301337w52bbe246o99db15b9f8e7a2c4@mail.gmail.com> <dcf706c60707301426q4858d039hdfa49fb26835d367@mail.gmail.com>
In-Reply-To: <dcf706c60707301426q4858d039hdfa49fb26835d367@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Sasa Ostrouska wrote:
> On 7/30/07, Avuton Olrich <avuton@gmail.com> wrote:
>> On 7/30/07, Sasa Ostrouska <casaxa@gmail.com> wrote:
>>> Hi people,
>>>
>>> I'm using this on a x86-64 amd machine. During boot of the last
>>> 2.6.22.1 kernel I get this error:
>> Somewhat unrelated, but I had a similar forcedeth problem, I took the
>> latest git forcedeth.c and put it into 2.6.22.1 and it worked for me.
>>
>> Good luck!
>> --
>> avuton
> 
> Ok, maybe I can try that. In any case I noticed another strange thing.
> I have 2 nics in that machine.
> One is a nvidia MPC61 using the forcedeth.c the other one is a Realtec
> RTL8029 using the
> ne2k_pci.
> Now, whenever I compile them both as modules each reboot the cards get
> inversed eth assignement. Suppose first boot, the forcedeth is eth0 ,
> the next boot it is eth1 , this is very anoying as one cant make only
> one boot, probably this is someway related to the bios.
> Now I configured them one in the kernel and the other as a module so
> they get each time assigned the same name. But when powerloss happens
> (unplug the cable) the next boot they do not work. I see them assigned
> the correct name, ifconfig shows the IP's but ping results in a
> destination unreachable.
> 
> Any ideas ?

Udev rules ?

> 
> Rgds
> Sasa

Gabriel
