Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751396Ab0BMBOM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Feb 2010 20:14:12 -0500
Received: from mail-iw0-f201.google.com ([209.85.223.201]:45131 "EHLO
	mail-iw0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750776Ab0BMBOL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Feb 2010 20:14:11 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=LFHESzt77PBWx39MpKMua0Q1V44kLFkuKbH+knHpaL+VA2FLkEnm+PlgV7XsOz8frv
         PEifysS0fUckfreSDf3U8rW3fJPA2S+u8diu27I0znWuah8dj2N6d6ed+emC4PodHWCA
         e1WWkOwL4FOqCsQdgbwq519j3CTEv1vvKLjFQ=
MIME-Version: 1.0
In-Reply-To: <201002130018.42576.st@iss.tu-darmstadt.de>
References: <201002092306.07449.st@iss.tu-darmstadt.de>
	 <201002112354.51990.st@iss.tu-darmstadt.de>
	 <51f3faa71002111749k403df397j8b3c924ad9cf633e@mail.gmail.com>
	 <201002130018.42576.st@iss.tu-darmstadt.de>
Date: Fri, 12 Feb 2010 19:14:09 -0600
Message-ID: <51f3faa71002121714y5a5127c2r7f59165c8096f0ee@mail.gmail.com>
Subject: Re: 2.6.33-rc7 problems
From: Robert Hancock <hancockrwd@gmail.com>
To: ST <st@iss.tu-darmstadt.de>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 12, 2010 at 5:18 PM, ST <st@iss.tu-darmstadt.de> wrote:
> Hi Robert
>> Can you post
>> the full dmesg from 2.6.32 when connecting the drive?
> The dmesg when connecting the drive is attached. This is
> from a Fedora 12 installation. Hopefully this is enough?
>
> Mh, it seems as if the following lines are missing in the failing case?:
> Initializing USB Mass Storage driver...
> scsi8 : SCSI emulation for USB Mass Storage devices
> usb-storage: device found at 6
> usb-storage: waiting for device to settle before scanning
> usbcore: registered new interface driver usb-storage
> USB Mass Storage support registered.
> usb-storage: device scan complete
>
> Is there probably a wrong driver bound to the wrong driver?
> (Didn't find anything suspicious under /sysfs)
> Why is "usb_stor_init" not called?
>
> I just tried to get a working kernel by using "make localyesconfig"
> under fedora. But it still only detects the the SD card...
>
> Thank you very much for your help.
> ST
>

Do you have CONFIG_SCSI_MULTI_LUN=y set in your kernel configuration?
