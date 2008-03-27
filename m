Return-Path: <linux-kernel-owner+w=401wt.eu-S1761616AbYC0Utl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761616AbYC0Utl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Mar 2008 16:49:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759687AbYC0UtX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Mar 2008 16:49:23 -0400
Received: from gw.goop.org ([64.81.55.164]:45918 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759382AbYC0UtW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Mar 2008 16:49:22 -0400
Message-ID: <47EC0842.3020109@goop.org>
Date: Thu, 27 Mar 2008 13:49:06 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: Pavel Machek <pavel@ucw.cz>
CC: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: what's the incompatibility between hibernation and hotplug	memory
References: <47EAD9A7.6020609@goop.org> <200803270027.26037.rjw@sisk.pl> <20080327084936.GD25876@elf.ucw.cz>
In-Reply-To: <20080327084936.GD25876@elf.ucw.cz>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pavel Machek wrote:
> Hi!
>
>   
>>> I noticed that Kconfig warns that hibernation and hotplug memory are not 
>>> compatible.  What's the issue?
>>>       
>> Generally, we might not be able to handle memory unplugged at a wrong time
>> (eg. after we've created the image).
>>
>> Which part of Kconfig says that exactly?
>>     
>
> Actually I believe it is simpler than that. We were not prepared to
> deal with memory holes in hibernation code, so we just disabled it in
> Kconfig...

Doesn't that mean its generally incompatible with non-flatmem memory 
arrangements rather than hotplug memory specifically?

    J
