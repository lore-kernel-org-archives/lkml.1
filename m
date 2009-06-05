Return-Path: <linux-kernel-owner+w=401wt.eu-S1755307AbZFEOCx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755307AbZFEOCx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Jun 2009 10:02:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752254AbZFEOCo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Jun 2009 10:02:44 -0400
Received: from mail-ew0-f210.google.com ([209.85.219.210]:49694 "EHLO
	mail-ew0-f210.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751162AbZFEOCn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Jun 2009 10:02:43 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=v9XHKqdfJ9K1VlwFx9Z7zYk9WKWVzQCh6ZfxclRvPaVnCakM/fBexFMUP86Y7wGZt2
         YFFmwWRPoDAJdDIUKG5yhotD4ELuw0pjN1VGZOv2Iv3cFWCJHZudY8ZU5mLEnUngVux4
         HUi0n4N/f5QBlqIdCFKt7N/vpzKHxM9hr4HZQ=
MIME-Version: 1.0
In-Reply-To: <20090605142153.1895fac5@lxorguk.ukuu.org.uk>
References: <c5bd819b0906021525l13ee9282j1fb270e141985f66@mail.gmail.com>
	 <c5bd819b0906030552w6f23185etb394f83c8b630e6@mail.gmail.com>
	 <20090603140140.491a8ea8@lxorguk.ukuu.org.uk>
	 <c5bd819b0906030639o5f9c34ffg500e132d3a0b5117@mail.gmail.com>
	 <c5bd819b0906040750w75e0389cod2a03b89ce838d1b@mail.gmail.com>
	 <20090605100505.41b3b818@lxorguk.ukuu.org.uk>
	 <c5bd819b0906050335i4e813887sc8f4d901da86a1aa@mail.gmail.com>
	 <20090605114245.175499e1@lxorguk.ukuu.org.uk>
	 <c5bd819b0906050543l42320f0r44e0306a7638b1b9@mail.gmail.com>
	 <20090605142153.1895fac5@lxorguk.ukuu.org.uk>
Date: Fri, 5 Jun 2009 16:02:43 +0200
Message-ID: <c5bd819b0906050702o6051fa1dh3673e94119142f55@mail.gmail.com>
Subject: Re: Kernel 2.6.30rc7 limits IDE to UDMA33
From: Grozdan <neutrino8@gmail.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: hancockrwd@gmail.com, linux-kernel@vger.kernel.org,
       linux-ide@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/6/5 Alan Cox <alan@lxorguk.ukuu.org.uk>:
>> older kernels have no problems setting the correct UDMA while 2.6.30
>> does have problems. Something must have definitely changed in this
>> latest kernel. I'll go dig in my BIOS to see if I may need to
>> change/force something.
>
> Unless you can actually work through the various kernels and release
> candidates to find the one it changes its basically impossible to tell
> what has occurred or why.
>

Well, I looked around in the BIOS and there isn't anything I can do to
force a specific UDMA - it only offers disable and auto detect.
Upgrading the BIOS firware won't do a thing since I'm already running
the latest version of it. The BIOS correctly reports that my first
disk is using Transfer Mode 6 and my second one Transfer Mode 5. I've
also noticed that some Ubuntu users have the same problem on kernel
2.6.27 (which works for me)

https://bugs.launchpad.net/ubuntu/+source/linux/+bug/285595

So if this can't be fixed in the kernel itself, I may need to resort
to kernel params if I experience the problem again in the future. I
may give all rc's of 2.6.30 a try and see which one introduces it...
