Return-Path: <linux-kernel-owner+w=401wt.eu-S1756740AbZLKQgz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756740AbZLKQgz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Dec 2009 11:36:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752396AbZLKQgy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Dec 2009 11:36:54 -0500
Received: from fg-out-1718.google.com ([72.14.220.159]:62581 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750925AbZLKQgy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Dec 2009 11:36:54 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=sJOZtQFbpk0c2fcfea6Asv8v6FwBbi6xfoChAcOI4dXnG1k8x3uQRJ3gWMZdOvGD86
         A0ICS4ZYzk1VHk/9DiCYI89MOSWqyoKw2dH3Fc7vgvxwH7CRnQWww/HSH/kQBbwEAOYF
         gUnb1q0wrk5dyoTdt5SfDsJpBnL3zqrO4wOUM=
MIME-Version: 1.0
In-Reply-To: <20091211163328.GA1596@srcf.ucam.org>
References: <1260546750-6206-1-git-send-email-mjg@redhat.com>
	 <68676e00912110828q26e511edt52546f09490c9431@mail.gmail.com>
	 <20091211163328.GA1596@srcf.ucam.org>
Date: Fri, 11 Dec 2009 17:36:59 +0100
Message-ID: <68676e00912110836p278985cfv3d052e16a22916b1@mail.gmail.com>
Subject: Re: [lm-sensors] [PATCH] hwmon: Add driver for intel PCI thermal 
	subsystem
From: Luca Tettamanti <kronos.it@gmail.com>
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: lm-sensors@lm-sensors.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 11, 2009 at 5:33 PM, Matthew Garrett <mjg59@srcf.ucam.org> wrote:
> On Fri, Dec 11, 2009 at 05:28:37PM +0100, Luca Tettamanti wrote:
>> On Fri, Dec 11, 2009 at 4:52 PM, Matthew Garrett <mjg@redhat.com> wrote:
>> > Recent Intel chipsets have support for a PCI device providing access
>> > to on-board thermal monitoring. Previous versions have merely used this
>> > to allow the BIOS to set trip points, but Ibex Peak documents a set of
>> > registers to read values. This driver implements an hwmon interface to
>> > read them.
>>
>> Does it plays nice with other drivers?
>> More specifically: is it possible to load the native driver and this
>> one (which I presume pokes at the same chip) at the same time?
>
> What do you mean by native driver? This is a native driver for the chip
> in question.

I mean the driver for the hwmon chip attached to I2C/SMB bus.

Luca
