Return-Path: <linux-kernel-owner+w=401wt.eu-S1755265AbZFEQPy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755265AbZFEQPy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Jun 2009 12:15:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752733AbZFEQPr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Jun 2009 12:15:47 -0400
Received: from mail-fx0-f213.google.com ([209.85.220.213]:42862 "EHLO
	mail-fx0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752588AbZFEQPq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Jun 2009 12:15:46 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=OSb2uie6JBHmqcZ7DRyJxTSiOxJxTI3fSu4xUOLXhjtqgyz38IeQSi6uwLr164fLi5
         2CJLoFH8yZorzBAhTuE9XkslXYf0brJt/I2WzSA3AzxweSKINgkDYAg8Pcp1UdW1A+St
         /yJcefjBRNlDORY+nDLsMb/o7g86vKIZ+/vzE=
MIME-Version: 1.0
In-Reply-To: <1244218042.3631.158.camel@Joe-Laptop.home>
References: <1244197103.3631.40.camel@Joe-Laptop.home>
	 <4A28F94A.6040500@tuffmail.co.uk>
	 <1244199633.3631.43.camel@Joe-Laptop.home>
	 <71cd59b00906050457i29638577o9eeb5e8fa8eb087c@mail.gmail.com>
	 <1244216712.3631.117.camel@Joe-Laptop.home>
	 <71cd59b00906050901p71c7483fja5b3c74744f93384@mail.gmail.com>
	 <1244218042.3631.158.camel@Joe-Laptop.home>
Date: Fri, 5 Jun 2009 18:15:47 +0200
Message-ID: <71cd59b00906050915j744dc997ie736a365e9f974a7@mail.gmail.com>
Subject: Re: [PATCH] eeepc-laptop.c: use pr_fmt and pr_<level>
From: Corentin Chary <corentin.chary@gmail.com>
To: Joe Perches <joe@perches.com>
Cc: Alan Jenkins <alan-jenkins@tuffmail.co.uk>,
       acpi4asus-user@lists.sourceforge.net,
       LKML <linux-kernel@vger.kernel.org>, Len Brown <len.brown@intel.com>,
       Matthew Garrett <mjg@redhat.com>,
       Darren Salt <linux@youmustbejoking.demon.co.uk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 5, 2009 at 6:07 PM, Joe Perches<joe@perches.com> wrote:
> On Fri, 2009-06-05 at 18:01 +0200, Corentin Chary wrote:
>> On Fri, Jun 5, 2009 at 5:45 PM, Joe Perches<joe@perches.com> wrote:
>> > On Fri, 2009-06-05 at 13:57 +0200, Corentin Chary wrote:
>> >> On Fri, Jun 5, 2009 at 1:00 PM, Joe Perches<joe@perches.com> wrote:
>> >> > On Fri, 2009-06-05 at 11:54 +0100, Alan Jenkins wrote:
>> >> >> Is EEEPC_HOTK_FILE used anywhere else?  It would be clearer if you were
>> >> >> able to just use "eeepc: " or whatever and remove the definition of
>> >> >> EEEPC_HOTK_FILE.
>> >> > It is used elsewhere and perhaps it'd be better to use KBUILD_MODNAME.
>> >> I think we can't use KBUILD_MODNAME because "eeepc" is used for
>> >> platform_device, backlight and input device. Using "eeepc-laptop"
>> >> would break compatibility.
>> > What compatibility would it break?
>> > Logging messages are not guaranteed to be stable across versions.
>> for platform_device backlight and input device it would change the
>> "/sys" paths (eg: /sys/class/backlight/eeepc)
>
> I see what you mean.  We're talking cross purposes though.
> I meant that KBUILD_MODNAME be used for pr_fmt, not anywhere else.
>
> #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
>
> So, no changes to any other EEPC_HOTK_FILE uses.
>
> cheers, Joe
>
>

Ah, ok. Sorry =)
Yeah sure we could use KBUILD_MODNAME  here. I'll just rework your
patch to change that if you don't mind.

-- 
Corentin Chary
http://xf.iksaif.net - http://uffs.org
