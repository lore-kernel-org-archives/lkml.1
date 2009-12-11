Return-Path: <linux-kernel-owner+w=401wt.eu-S1758832AbZLKX6w@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758832AbZLKX6w (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Dec 2009 18:58:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753732AbZLKX6r
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Dec 2009 18:58:47 -0500
Received: from mail-gx0-f212.google.com ([209.85.217.212]:38926 "EHLO
	mail-gx0-f212.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752086AbZLKX6q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Dec 2009 18:58:46 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=iE6KG6fBtvmeWKw3BZzDOrFzji+tOPKwWP6QaFXmC0a0P7NQqM5cpHVaFdSdYeqeZL
         OsZhIYUzNSV6pkAc3Og3p/zSD5Dw3ANs+Sfp0CopndZoWaWt/ytOAWvDLRI+ymnpXwr1
         nedTMhhT2X7nrbNAr5YwtsoX8th2oKdUy2hHY=
Message-ID: <4B22DCBB.7040701@gmail.com>
Date: Fri, 11 Dec 2009 17:58:51 -0600
From: Robert Hancock <hancockrwd@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091203 Fedora/3.0-3.13.rc2.fc12 Thunderbird/3.0
MIME-Version: 1.0
To: Luca Tettamanti <kronos.it@gmail.com>
CC: Matthew Garrett <mjg59@srcf.ucam.org>, lm-sensors@lm-sensors.org,
       linux-kernel@vger.kernel.org
Subject: Re: [lm-sensors] [PATCH] hwmon: Add driver for intel PCI thermal
    subsystem
References: <1260546750-6206-1-git-send-email-mjg@redhat.com>	 <68676e00912110828q26e511edt52546f09490c9431@mail.gmail.com>	 <20091211163328.GA1596@srcf.ucam.org>	 <68676e00912110836p278985cfv3d052e16a22916b1@mail.gmail.com>	 <20091211163822.GA1869@srcf.ucam.org>	 <68676e00912110847o3594931etf6e045340043e2c6@mail.gmail.com>	 <20091211165004.GA2156@srcf.ucam.org> <68676e00912110858i1cb8f7aclc8e7802840b6f84e@mail.gmail.com>
In-Reply-To: <68676e00912110858i1cb8f7aclc8e7802840b6f84e@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/11/2009 10:58 AM, Luca Tettamanti wrote:
> On Fri, Dec 11, 2009 at 5:50 PM, Matthew Garrett<mjg59@srcf.ucam.org>  wrote:
>> On Fri, Dec 11, 2009 at 05:47:29PM +0100, Luca Tettamanti wrote:
>>> Sorry, I think we're not understanding each other :)
>>> Does the PCH samples the values directly from the probes? Or is it an
>>> interface for the real monitoring chip (most likely the superio chip)?
>>> In the latter case it might be possible to access directly the
>>> monitoring hardware using another driver (e.g. w83627ehf, lm80, etc.),
>>> thus racing against the PCI driver.
>>> Did I make myself clear?
>>
>> I don't think there's any other chip. On systems using external chips,
>> this PCI device will simply be disabled by the BIOS before the OS boots.
>
> Ok, good.
> The other potential issue is asus_atk0110 driver; ASUS boards have a
> ACPI interface to the hwmon stuff.
> Will check with my testers.

Well, on my P7P55D PRO board, this PCI device does not show up. I assume 
the BIOS disables it because the board uses its own monitoring hardware.
