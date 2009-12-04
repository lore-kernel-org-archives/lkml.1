Return-Path: <linux-kernel-owner+w=401wt.eu-S1752280AbZLDSWX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752280AbZLDSWX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Dec 2009 13:22:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751471AbZLDSWU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Dec 2009 13:22:20 -0500
Received: from mail-yw0-f198.google.com ([209.85.211.198]:47049 "EHLO
	mail-yw0-f198.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751061AbZLDSWT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Dec 2009 13:22:19 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=NHveqT8iU6SY/TksFBNvYKb/KExwICvnh6IXtz+jcoGuEhsgZ8pAr2hwKG8buF5VDe
         lePVP/Ks6F5qHZUuU+dpymMbMcy+XRjbTGufSWZKZpymY3WymPEqklsqnsLykzVYnui/
         qtvkUGZkTjlejWvuHns4kOrDuejH1DeGBhUZg=
Message-ID: <4B195361.5030301@gmail.com>
Date: Fri, 04 Dec 2009 10:22:25 -0800
From: "Justin P. Mattock" <justinmattock@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20091114 Lightning/1.0pre Thunderbird/3.0b4
MIME-Version: 1.0
To: Oliver Neukum <oliver@neukum.org>
CC: Alan Stern <stern@rowland.harvard.edu>,
       Robert Hancock <hancockrwd@gmail.com>,
       Linux-usb <linux-usb@vger.kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: root hub lost power or was reset
References: <Pine.LNX.4.44L0.0912031014190.4795-100000@iolanthe.rowland.org> <200912031745.26389.oliver@neukum.org>
In-Reply-To: <200912031745.26389.oliver@neukum.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/03/09 08:45, Oliver Neukum wrote:
> Am Donnerstag, 3. Dezember 2009 16:16:58 schrieb Alan Stern:
>> And it seems to be very widespread.  I haven't seen more than a handful
>> of systems which _don't_ cut power or reset their UHCI controllers
>> during S3 sleep.
>
> Yes, nevertheless it is most annoying. I wonder whether we could
> get BIOS writers to export this feature via ACPI.
>
> 	Regards
> 		Oliver
>

after thinking abit on this
when using suspend on osx(apple)
you can wake the machine by pressing
the space bar.. my guess is this is why
the usb is probably doing what it's doing
(but could be wrong).

when I get time, I'll see if acpid
is capable of doing such thing.

Justin P. Mattock
