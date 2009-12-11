Return-Path: <linux-kernel-owner+w=401wt.eu-S1756256AbZLKQr0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756256AbZLKQr0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Dec 2009 11:47:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753993AbZLKQrZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Dec 2009 11:47:25 -0500
Received: from mail-fx0-f221.google.com ([209.85.220.221]:53355 "EHLO
	mail-fx0-f221.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752544AbZLKQrY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Dec 2009 11:47:24 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=q+6HIuwtqFKlTB/L7GbpGm3tH8nniSZTZFR/vnNGEB7E+bRKrA3xZ6KlS6qRmiGV+1
         /7HYihK7bSebUUwielfpI+Rg5Lm5ga+haE4V4kZJ4TbP4pZ5qUS7nebeSL+6hhM/8Hc9
         9M4s9W0NodglDTmdtCtZQDWE3ZGJnaUMwrA6o=
MIME-Version: 1.0
In-Reply-To: <20091211163822.GA1869@srcf.ucam.org>
References: <1260546750-6206-1-git-send-email-mjg@redhat.com>
	 <68676e00912110828q26e511edt52546f09490c9431@mail.gmail.com>
	 <20091211163328.GA1596@srcf.ucam.org>
	 <68676e00912110836p278985cfv3d052e16a22916b1@mail.gmail.com>
	 <20091211163822.GA1869@srcf.ucam.org>
Date: Fri, 11 Dec 2009 17:47:29 +0100
Message-ID: <68676e00912110847o3594931etf6e045340043e2c6@mail.gmail.com>
Subject: Re: [lm-sensors] [PATCH] hwmon: Add driver for intel PCI thermal 
	subsystem
From: Luca Tettamanti <kronos.it@gmail.com>
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: lm-sensors@lm-sensors.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 11, 2009 at 5:38 PM, Matthew Garrett <mjg59@srcf.ucam.org> wrote:
> On Fri, Dec 11, 2009 at 05:36:59PM +0100, Luca Tettamanti wrote:
>> On Fri, Dec 11, 2009 at 5:33 PM, Matthew Garrett <mjg59@srcf.ucam.org> wrote:
>> >> Does it plays nice with other drivers?
>> >> More specifically: is it possible to load the native driver and this
>> >> one (which I presume pokes at the same chip) at the same time?
>> >
>> > What do you mean by native driver? This is a native driver for the chip
>> > in question.
>>
>> I mean the driver for the hwmon chip attached to I2C/SMB bus.
>
> This is the hwmon chip.

Sorry, I think we're not understanding each other :)
Does the PCH samples the values directly from the probes? Or is it an
interface for the real monitoring chip (most likely the superio chip)?
In the latter case it might be possible to access directly the
monitoring hardware using another driver (e.g. w83627ehf, lm80, etc.),
thus racing against the PCI driver.
Did I make myself clear?

thanks,
Luca
