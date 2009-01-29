Return-Path: <linux-kernel-owner+w=401wt.eu-S1757862AbZA2VTi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757862AbZA2VTi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2009 16:19:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752832AbZA2VT3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Jan 2009 16:19:29 -0500
Received: from mx0.towertech.it ([213.215.222.73]:57654 "HELO mx0.towertech.it"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751678AbZA2VT2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2009 16:19:28 -0500
Date: Thu, 29 Jan 2009 22:19:25 +0100
From: Alessandro Zummo <alessandro.zummo@towertech.it>
To: Ed Swierk <eswierk@aristanetworks.com>
Cc: rtc-linux@googlegroups.com, tglx@linutronix.de, mingo@redhat.com,
       linux-kernel@vger.kernel.org
Subject: Re: [rtc-linux] Re: [PATCH] x86: i2c rtc instead of cmos rtc
Message-ID: <20090129221925.07f5ab31@i1501.lan.towertech.it>
In-Reply-To: <9ae48b020901291312v459b4cddg4a991de2d4ef54bf@mail.gmail.com>
References: <1233018263.14510.112.camel@localhost.localdomain>
	<20090127122156.784924f4@i1501.lan.towertech.it>
	<9ae48b020901291121n319be519o473db5fdc031ea8f@mail.gmail.com>
	<20090129204104.60bf46a2@i1501.lan.towertech.it>
	<9ae48b020901291205ie0db5abj1a8c06528b9b46e8@mail.gmail.com>
	<20090129211159.78714c5c@i1501.lan.towertech.it>
	<9ae48b020901291312v459b4cddg4a991de2d4ef54bf@mail.gmail.com>
Organization: Tower Technologies
X-Mailer: Sylpheed
X-This-Is-A-Real-Message: Yes
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 29 Jan 2009 13:12:49 -0800
Ed Swierk <eswierk@aristanetworks.com> wrote:

> >  I object to options of this kind. It took us a lot of efforts to move
> >  to the new i2c model and to the concept that devices have to be declared
> >  in the board support code. This kind of hack is in the opposite direction.  
> 
> I see. I encountered board support code when I worked with PowerPC
> boards on Linux years ago but I haven't seen this in the x86 arch
> code. Can you point me to an example?

 Under x86 the thing is not well defined, but you can check 

 arch/x86/kernel/olpc.c

 for an example.

 If you just have to load different modules I'd use an initrd
 where you can place all the necessary logic to detect your board
 

-- 

 Best regards,

 Alessandro Zummo,
  Tower Technologies - Torino, Italy

  http://www.towertech.it

