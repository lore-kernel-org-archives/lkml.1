Return-Path: <linux-kernel-owner+w=401wt.eu-S1756105AbYEOMIu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756105AbYEOMIu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2008 08:08:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751640AbYEOMIk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 May 2008 08:08:40 -0400
Received: from rv-out-0506.google.com ([209.85.198.239]:53044 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751514AbYEOMIj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2008 08:08:39 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=i9rstpgOK8gjUd6W5bsivWBhJ1MvcUcSFvgI7Pd4/YZrUE65mROF5ZlG3sdEUaQEvS88u/1Jmsjp3N5vAJvsmEDHtsIzF2+ZI6WGo/o9GX1X08G8LVCD0k8VivHhfT5f1r6vhHYyWv0HIM/DMgPpnjPdge0cnhYbb/fG5XMc6hE=
Message-ID: <38b2ab8a0805150508j5adc4755n8eb378b414b2dc03@mail.gmail.com>
Date: Thu, 15 May 2008 14:08:39 +0200
From: "Francis Moreau" <francis.moro@gmail.com>
To: "Arnd Hannemann" <arnd@arndnet.de>
Subject: Re: How to avoid data copies in a driver ?
Cc: "linux-os (Dick Johnson)" <linux-os@analogic.com>,
       linux-kernel@vger.kernel.org
In-Reply-To: <482C2383.5070206@arndnet.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <38b2ab8a0805141254i2437a0ccq130b914748f53db0@mail.gmail.com>
	 <Pine.LNX.4.61.0805141716120.11052@chaos.analogic.com>
	 <38b2ab8a0805150040s6933de14p7c2014945ba0810d@mail.gmail.com>
	 <482C2383.5070206@arndnet.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 15, 2008 at 1:50 PM, Arnd Hannemann <arnd@arndnet.de> wrote:
> Francis Moreau wrote:
>> Hello,
>>
>> On Wed, May 14, 2008 at 11:23 PM, linux-os (Dick Johnson)
>> <linux-os@analogic.com> wrote:
>>> You memory-map the data. Impliment mmap() in your driver.
>>> You can also impliment poll()  { select() } so your
>>> application knows when new data are available.
>>>
>>> You cannot use a user-mode file-descriptor in the kernel.
>>>
>>
>> Why not ?
>
> http://kernelnewbies.org/FAQ/WhyWritingFilesFromKernelIsBad
>

ok, relayfs might be what I need, thanks.

>>
>> I'm suprised because what I need doens't seem so uncommon, usually
>> devices send or
>> receive data to/from files. So a helper (system call ?) to achieve
>> that other than the basic
>> read/write seems needed, no ?
>
> Usually devices send or receive just data, and they shouldn't care about
> file format, filesystems, permissions and all this stuff...
>

The fact is that the data usually ends into a file.

thanks
-- 
Francis
