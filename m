Return-Path: <linux-kernel-owner+w=401wt.eu-S1758466AbYEOLuo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758466AbYEOLuo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2008 07:50:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754803AbYEOLue
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 May 2008 07:50:34 -0400
Received: from slowhand.arndnet.de ([88.198.19.76]:35565 "EHLO mail.unitix.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754469AbYEOLud (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2008 07:50:33 -0400
Message-ID: <482C2383.5070206@arndnet.de>
Date: Thu, 15 May 2008 13:50:27 +0200
From: Arnd Hannemann <arnd@arndnet.de>
User-Agent: Thunderbird 2.0.0.14 (X11/20080505)
MIME-Version: 1.0
To: Francis Moreau <francis.moro@gmail.com>
CC: "linux-os (Dick Johnson)" <linux-os@analogic.com>,
       linux-kernel@vger.kernel.org
Subject: Re: How to avoid data copies in a driver ?
References: <38b2ab8a0805141254i2437a0ccq130b914748f53db0@mail.gmail.com> <Pine.LNX.4.61.0805141716120.11052@chaos.analogic.com> <38b2ab8a0805150040s6933de14p7c2014945ba0810d@mail.gmail.com>
In-Reply-To: <38b2ab8a0805150040s6933de14p7c2014945ba0810d@mail.gmail.com>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Francis Moreau wrote:
> Hello,
> 
> On Wed, May 14, 2008 at 11:23 PM, linux-os (Dick Johnson)
> <linux-os@analogic.com> wrote:
>> You memory-map the data. Impliment mmap() in your driver.
>> You can also impliment poll()  { select() } so your
>> application knows when new data are available.
>>
>> You cannot use a user-mode file-descriptor in the kernel.
>>
> 
> Why not ?

http://kernelnewbies.org/FAQ/WhyWritingFilesFromKernelIsBad

> 
> I'm suprised because what I need doens't seem so uncommon, usually
> devices send or
> receive data to/from files. So a helper (system call ?) to achieve
> that other than the basic
> read/write seems needed, no ?

Usually devices send or receive just data, and they shouldn't care about
file format, filesystems, permissions and all this stuff...

Regards,
Arnd

