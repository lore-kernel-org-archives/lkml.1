Return-Path: <linux-kernel-owner+w=401wt.eu-S1757709AbYFBRHW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757709AbYFBRHW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2008 13:07:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753377AbYFBRHH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Jun 2008 13:07:07 -0400
Received: from an-out-0708.google.com ([209.85.132.240]:1997 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753611AbYFBRHC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2008 13:07:02 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=OotLqhAL6Kunz5cxG+ilEEYfgR8VZ8un4fOwaa0JeGoXMvFevy9JCTQ1CLHKOVw+/zj0+cOzpP9HmkI/qVTej9pIlVrs83z9oouGH8iQAXfgAzhS/f7CNoH3Edc1yyAvcwbPospdQTNIBwvcsl4wlRim4FdSSCrkZcAxwdRbdUI=
Message-ID: <87f94c370806021007i5df45716u38f5b7ce525c03b0@mail.gmail.com>
Date: Mon, 2 Jun 2008 13:07:01 -0400
From: "Greg Freemyer" <greg.freemyer@gmail.com>
To: "Jeff Garzik" <jeff@garzik.org>
Subject: Re: [PATCH] ata: ahci: power off unused ports
Cc: "Mark Lord" <liml@rtr.ca>, "Alan Cox" <alan@lxorguk.ukuu.org.uk>,
       "Pavel Machek" <pavel@ucw.cz>,
       "Kristen Carlson Accardi" <kristen.c.accardi@intel.com>,
       "Theodore Tso" <tytso@mit.edu>, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <48441AA6.8080704@garzik.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080508161008.59361de5@appleyard>
	 <20080527143202.4bab5bf0@appleyard> <20080527225926.GE6843@mit.edu>
	 <20080527163251.04054a74@appleyard> <20080531080015.GG5405@ucw.cz>
	 <4842F5A8.9020708@garzik.org> <20080602080440.25fc663c@core>
	 <4843A4A7.3020809@garzik.org> <4843EF88.2040606@rtr.ca>
	 <48441AA6.8080704@garzik.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 2, 2008 at 12:07 PM, Jeff Garzik <jeff@garzik.org> wrote:
> Mark Lord wrote:
>>
>> For the power-off of unused ports, the current patch still sounds
>> extremely vendor-specific (Intel).
>>
>> Does it actually work (demonstrate, please) on any other hardware ?
>
> Ding...  correct.  We need something per-port that's not Intel specific.
>
>        Jeff

But, isn't Alan correct that the new logic is useful to some and with
a simple boot option is can be used to enable / disable it.

So if it is defaulted it to disabled, and the end user is allowed to
have a boot option to enable it, you get a reasonable first step for
now.

Greg
-- 
Greg Freemyer
Litigation Triage Solutions Specialist
http://www.linkedin.com/in/gregfreemyer
First 99 Days Litigation White Paper -
http://www.norcrossgroup.com/forms/whitepapers/99%20Days%20whitepaper.pdf

The Norcross Group
The Intersection of Evidence & Technology
http://www.norcrossgroup.com
