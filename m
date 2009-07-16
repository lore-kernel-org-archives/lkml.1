Return-Path: <linux-kernel-owner+w=401wt.eu-S933499AbZGPWmi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933499AbZGPWmi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jul 2009 18:42:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933471AbZGPWmi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Jul 2009 18:42:38 -0400
Received: from mail-px0-f185.google.com ([209.85.216.185]:48624 "EHLO
	mail-px0-f185.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933030AbZGPWmh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jul 2009 18:42:37 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=xbGtatUVnbAyWNoXNrWIyjHKVrnHP1KW2Rgx+Rh492xMowJUXzheHsGWxDD5E5Mhiq
         iBQjHul+GaIo82tfneMsUhXu/S7NCxMrOyl75PDYdOwnj6fXJQ/JU44+L+UqndQ7F0DT
         rtz/dOfAe0jZ0tiScln7+qK+3DvZYg7RPGDzI=
Message-ID: <4A5FAD3E.2000503@gmail.com>
Date: Thu, 16 Jul 2009 15:44:14 -0700
From: "Justin P. Mattock" <justinmattock@gmail.com>
User-Agent: Spicebird/0.7.1 (X11; 2009031304)
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: BUG: unable to handle kernel NULL pointer dereference at 00000004
References: <dd18b0c30907161530r11b0ff56u12368bc647ba53a@mail.gmail.com> <20090716233341.19c5aff4@lxorguk.ukuu.org.uk>
In-Reply-To: <20090716233341.19c5aff4@lxorguk.ukuu.org.uk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Cox wrote:
> On Thu, 16 Jul 2009 15:30:24 -0700
> Justin Mattock<justinmattock@gmail.com>  wrote:
>
>    
>> Seems This is the first time seeing this.
>> steps to recreate(not sure) What I was doing was simple
>> exited out of fluxbox(killed the xserver) to read some
>> debug messages in bash for a few minuets. Once done
>> pressing the powerbutton(which is a simple custom rule:
>> shutdown -h now no more no less) resulted in this:
>>
>> [22629.384502] BUG: unable to handle kernel NULL pointer dereference at 00000004
>> [22629.390005] IP: [<c11aaf5c>] tty_ldisc_wait_idle+0x75/0xcd
>>      
>
> Fix went to Linus today
>
>
> At least I hope it fixed it ;) It did for me
>
>    
Cool.
I'll load up the latest git, and see if this
occurs again.

Justin P. Mattock
