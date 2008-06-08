Return-Path: <linux-kernel-owner+w=401wt.eu-S1757481AbYFHVwS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757481AbYFHVwS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Jun 2008 17:52:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756378AbYFHVwB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Jun 2008 17:52:01 -0400
Received: from ug-out-1314.google.com ([66.249.92.168]:47771 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756344AbYFHVwA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Jun 2008 17:52:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=to:subject:date:user-agent:cc:references:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :message-id:from;
        b=OGTJpYysMx3naBIyTP1LZsh7L8FLhOloXXlKy3zvwKV0HgLQDxplD5BPY09NbwCvvT
         rK1Aa7viwd01nSMn8RGNeVXPEhv77LuCVXLV4QLHe2Z0sq4r7RhUUIJx0pEuEf3JlQ7C
         xqA29VflakjpiEj01f8TW8SrWldQPjsrXqQ1Y=
To: =?iso-8859-15?q?Rog=E9rio_Brito?= <rbrito@ime.usp.br>
Subject: Re: [2.6.26-rc4] Problems with rt2x00 USB interface on powerpc
Date: Mon, 9 Jun 2008 00:02:17 +0200
User-Agent: KMail/1.9.9
Cc: "John W. Linville" <linville@tuxdriver.com>, linux-kernel@vger.kernel.org
References: <20080601193000.GA3056@ime.usp.br> <200806081242.54896.IvDoorn@gmail.com> <20080608213513.GA30499@ime.usp.br>
In-Reply-To: <20080608213513.GA30499@ime.usp.br>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200806090002.17938.IvDoorn@gmail.com>
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

> > > Unfortunately, this patch won't even apply with 2.6.26-rc5 as the code
> > > seems to have changed a lot between that date and today. For instance,
> > > there doesn't seem to exist a function called "rt2500usb_config_mac_addr"
> > > in the rt2x00 directory (just did a grep on my unconnected iBook).
> > 
> > That patch was a bugfix for 2.6.25. The bug it fixed isn't present in
> > the 2.6.26 cycle.
> 
> Nice to know that. I saw that the code has changed quite a good amount...

Hehe, yes rt2x00 code is moving quit a lot per kernel release.

> Anyway, I don't know if you saw the various outputs that I put at my
> homepage (lots of dmesgs with the 2.6.26-rc4 kernel):
> http://www.ime.usp.br/~rbrito/debug/

Yeah, saw them.

> > > I don't know if the firmware is needed in my case or not, though (my USB
> > > adaptor is a D-Link DWL-G122 H/W Ver. B1, F/W Ver.: 2.03---took that info
> > > from the back of the stick).
> > 
> > Which driver is actually being used? rt2500usb or rt73usb?
> 
> The driver that actually gets loaded is rt2500usb. I tried rmmod'ing
> rt2500usb and loading rt73usb, but a quick iwconfig doesn't even show
> the interfaces.

That means it really is a rt2500usb device. ;)

> > Also what was the last kernel version on which the driver worked for
> > you?
> 
> Unfortunately, I don't have any kernel for which this has worked for
> me. I just did an experiment: I plugged the adaptor on a ia32 notebook
> where a rt61pci works fine (it is running Ubuntu's Hardy---well,
> actually, there are some problems, but I can get to that latter), but
> the USB key was non working with the symptoms that I described above.

That is most unfortunate, since register dumps are usually most usefull when
I can compare the actual register values between a working and non-working setup.
However I just realized I had a D-Link stick myself, and apparently I have the exact
same model/type. I'll compile a 2.6.26-rc5 kernel and see if that stick works for me,
if so, I have the working register dump. And if not, then we can rule out endian problems.

> > If there was a last known working kernel, could you download the debugfs script:
> > 	http://rt2x00.serialmonkey.com/phpBB/download/file.php?id=1969
> > enable debugfs and MAC80211_DEBUGFS and RT2X00_LIB_DEBUGFS in your kernel,
> > and run the script to dump all registers from the hardware to a file?
> 
> I just grabbed the script. Here is the output with the options enabled
> and the results are attached here.

Thanks.

Ivo
