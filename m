Return-Path: <linux-kernel-owner+w=401wt.eu-S1756363AbZLDM7O@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756363AbZLDM7O (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Dec 2009 07:59:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756291AbZLDM7L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Dec 2009 07:59:11 -0500
Received: from mail-ew0-f219.google.com ([209.85.219.219]:62794 "EHLO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755984AbZLDM7J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Dec 2009 07:59:09 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:references:date:in-reply-to:message-id
         :user-agent:mime-version:content-type;
        b=K2DOMTIzzvsuuhoCodgRjbl9VSIhs9/nKIB/LqVC6ma9/I7rHjdFkc/FsB0f1U8FHC
         2lcPlULS+gkx+FTpRnh7xZxcpDndI5QIBxCxjgRNs3bvyURlCxm9Gx7bQJvbxETqsBtS
         z0APQqlw5vYTCTuS16X2eO00Kov7QY9y///xs=
From: Peter Korsgaard <jacmet@sunsite.dk>
To: Peter Hutterer <peter.hutterer@redhat.com>
Cc: Jiri Kosina <jkosina@suse.cz>, linux-input@vger.kernel.org,
       linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] HID: add multi-input quirk for NextWindow Touchscreen.
References: <20091203050810.GA26595@barra.bne.redhat.com>
	<87zl60s17o.fsf@macbook.be.48ers.dk> <4B1836A6.405@redhat.com>
Date: Fri, 04 Dec 2009 13:59:09 +0100
In-Reply-To: <4B1836A6.405@redhat.com> (Peter Hutterer's message of "Fri, 04
	Dec 2009 08:07:34 +1000")
Message-ID: <871vjasxnm.fsf@macbook.be.48ers.dk>
User-Agent: Gnus/5.110009 (No Gnus v0.9) Emacs/22.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>>>> "Peter" == Peter Hutterer <peter.hutterer@redhat.com> writes:

Hi,

 Peter> it's a hack in userspace that works around wrong event
 Peter> reporting. So yes, it works if you're using evtouch but if you
 Peter> want to use any other driver that driver needs the same
 Peter> hack. treating Z as X and RX as Y doesn't work too well for a
 Peter> generic driver such as evdev, which has to deal with devices
 Peter> where RX is a valid axis.

Hmm, I don't see it sending Z / RX:

sudo evtest /dev/input/event12
Input driver version is 1.0.0
Input device ID: bus 0x3 vendor 0x1926 product 0x1 version 0x100
Input device name: "Nextwindow Touchscreen"
Supported events:
  Event type 0 (Sync)
  Event type 1 (Key)
    Event code 272 (LeftBtn)
    Event code 273 (RightBtn)
    Event code 274 (MiddleBtn)
  Event type 3 (Absolute)
    Event code 0 (X)
      Value      0
      Min        0
      Max    32767
    Event code 1 (Y)
      Value      0
      Min        0
      Max    32767
  Event type 4 (Misc)
    Event code 4 (ScanCode)
Testing ... (interrupt to exit)

sudo nwtool -u -i
Version:                2.91
Serial:                 233025
Model:                  1900
HW capabilities:        0x40
Rightclick delay:       1000 ms
Doubleclick time:       200 ms
Report mode:            1
Drag threshold:         500
Buzzer time:            40 ms
Buzzer tone:            40
Calibration key:        4
Calibration presses:    3

-- 
Bye, Peter Korsgaard
