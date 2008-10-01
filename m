Return-Path: <linux-kernel-owner+w=401wt.eu-S1753820AbYJAA7U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753820AbYJAA7U (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2008 20:59:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753063AbYJAA7M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Sep 2008 20:59:12 -0400
Received: from gw.goop.org ([64.81.55.164]:38679 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752812AbYJAA7M (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2008 20:59:12 -0400
Message-ID: <48E2CB5A.1050809@goop.org>
Date: Tue, 30 Sep 2008 17:59:06 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.16 (X11/20080919)
MIME-Version: 1.0
To: Pavel Machek <pavel@suse.cz>
CC: carbonated beverage <ramune@net-ronin.org>, linux-kernel@vger.kernel.org
Subject: Re: Thinkpad brightness keys kill X on 2.6.26.5
References: <20080925060244.GA18945@net-ronin.org> <20080930231952.GB15903@ucw.cz>
In-Reply-To: <20080930231952.GB15903@ucw.cz>
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
>> I just upgraded from 2.6.25.17 to 2.6.26.5 on my Thinkpad Z61t, and found
>> the brightness keys will cause the X server to die.  When using the
>> brightness up/down keys, the screen will go blank -- Control+Alt+F# will
>> still switch to a different virtual console, but switching back will not
>> restore the video state.
>>
>> After killing the window manager, I was able to bring up X again without
>> a problem -- but using the brightness keys still causes it to go blank
>> again within X, while the brightness does get changed correctly on the
>> console.
>>
>> There were no kernel messages, but this appeared in the Xorg log:
>>     
>
> Yes, I had similar problems... for me it blanked screen on closing
> lid. Problem disappeared after upgrading X...
>
>   
>> .config attached -- is this a known issue?  In the meantime, I'm starting
>> a bisection to figure out where the problem crops up.
>>     
>
> For me CONFIG_ACPI_VIDEO never really worked...
>   

On my shiny new X200 running Fedora Rawhide, I'm finding that the 
brightness control keys work OK, but the backlight remains stuck off 
after a resume.  The machine is working fine but the backlight is just 
off; I can see the display under a bright light.  Switching consoles and 
poking about in /sys/class/backlight/acpi_video?/ didn't help.

    J
