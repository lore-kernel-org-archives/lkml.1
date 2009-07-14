Return-Path: <linux-kernel-owner+w=401wt.eu-S1754592AbZGNKTc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754592AbZGNKTc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jul 2009 06:19:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754464AbZGNKTb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Jul 2009 06:19:31 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:39464 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754449AbZGNKTa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jul 2009 06:19:30 -0400
Date: Tue, 14 Jul 2009 12:18:52 +0200
From: Marek Szyprowski <m.szyprowski@samsung.com>
Subject: RE: [PATCH] Input: add MAX7359 key switch controller driver, v2
In-reply-to: <5d5443650907140211i4c6e4a49q9c055dc1e91071da@mail.gmail.com>
To: "'Trilok Soni'" <soni.trilok@gmail.com>
Cc: "'Dmitry Torokhov'" <dmitry.torokhov@gmail.com>,
       "'Kim Kyuwon'" <q1.kim@samsung.com>,
       "'Kim Kyuwon'" <chammoru@gmail.com>,
       "'LKML'" <linux-kernel@vger.kernel.org>, linux-input@vger.kernel.org,
       "'Kyungmin Park'" <kyungmin.park@samsung.com>,
       Marek Szyprowski <m.szyprowski@samsung.com>
Message-id: <002b01ca046c$7f9fd240$7edf76c0$%szyprowski@samsung.com>
MIME-version: 1.0
X-Mailer: Microsoft Office Outlook 12.0
Content-type: text/plain; charset=us-ascii
Content-language: pl
Content-transfer-encoding: 7BIT
Thread-index: AcoEYxhVVrtpjy4mTP6P0A5mO47B6gAAfz/Q
References: <4A04E5EA.7000103@samsung.com>
 <4d34a0a70905101934j320c03abl7e39af4fbfdf1f62@mail.gmail.com>
 <20090511031208.GA15208@dtor-d630.eng.vmware.com>
 <5d5443650906191038o797e0c3eu8234a56ee247ea68@mail.gmail.com>
 <5d5443650907130152t420e9426q762c24bdb1b29aae@mail.gmail.com>
 <20090713093147.GJ10819@dtor-d630.eng.vmware.com>
 <4A5BF6F0.6020403@samsung.com>
 <001801ca044c$428839d0$c798ad70$%szyprowski@samsung.com>
 <20090714082452.GH2822@dtor-d630.eng.vmware.com>
 <002a01ca0462$8b750a90$a25f1fb0$%szyprowski@samsung.com>
 <5d5443650907140211i4c6e4a49q9c055dc1e91071da@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Tuesday, July 14, 2009 11:12 AM, Trilok Soni wrote:

> On Tue, Jul 14, 2009 at 2:37 PM, Marek
> Szyprowski<m.szyprowski@samsung.com> wrote:
> > Hello,
> >
> > On Tuesday, July 14, 2009 10:25 AM, Dmitry Torokhov wrote:
> >
> >> On Tue, Jul 14, 2009 at 08:28:05AM +0200, Marek Szyprowski wrote:
> >> > Hello,
> >> > On Tuesday, July 14, 2009 5:10 AM, Kim Kyuwon wrote:
> >> > > Dmitry Torokhov wrote:
> >> > > > On Mon, Jul 13, 2009 at 02:22:10PM +0530, Trilok Soni wrote:
> >> > > >> I don't see this driver picked up yet in your -next branch. We should
> >> > > >> target this driver to be mainlined in next merge window. This is very
> >> > > >> important driver for some of the embedded systems, including palm pre
> >> > > >> :)
> >> > > > I was wondering if somebody could test the patch below and if it still
> >> > > > works then I will apply to the next branch. Thanks!
> >> > > >
> >> > >
> >> > > Dear Marek,
> >> > >
> >> > > Because I don't have the NCP board(which includes the max7359 keypad)
> >> > > now, I can't test this patch. Marek, could you please test this patch?
> >> >
> >> > I would like to, but I could not find the base version to which I can apply
> >> > that patch. I've tried v2 version posted in '[PATCH] Input: add MAX7359 key
> >> > switch controller driver, v2' mail from Sat 2009-05-09 04:10 with 2 patches
> >> > posted in replies to that main, but the latest patch still fails to apply.
> >> >
> >> > Could someone send me a complete patch, so I can do a test?
> >> >
> >>
> >> Sending everything as attachments, maybe that will help...
> >
> > Ok. I've did the tests.
> >
> > MAX7359 keypad driver works after your patch, but reports much more events than
> > the previous version. In this test I pressed quickly the first button on the
> > keypad.
> >
> > Old version:
> > NCP:~# hexdump /dev/input/event0
> > 0000000 0037 0000 e733 000b 0001 00e7 0001 0000
> > 0000010 0037 0000 e748 000b 0000 0000 0000 0000
> > 0000020 0037 0000 94e2 000d 0001 00e7 0000 0000
> > 0000030 0037 0000 94f3 000d 0000 0000 0000 0000
> >
> 
> Please use evtest instead. It will give better output atleast.

