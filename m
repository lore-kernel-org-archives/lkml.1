Return-Path: <linux-kernel-owner+w=401wt.eu-S1755693AbZLKQ6A@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755693AbZLKQ6A (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Dec 2009 11:58:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752776AbZLKQ57
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Dec 2009 11:57:59 -0500
Received: from mail-fx0-f221.google.com ([209.85.220.221]:34923 "EHLO
	mail-fx0-f221.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754582AbZLKQ56 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Dec 2009 11:57:58 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=eIntkT3E3tj3SHu9ueqYzQS4L0NNvSSzxSVuhzH0is9T4mM1xNKfxTL1g5CBn7/iTV
         qKlBCkXtKC2Ci6cqqxf7yxbLHEt5NqqT3QKXjDGAbiQ07aBY0RfdziHzH71/ty1pEIRG
         7OA5jSGsrE/sE/N7SVsUmEz5fO60zVTjWcalE=
MIME-Version: 1.0
In-Reply-To: <20091211165004.GA2156@srcf.ucam.org>
References: <1260546750-6206-1-git-send-email-mjg@redhat.com>
	 <68676e00912110828q26e511edt52546f09490c9431@mail.gmail.com>
	 <20091211163328.GA1596@srcf.ucam.org>
	 <68676e00912110836p278985cfv3d052e16a22916b1@mail.gmail.com>
	 <20091211163822.GA1869@srcf.ucam.org>
	 <68676e00912110847o3594931etf6e045340043e2c6@mail.gmail.com>
	 <20091211165004.GA2156@srcf.ucam.org>
Date: Fri, 11 Dec 2009 17:58:03 +0100
Message-ID: <68676e00912110858i1cb8f7aclc8e7802840b6f84e@mail.gmail.com>
Subject: Re: [lm-sensors] [PATCH] hwmon: Add driver for intel PCI thermal 
	subsystem
From: Luca Tettamanti <kronos.it@gmail.com>
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: lm-sensors@lm-sensors.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 11, 2009 at 5:50 PM, Matthew Garrett <mjg59@srcf.ucam.org> wrote:
> On Fri, Dec 11, 2009 at 05:47:29PM +0100, Luca Tettamanti wrote:
>> Sorry, I think we're not understanding each other :)
>> Does the PCH samples the values directly from the probes? Or is it an
>> interface for the real monitoring chip (most likely the superio chip)?
>> In the latter case it might be possible to access directly the
>> monitoring hardware using another driver (e.g. w83627ehf, lm80, etc.),
>> thus racing against the PCI driver.
>> Did I make myself clear?
>
> I don't think there's any other chip. On systems using external chips,
> this PCI device will simply be disabled by the BIOS before the OS boots.

Ok, good.
The other potential issue is asus_atk0110 driver; ASUS boards have a
ACPI interface to the hwmon stuff.
Will check with my testers.

Luca
