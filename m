Return-Path: <linux-kernel-owner+w=401wt.eu-S1759014AbXE3W0q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759014AbXE3W0q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2007 18:26:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758317AbXE3W0i
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 May 2007 18:26:38 -0400
Received: from an-out-0708.google.com ([209.85.132.244]:55187 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758067AbXE3W0h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2007 18:26:37 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=KIBc33y+1g+RETMK6NQ2Q9HCW5Rv0RkyciwTT9YD3gfj0B35JV4BIfI0FX5HzCDg+o7yovTGzswoMHexpS32NCLvlcT+me/Xt2s5XfkgaoYqBlcqwBrchS4k/QAoc1oaYMdPUt0JDUu5athQ83Se/BZ8gF8puVCIioOKx8TIbxM=
Message-ID: <d9b9d95f0705301526i66e99ef3v6c35165aa1a5f5c6@mail.gmail.com>
Date: Wed, 30 May 2007 23:26:30 +0100
From: "Renato Golin" <rengolin@gmail.com>
To: "Jiri Kosina" <jkosina@suse.cz>
Subject: Re: joydev.c and saitek cyborg evo force
Cc: linux-kernel@vger.kernel.org, "Dmitry Torokhov" <dtor@insightbb.com>
In-Reply-To: <d9b9d95f0705300818h2eaa8130mf8a7a37966d29cc5@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <d9b9d95f0705180654x342ff6dbwf134243dfeabed20@mail.gmail.com>
	 <200705210016.20794.dtor@insightbb.com>
	 <Pine.LNX.4.64.0705211444500.22906@jikos.suse.cz>
	 <d9b9d95f0705291657o47ef42d3jea2a1dae3e31bbdb@mail.gmail.com>
	 <Pine.LNX.4.64.0705300207160.3961@jikos.suse.cz>
	 <d9b9d95f0705300214u7eb257fg783aefd73077d33@mail.gmail.com>
	 <Pine.LNX.4.64.0705301654560.3961@jikos.suse.cz>
	 <d9b9d95f0705300818h2eaa8130mf8a7a37966d29cc5@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 30/05/07, Renato Golin <rengolin@gmail.com> wrote:
> On 30/05/07, Jiri Kosina <jkosina@suse.cz> wrote:
> > do any data appear in the kernel log when you generate events with the
> > device (i.e. move the joystick, press the buttons, etc)? That should be
> > reported if DEBUG_DATA is defined properly on the older kernels.

Hi Jiri, at last!!

HID is reporting the axis' range correctly:

May 30 23:19:07 jobim kernel: [ 3316.543445] hid-debug: input
GenericDesktop.X = 2044
May 30 23:19:07 jobim kernel: [ 3316.543451] hid-debug: input
GenericDesktop.Y = 2044

(...)

May 30 23:19:07 jobim kernel: [ 3316.545490]   INPUT(6)[INPUT]
May 30 23:19:07 jobim kernel: [ 3316.545495]     Field(0)
May 30 23:19:07 jobim kernel: [ 3316.545499]
Physical(GenericDesktop.Pointer)
May 30 23:19:07 jobim kernel: [ 3316.545506]       Usage(1)
May 30 23:19:07 jobim kernel: [ 3316.545510]         GenericDesktop.X
May 30 23:19:07 jobim kernel: [ 3316.545517]       Logical Minimum(0)
May 30 23:19:07 jobim kernel: [ 3316.545522]       Logical Maximum(4096)
May 30 23:19:07 jobim kernel: [ 3316.545526]       Physical Minimum(0)
May 30 23:19:07 jobim kernel: [ 3316.545531]       Physical Maximum(4096)
May 30 23:19:07 jobim kernel: [ 3316.545536]       Report Size(16)
May 30 23:19:07 jobim kernel: [ 3316.545540]       Report Count(1)
May 30 23:19:07 jobim kernel: [ 3316.545545]       Report Offset(0)
May 30 23:19:07 jobim kernel: [ 3316.545550]       Flags( Variable Absolute )
May 30 23:19:07 jobim kernel: [ 3316.545558]     Field(1)
May 30 23:19:07 jobim kernel: [ 3316.545562]
Physical(GenericDesktop.Pointer)
May 30 23:19:07 jobim kernel: [ 3316.545568]       Usage(1)
May 30 23:19:07 jobim kernel: [ 3316.545573]         GenericDesktop.Y
May 30 23:19:07 jobim kernel: [ 3316.545579]       Logical Minimum(0)
May 30 23:19:07 jobim kernel: [ 3316.545584]       Logical Maximum(4096)
May 30 23:19:07 jobim kernel: [ 3316.545588]       Physical Minimum(0)
May 30 23:19:07 jobim kernel: [ 3316.545593]       Physical Maximum(4096)
May 30 23:19:07 jobim kernel: [ 3316.545597]       Report Size(16)
May 30 23:19:07 jobim kernel: [ 3316.545602]       Report Count(1)
May 30 23:19:07 jobim kernel: [ 3316.545607]       Report Offset(16)
May 30 23:19:07 jobim kernel: [ 3316.545611]       Flags( Variable Absolute )

Now, why joydev's input_dev is reporting -127, 127 just for the two first axis?

Another problem is that the joystick reports 12 (1-12) buttons and
joydev get's 0-12 (13 buttons):

May 30 23:19:07 jobim kernel: [ 3316.543461] hid-debug: input Button.0001 = 0
May 30 23:19:07 jobim kernel: [ 3316.543466] hid-debug: input Button.0002 = 0
May 30 23:19:07 jobim kernel: [ 3316.543470] hid-debug: input Button.0003 = 0
May 30 23:19:07 jobim kernel: [ 3316.543474] hid-debug: input Button.0004 = 0
May 30 23:19:07 jobim kernel: [ 3316.543478] hid-debug: input Button.0005 = 0
May 30 23:19:07 jobim kernel: [ 3316.543482] hid-debug: input Button.0006 = 0
May 30 23:19:07 jobim kernel: [ 3316.543486] hid-debug: input Button.0007 = 0
May 30 23:19:07 jobim kernel: [ 3316.543490] hid-debug: input Button.0008 = 0
May 30 23:19:07 jobim kernel: [ 3316.543494] hid-debug: input Button.0009 = 0
May 30 23:19:07 jobim kernel: [ 3316.543498] hid-debug: input Button.000a = 0
May 30 23:19:07 jobim kernel: [ 3316.543502] hid-debug: input Button.000b = 0
May 30 23:19:07 jobim kernel: [ 3316.543506] hid-debug: input Button.000c = 0


cheers,
--renato

Reclaim your digital rights, eliminate DRM, learn more at
http://www.defectivebydesign.org/what_is_drm
