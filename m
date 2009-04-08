Return-Path: <linux-kernel-owner+w=401wt.eu-S1764632AbZDHUuF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764632AbZDHUuF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Apr 2009 16:50:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760805AbZDHUtu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Apr 2009 16:49:50 -0400
Received: from mail-qy0-f118.google.com ([209.85.221.118]:45626 "EHLO
	mail-qy0-f118.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757671AbZDHUtt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Apr 2009 16:49:49 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=x3/bQVDfGNQAlI3BmBzIoS/lpuhEICEC59SvUQtc+/Uk37GiRk0I/L094gPatsTjQK
         GXyvu7F2yphCbbusXSATVIhv7P+zoBsKzVQtvc9NqFd8rky7MW7UXxyeqW8thWmfdgLB
         lRgJ2B52MPwqdfD3fi8NzOJ66yiq8NgCXc7ZE=
MIME-Version: 1.0
In-Reply-To: <20090408125037.549C1FC351@magilla.sf.frob.com>
References: <20090408062106.39EE0FC3E5@magilla.sf.frob.com>
	 <ce0170d90904080026x4e292ce7sfae4eea70eb386cd@mail.gmail.com>
	 <20090408125037.549C1FC351@magilla.sf.frob.com>
Date: Wed, 8 Apr 2009 17:49:46 -0300
Message-ID: <ce0170d90904081349t3dbe2750u8dac243e1b729e2b@mail.gmail.com>
Subject: Re: [PATCH] ptrace: checkpatch fixes
From: Sergio Luis <eeeesti@gmail.com>
To: Roland McGrath <roland@redhat.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 8, 2009 at 9:50 AM, Roland McGrath <roland@redhat.com> wrote:
>> silly question, but... how do you verify that? is there any tool under
>> scripts/ that do that comparison?
>
> I didn't use any script, there might be done, I don't know.
> I compared "objdump -rd" output on the .o file before and after, using diff.
>
>
> Thanks,
> Roland
>

Ah, I see. I had written a silly objdiff scritp that was using objdump
-D output for comparison, and there were a few differences, that's why
I was wondering what would be the right way to verify that.

Thanks,
Sergio.
