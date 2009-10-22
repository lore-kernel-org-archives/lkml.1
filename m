Return-Path: <linux-kernel-owner+w=401wt.eu-S1753850AbZJVDGS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753850AbZJVDGS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Oct 2009 23:06:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753354AbZJVDGR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Oct 2009 23:06:17 -0400
Received: from blu0-omc1-s34.blu0.hotmail.com ([65.55.116.45]:19114 "EHLO
	blu0-omc1-s34.blu0.hotmail.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753079AbZJVDGQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Oct 2009 23:06:16 -0400
X-Originating-IP: [133.11.82.45]
X-Originating-Email: [kat841@hotmail.com]
Message-ID: <BLU0-SMTP3323A290887176D9229ECE8CBE0@phx.gbl>
Date: Thu, 22 Oct 2009 12:06:16 +0900
From: Katsuhiko Nishimra <kat841@hotmail.com>
User-Agent: Mozilla-Thunderbird 2.0.0.22 (X11/20090701)
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: Tomasz Chmielewski <mangoo@wpkg.org>, linux-kernel@vger.kernel.org,
       linux-usb@vger.kernel.org
Subject: Re: 2.6.31.4: WARNING: at drivers/usb/serial/usb-serial.c:446 serial_unthrottle
References: <4AD71FA3.8080801@wpkg.org> <20091015160501.36a31973@lxorguk.ukuu.org.uk>
In-Reply-To: <20091015160501.36a31973@lxorguk.ukuu.org.uk>
X-Enigmail-Version: 0.96.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 22 Oct 2009 03:06:20.0801 (UTC) FILETIME=[A1609710:01CA52C4]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Cox wrote:
> On Thu, 15 Oct 2009 15:12:03 +0200
> Tomasz Chmielewski <mangoo@wpkg.org> wrote:
> 
>> I see my minicom segfaulted for some reason (probably as I closed konsole window without exiting minicom first).
>>
>> And I see this warning in dmesg - anything useful?
> 
> Looks like a very very old bug in the tty code. I have a patch for this I'm
> testing for a while and will sort out properly after the kernel summit. In
> the mean time have a play with the patch below which ought to do the trick.
> 

Unfortunately, I reproduced this error after applying this patch into
v2.6.32-rc5. Kerneloops url for the bug is below.
http://www.kerneloops.org/submitresult.php?number=827635

This bug occured when I close minicom normally with C-A X.

Thx.
