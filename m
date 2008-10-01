Return-Path: <linux-kernel-owner+w=401wt.eu-S1754051AbYJAS2s@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754051AbYJAS2s (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Oct 2008 14:28:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753273AbYJAS2l
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Oct 2008 14:28:41 -0400
Received: from gw.goop.org ([64.81.55.164]:38362 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753204AbYJAS2k (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Oct 2008 14:28:40 -0400
Message-ID: <48E3C152.1000102@goop.org>
Date: Wed, 01 Oct 2008 11:28:34 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.16 (X11/20080919)
MIME-Version: 1.0
To: Matthew Garrett <mjg59@srcf.ucam.org>
CC: Pavel Machek <pavel@suse.cz>, carbonated beverage <ramune@net-ronin.org>,
       linux-kernel@vger.kernel.org
Subject: Re: Thinkpad brightness keys kill X on 2.6.26.5
References: <20080925060244.GA18945@net-ronin.org> <20080930231952.GB15903@ucw.cz> <48E2CB5A.1050809@goop.org> <20081001095322.GA27987@srcf.ucam.org>
In-Reply-To: <20081001095322.GA27987@srcf.ucam.org>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Matthew Garrett wrote:
> On Tue, Sep 30, 2008 at 05:59:06PM -0700, Jeremy Fitzhardinge wrote:
>
>   
>> On my shiny new X200 running Fedora Rawhide, I'm finding that the 
>> brightness control keys work OK, but the backlight remains stuck off 
>> after a resume.  The machine is working fine but the backlight is just 
>> off; I can see the display under a bright light.  Switching consoles and 
>> poking about in /sys/class/backlight/acpi_video?/ didn't help.
>>     
>
> Intel graphics, right?

Yes.  The new, erm , X4500?

>  The DRM layer should handle full resume on modern 
> Intel hardware, but there's the potential for bugs. This is entirely 
> unrelated to ACPI, though.
>   

OK, that's a good clue.  I poke at acpi to change the brightness, so I'd 
assumed that acpi would also handle turning the backlight on/off.

I'm using the rawhide rather than standard kernel, but I'd thought they 
were fairly similar.

I'm also using the vesa X server; I haven't tried using the intel one yet.

    J
