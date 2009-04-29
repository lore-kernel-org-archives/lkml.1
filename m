Return-Path: <linux-kernel-owner+w=401wt.eu-S1753691AbZD2Xiv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753691AbZD2Xiv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Apr 2009 19:38:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752280AbZD2Xik
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Apr 2009 19:38:40 -0400
Received: from mail-gx0-f166.google.com ([209.85.217.166]:42135 "EHLO
	mail-gx0-f166.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752010AbZD2Xij (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Apr 2009 19:38:39 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=RXv0hfILBUIPhxpaObkjMqxLp+m8C9mm3AGsh/m+z7IDohUVbjKF+4rx0PQU66QITi
         7MEH/sVOAjc13Cihsbn5BgCrSc3MPghV7/gEwLaO+igMBlElrLVVoFt0v8rmxDxPuptL
         Kznl2iKyzDwfaeaePqdaqb5uAbcpaIrfkCVfU=
MIME-Version: 1.0
In-Reply-To: <20090429183012.GA28237@kroah.com>
References: <20090427193532.GA2948@kroah.com>
	 <8bd0f97a0904291053g3aa71decpd33f6621ad0bf9f8@mail.gmail.com>
	 <20090429180735.GA29812@kroah.com>
	 <8bd0f97a0904291117ic07fadcs2a02fca3dcfefcf0@mail.gmail.com>
	 <20090429183012.GA28237@kroah.com>
Date: Wed, 29 Apr 2009 19:38:38 -0400
Message-ID: <8bd0f97a0904291638p398ad701j5dc0f8e96de2fb47@mail.gmail.com>
Subject: Re: usbutils 0.81 release
From: Mike Frysinger <vapier.adi@gmail.com>
To: Greg KH <greg@kroah.com>
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 29, 2009 at 14:30, Greg KH wrote:
> On Wed, Apr 29, 2009 at 02:17:12PM -0400, Mike Frysinger wrote:
>> >> find being able to run `usbmodules` pretty useful ... i wrote a script
>> >> for fun:
>> >> http://sources.gentoo.org/sys-apps/usbutils/files/usbmodules.sh
>> >
>> > Did that work on any 2.6 kernel?
>>
>> it's the only version ive tested it with ... but it doesnt parse any
>> kernel module directly, it reads the generated modules.usbmap file
>>
>> > There's no reason we can't add "-k" support to lsusb like lspci has to
>> > show the modules assigned to different devices.
>>
>> the method i posted above only needs the module to be compiled, not loaded
>
> As the map files are depreciated, I wouldn't continue to rely on it, it
> will break in the future when the kernel stops generating those files.

guess i'll have to rewrite it to parse the .ko modules directly like
the usbmap is generated now
-mike