Ok.

Old version (clean v2 patch):

NCP:~# evtest /dev/input/event0
Input driver version is 1.0.0
Input device ID: bus 0x18 vendor 0x0 product 0x0 version 0x0
Input device name: "max7359"
Supported events:
  Event type 0 (Sync)
  Event type 1 (Key)
    Event code 107 (End)
    Event code 139 (Menu)
    Event code 148 (Prog1)
    Event code 149 (Prog2)
    Event code 177 (ScrollUp)
    Event code 178 (ScrollDown)
    Event code 212 (Camera)
    Event code 231 (?)
    Event code 474 (?)
  Event type 20 (Repeat)
Testing ... (interrupt to exit)
Event: time 38.740081, type 1 (Key), code 139 (Menu), value 1
Event: time 38.740101, -------------- Report Sync ------------
Event: time 38.850061, type 1 (Key), code 139 (Menu), value 0
Event: time 38.850077, -------------- Report Sync ------------

New version (updated platform definition to use struct matrix_keymap_data instead of max7359_keypad_platform_data):

NCP:~# evtest /dev/input/event0
Input driver version is 1.0.0
Input device ID: bus 0x18 vendor 0x0 product 0x0 version 0x0
Input device name: "max7359"
Supported events:
  Event type 0 (Sync)
  Event type 1 (Key)
    Event code 107 (End)
    Event code 139 (Menu)
    Event code 148 (Prog1)
    Event code 149 (Prog2)
    Event code 177 (ScrollUp)
    Event code 178 (ScrollDown)
    Event code 212 (Camera)
    Event code 231 (?)
    Event code 474 (?)
  Event type 4 (Misc)
    Event code 4 (ScanCode)
  Event type 20 (Repeat)
Testing ... (interrupt to exit)
Event: time 75.680066, type 4 (Misc), code 4 (ScanCode), value 01
Event: time 75.680095, type 1 (Key), code 139 (Menu), value 1
Event: time 75.680107, -------------- Report Sync ------------
Event: time 75.700072, type 4 (Misc), code 4 (ScanCode), value 3f
Event: time 75.700095, -------------- Report Sync ------------
Event: time 75.830064, type 4 (Misc), code 4 (ScanCode), value 01
Event: time 75.830093, type 1 (Key), code 139 (Menu), value 0
Event: time 75.830100, -------------- Report Sync ------------
Event: time 75.850073, type 4 (Misc), code 4 (ScanCode), value 3f
Event: time 75.850097, -------------- Report Sync ------------

Something is definitely different. It looks that I missed a patch that added some additional events, because I don't think that the
threaded irq patch would cause this.

Best regards
--
Marek Szyprowski
Samsung Poland R&D Center


