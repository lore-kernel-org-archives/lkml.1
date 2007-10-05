Return-Path: <linux-kernel-owner+w=401wt.eu-S1764155AbXJEVnU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764155AbXJEVnU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Oct 2007 17:43:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751462AbXJEVnM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Oct 2007 17:43:12 -0400
Received: from terminus.zytor.com ([198.137.202.10]:45468 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760608AbXJEVnL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Oct 2007 17:43:11 -0400
Message-ID: <4706AFE2.7020307@zytor.com>
Date: Fri, 05 Oct 2007 14:42:58 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.5 (X11/20070727)
MIME-Version: 1.0
To: Jiri Kosina <jikos@jikos.cz>
CC: Pavel Machek <pavel@ucw.cz>, kernel list <linux-kernel@vger.kernel.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: video resume stuff
References: <20071004130513.GA16076@elf.ucw.cz> <470511A9.4060705@zytor.com> <20071005073238.GA19065@atrey.karlin.mff.cuni.cz> <Pine.LNX.4.64.0710051648440.25413@twin.jikos.cz> <47068398.9070304@zytor.com> <Pine.LNX.4.64.0710052258260.25413@twin.jikos.cz>
In-Reply-To: <Pine.LNX.4.64.0710052258260.25413@twin.jikos.cz>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jiri Kosina wrote:
> On Fri, 5 Oct 2007, H. Peter Anvin wrote:
> 
>> Jiri, what particular video mode are you running in?  In other words, 
>> what is your vga= parameter set to?  In fact, what does your entire 
>> kernel command line look like?
> 
> Hi,
> 
> the videomode is standard 80x25 VGA.
> 
> The kernel commandline is 
> 
> 	root=/dev/sda2 vga=normal 3 acpi_sleep=s3_bios,s3_mode
> 
>> Also, if you could extract the information requested in:
>> http://marc.info/?i=46FD802D.2030804@zytor.com
>> ... that would really help.
> 
> bootparams.bin can be found at 
> http://www.jikos.cz/jikos/junk/bootparams.bin
> 

Looks like this bootparams image was obtained without removing 
__initdata, so it's unusable.  Sorry.

	-hpa
