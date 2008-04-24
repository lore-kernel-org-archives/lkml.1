Return-Path: <linux-kernel-owner+w=401wt.eu-S1754562AbYDXDrS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754562AbYDXDrS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2008 23:47:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753599AbYDXDrB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Apr 2008 23:47:01 -0400
Received: from hera.kernel.org ([140.211.167.34]:60186 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753478AbYDXDrB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2008 23:47:01 -0400
From: Len Brown <lenb@kernel.org>
Organization: Intel Open Source Technology Center
To: Matthew <jackdachef@gmail.com>
Subject: Re: Linux 2.6.25
Date: Wed, 23 Apr 2008 23:36:41 -0400
User-Agent: KMail/1.9.9
Cc: "Bart Van Assche" <bart.vanassche@gmail.com>,
       torvalds@linux-foundation.org,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "Rudolf Marek" <r.marek@assembler.cz>,
       "Gene Heskett" <gene.heskett@gmail.com>
References: <e85b9d30804180837y39c52e26i588e4b67c87a5e9d@mail.gmail.com> <e85b9d30804190322o703d3b20se22eb6b5e82bae39@mail.gmail.com> <e85b9d30804200502p25842ec2i712da9e388c08e87@mail.gmail.com>
In-Reply-To: <e85b9d30804200502p25842ec2i712da9e388c08e87@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="koi8-r"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200804232336.41603.lenb@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 20 April 2008, Matthew wrote:
> >  sure, I'll test-drive the vanilla-kernel, too
> >
> >  thanks
> 
> ok, tested the vanilla-kernel this morning and it shows the exact high
> temperatures (with CONFIG_THERMAL=y)
> 
> I've got a question:
> 
> when trying to disable thermal it just sits there & won't change:
> <*> Hardware Monitoring support  --->
>   -*- Generic Thermal sysfs driver  --->
> 
> it seemingly depends on other things:
> Selected by: ACPI_THERMAL && !X86_VOYAGER && ACPI && ACPI_PROCESSOR
> 
> is it safe to disable acpi_processor and acpi or CONFIG_THERMAL in
> general ? or will it burn down my box ? ;)
> 
> I'm asking this because it says/writes:
> CONFIG_ACPI_THERMAL:                                                    Å
>   Å                                                                         Å
>   Å This driver adds support for ACPI thermal zones.  Most mobile and       Å
>   Å some desktop systems support ACPI thermal zones.  It is HIGHLY          Å
>   Å recommended that this option be enabled, as your processor(s)           Å
>   Å may be damaged without it.

Don't worry about it -- that is sort of an exageration.
In fact, it is your disk drive that will fry first:-)

# CONFIG_ACPI_THERMAL is not set
# CONFIG_THERMAL is not set

Should be just fine, particularly for experimentation.
In the case of a desktop system, ACPI_THERMAL is generally there
just for processor throttling -- which would typically
only be needed if you removed your heatsink
or had some other serious cooling issue.
And even if it is not there, a 2nd defense,
the processor hardware thermal throttling would kick
in automatically at a slightly higher temperature...

-Len
